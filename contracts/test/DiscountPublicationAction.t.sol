// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {DiscountPublicationAction} from "src/DiscountPublicationAction.sol";
import {ModuleGlobals} from "src/vendor/lens/v2/misc/ModuleGlobals.sol";
import {MockLinkToken} from "src/vendor/chainlink/v0.8/mocks/MockLinkToken.sol";
import {FunctionsRouter} from "src/vendor/chainlink/v0.8/functions/dev/v1_0_0/FunctionsRouter.sol";
import {FunctionsCoordinator, FunctionsBilling} from "src/vendor/chainlink/v0.8/functions/dev/v1_0_0/FunctionsCoordinator.sol";
import {Types} from "src/vendor/lens/v2/libraries/constants/Types.sol";
import {SafeCast} from "src/vendor/openzeppelin/contracts/utils/math/SafeCast.sol";
import {Strings} from "src/vendor/openzeppelin/contracts/utils/Strings.sol";
import {StringUtilsLib} from "src/vendor/string-utils-lib/StringUtilsLib.sol";
import {JsSource} from "./JsSource.sol";

contract MockLinkToNativeDataFeed {
    function latestRoundData()
        public
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (1, 12000000000000000000, block.timestamp, block.timestamp, 1);
    }
}

contract DiscountPublicationActionTest is Test {
    DiscountPublicationAction discountPublicationAction;
    ModuleGlobals moduleGlobals;
    MockLinkToken linkToken;
    FunctionsRouter functionsRouter;
    FunctionsCoordinator functionsCoordinator;
    address mockLensHub;

    string constant PERCENTAGE_OFF = "100";
    string constant QUANTITY_AVAILABLE = "1";

    function setUp() public {
        linkToken = new MockLinkToken();
        mockLensHub = makeAddr("hub");

        address governance = makeAddr("governance");
        address treasury = makeAddr("treasury");
        uint16 treasuryFee = 0;
        moduleGlobals = new ModuleGlobals(governance, treasury, treasuryFee);

        uint32[] memory maxCallbackGasLimits = new uint32[](12);
        maxCallbackGasLimits[0] = 300000;
        maxCallbackGasLimits[1] = 500000;
        maxCallbackGasLimits[2] = 750000;
        maxCallbackGasLimits[3] = 1000000;
        maxCallbackGasLimits[4] = 1500000;
        maxCallbackGasLimits[5] = 2000000;
        maxCallbackGasLimits[6] = 2500000;
        maxCallbackGasLimits[7] = 3000000;
        maxCallbackGasLimits[8] = 3500000;
        maxCallbackGasLimits[9] = 4000000;
        maxCallbackGasLimits[10] = 4500000;
        maxCallbackGasLimits[11] = 5000000;

        FunctionsRouter.Config memory config = FunctionsRouter.Config({
            maxConsumersPerSubscription: 100,
            adminFee: 200000000000000000,
            handleOracleFulfillmentSelector: 0x0ca76175,
            gasForCallExactCheck: 5000,
            maxCallbackGasLimits: maxCallbackGasLimits,
            subscriptionDepositMinimumRequests: 10,
            subscriptionDepositJuels: 2000000000000000000
        });

        functionsRouter = new FunctionsRouter(address(linkToken), config);

        FunctionsBilling.Config memory billingConfig = FunctionsBilling.Config({
            fulfillmentGasPriceOverEstimationBP: 90000,
            feedStalenessSeconds: 86400,
            gasOverheadBeforeCallback: 105000,
            gasOverheadAfterCallback: 40000,
            requestTimeoutSeconds: 300,
            donFee: 0,
            maxSupportedRequestDataVersion: 1,
            fallbackNativePerUnitLink: 5000000000000000
        });

        MockLinkToNativeDataFeed linkToNativeFeed = new MockLinkToNativeDataFeed();

        functionsCoordinator = new FunctionsCoordinator(
            address(functionsRouter),
            billingConfig,
            address(linkToNativeFeed)
        );

        uint32 gasLimit = 100000;
        string memory donId = "fun-polygon-mumbai-1";
        bytes32 jobId = bytes32(bytes(donId));

        bytes32[] memory jobIds = new bytes32[](1);
        jobIds[0] = jobId;
        address[] memory coordinators = new address[](1);
        coordinators[0] = address(functionsCoordinator);

        functionsRouter.proposeContractsUpdate(jobIds, coordinators);
        functionsRouter.updateContracts();

        uint64 subscriptionId = functionsRouter.createSubscription();

        discountPublicationAction = new DiscountPublicationAction(
            mockLensHub,
            address(moduleGlobals),
            address(functionsRouter),
            subscriptionId,
            gasLimit,
            jobId
        );

        functionsRouter.addConsumer(
            subscriptionId,
            address(discountPublicationAction)
        );

        linkToken.transferAndCall(
            address(functionsRouter),
            1 ether,
            abi.encode(subscriptionId)
        );
    }

    function ffi_functionsSimulate(
        string memory eventId,
        string memory organizationId,
        string memory lensUserAddress
    ) public returns (string memory discountCode) {
        string[] memory inputs = new string[](7);

        inputs[0] = "node";
        inputs[1] = "simulateRequest.js";
        inputs[2] = organizationId;
        inputs[3] = eventId;
        inputs[4] = lensUserAddress;
        inputs[5] = PERCENTAGE_OFF;
        inputs[6] = QUANTITY_AVAILABLE;

        bytes memory res = vm.ffi(inputs);
        string memory response = string(res);

        console.log(response);

        uint256 length = StringUtilsLib.length(response);

        (, int256 start) = StringUtilsLib.matchStr(response, "DISCOUNT_CODE_");

        discountCode = StringUtilsLib.substring(
            response,
            uint(start),
            length - 1
        );
    }

    function testIntegration() external {
        uint256 pubId = 777;
        uint256 profileId = 1;
        address transactionExecutor = makeAddr("transactionExecutor");

        uint8 donHostedSecretsSlotID = 0;
        uint64 donHostedSecretsVersion = SafeCast.toUint64(block.timestamp);
        bytes memory initData = abi.encode(
            donHostedSecretsSlotID,
            donHostedSecretsVersion,
            PERCENTAGE_OFF,
            QUANTITY_AVAILABLE
        );

        vm.prank(mockLensHub);
        discountPublicationAction.initializePublicationAction(
            profileId,
            pubId,
            transactionExecutor,
            initData
        );

        address actorProfileOwner = 0xed4AE5Eb2a93658852343385A0B28a2B66a07697;
        uint256 actorProfileId = 0x01;

        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/args.json");
        string memory json = vm.readFile(path);
        string memory eventId = string(vm.parseJson(json, ".eventId"));
        string memory organizationId = string(
            vm.parseJson(json, ".organizationId")
        );

        string memory javaScriptSource = JsSource.JS_SOURCE;

        Types.ProcessActionParams memory processActionParams = Types
            .ProcessActionParams({
                publicationActedProfileId: profileId,
                publicationActedId: pubId,
                actorProfileId: actorProfileId,
                actorProfileOwner: actorProfileOwner,
                transactionExecutor: transactionExecutor,
                referrerProfileIds: new uint256[](0),
                referrerPubIds: new uint256[](0),
                referrerPubTypes: new Types.PublicationType[](0),
                actionModuleData: abi.encode(
                    organizationId,
                    eventId,
                    javaScriptSource
                )
            });

        vm.prank(mockLensHub);
        bytes memory returnData = discountPublicationAction
            .processPublicationAction(processActionParams);

        bytes32 requestId = abi.decode(returnData, (bytes32));

        string memory simulationResponse = ffi_functionsSimulate(
            "1748361736953", // @Dev TODO Put your eventId here
            "710604425967", //  @Dev TODO  Put your organizationId here
            Strings.toHexString(actorProfileOwner)
        );

        vm.prank(address(functionsRouter));
        discountPublicationAction.handleOracleFulfillment(
            requestId,
            bytes(simulationResponse),
            ""
        );

        string memory discountCode = discountPublicationAction.getDiscountCode(
            actorProfileOwner,
            eventId
        );

        assertEq(simulationResponse, discountCode);
    }
}
