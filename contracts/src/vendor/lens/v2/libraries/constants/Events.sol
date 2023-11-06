// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0;

import {Types} from "../constants/Types.sol";

library Events {
    /**
     * @dev Emitted when the NFT contract's name and symbol are set at initialization.
     *
     * @param name The NFT name set.
     * @param symbol The NFT symbol set.
     * @param timestamp The current block timestamp.
     */
    event BaseInitialized(string name, string symbol, uint256 timestamp);

    /**
     * @dev Emitted when the hub state is set.
     *
     * @param caller The caller who set the state.
     * @param prevState The previous protocol state, an enum of either `Paused`, `PublishingPaused` or `Unpaused`.
     * @param newState The newly set state, an enum of either `Paused`, `PublishingPaused` or `Unpaused`.
     * @param timestamp The current block timestamp.
     */
    event StateSet(
        address indexed caller,
        Types.ProtocolState indexed prevState,
        Types.ProtocolState indexed newState,
        uint256 timestamp
    );

    /**
     * @dev Emitted when the governance address is changed. We emit the caller even though it should be the previous
     * governance address, as we cannot guarantee this will always be the case due to upgradeability.
     *
     * @param caller The caller who set the governance address.
     * @param prevGovernance The previous governance address.
     * @param newGovernance The new governance address set.
     * @param timestamp The current block timestamp.
     */
    event GovernanceSet(
        address indexed caller,
        address indexed prevGovernance,
        address indexed newGovernance,
        uint256 timestamp
    );

    /**
     * @dev Emitted when the emergency admin is changed. We emit the caller even though it should be the previous
     * governance address, as we cannot guarantee this will always be the case due to upgradeability.
     *
     * @param caller The caller who set the emergency admin address.
     * @param oldEmergencyAdmin The previous emergency admin address.
     * @param newEmergencyAdmin The new emergency admin address set.
     * @param timestamp The current block timestamp.
     */
    event EmergencyAdminSet(
        address indexed caller,
        address indexed oldEmergencyAdmin,
        address indexed newEmergencyAdmin,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a profile creator is added to or removed from the whitelist.
     *
     * @param profileCreator The address of the profile creator.
     * @param whitelisted Whether or not the profile creator is being added to the whitelist.
     * @param timestamp The current block timestamp.
     */
    event ProfileCreatorWhitelisted(
        address indexed profileCreator,
        bool indexed whitelisted,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a follow module is added to or removed from the whitelist.
     *
     * @param followModule The address of the follow module.
     * @param whitelisted Whether or not the follow module is being added to the whitelist.
     * @param timestamp The current block timestamp.
     */
    event FollowModuleWhitelisted(
        address indexed followModule,
        bool indexed whitelisted,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a reference module is added to or removed from the whitelist.
     *
     * @param referenceModule The address of the reference module.
     * @param whitelisted Whether or not the reference module is being added to the whitelist.
     * @param timestamp The current block timestamp.
     */
    event ReferenceModuleWhitelisted(
        address indexed referenceModule,
        bool indexed whitelisted,
        uint256 timestamp
    );

    /**
     * @dev Emitted when an action module is added to or removed from the whitelist.
     *
     * @param actionModule The address of the action module.
     * @param id Id of the whitelisted action module.
     * @param whitelisted Whether or not the action module is being added to the whitelist.
     * @param timestamp The current block timestamp.
     */
    event ActionModuleWhitelisted(
        address indexed actionModule,
        uint256 indexed id,
        bool indexed whitelisted,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a profile is created.
     *
     * @param profileId The newly created profile's token ID.
     * @param creator The profile creator, who created the token with the given profile ID.
     * @param to The address receiving the profile with the given profile ID.
     * @param imageURI The image URI set for the profile.
     * @param followModule The profile's newly set follow module. This CAN be the zero address.
     * @param followModuleReturnData The data returned from the follow module's initialization. This is ABI-encoded
     * and totally depends on the follow module chosen.
     * @param timestamp The current block timestamp.
     */
    event ProfileCreated(
        uint256 indexed profileId,
        address indexed creator,
        address indexed to,
        string imageURI,
        address followModule,
        bytes followModuleReturnData,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a delegated executors configuration is changed.
     *
     * @param delegatorProfileId The ID of the profile for which the delegated executor was changed.
     * @param configNumber The number of the configuration where the executor approval state was set.
     * @param delegatedExecutors The array of delegated executors whose approval was set for.
     * @param approvals The array of booleans indicating the corresponding executor new approval status.
     * @param configSwitched A boolean indicating if the configuration was switched to the one emitted in the
     * `configNumber` parameter.
     * @param timestamp The current block timestamp.
     */
    event DelegatedExecutorsConfigChanged(
        uint256 indexed delegatorProfileId,
        uint256 indexed configNumber,
        address[] delegatedExecutors,
        bool[] approvals,
        bool indexed configSwitched,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a profile's URI is set.
     *
     * @param profileId The token ID of the profile for which the URI is set.
     * @param imageURI The URI set for the given profile.
     * @param timestamp The current block timestamp.
     */
    event ProfileImageURISet(
        uint256 indexed profileId,
        string imageURI,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a profile's follow module is set.
     *
     * @param profileId The profile's token ID.
     * @param followModule The profile's newly set follow module. This CAN be the zero address.
     * @param followModuleReturnData The data returned from the follow module's initialization. This is ABI-encoded
     * and depends on the follow module chosen.
     * @param timestamp The current block timestamp.
     */
    event FollowModuleSet(
        uint256 indexed profileId,
        address followModule,
        bytes followModuleReturnData,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a post is successfully published.
     *
     * @param postParams The parameters passed to create the post publication.
     * @param pubId The publication ID assigned to the created post.
     * @param actionModulesInitReturnDatas The data returned from the action modules' initialization for this given
     * publication. This is ABI-encoded and depends on the action module chosen.
     * @param referenceModuleInitReturnData The data returned from the reference module at initialization. This is
     * ABI-encoded and depends on the reference module chosen.
     * @param timestamp The current block timestamp.
     */
    event PostCreated(
        Types.PostParams postParams,
        uint256 indexed pubId,
        bytes[] actionModulesInitReturnDatas,
        bytes referenceModuleInitReturnData,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a comment is successfully published.
     *
     * @param commentParams The parameters passed to create the comment publication.
     * @param pubId The publication ID assigned to the created comment.
     * @param referenceModuleReturnData The data returned by the commented publication reference module's
     * processComment function, if the commented publication has a reference module set.
     * @param actionModulesInitReturnDatas The data returned from the action modules' initialization for this given
     * publication. This is ABI-encoded and depends on the action module chosen.
     * @param referenceModuleInitReturnData The data returned from the reference module at initialization. This is
     * ABI-encoded and depends on the reference module chosen.
     * @param timestamp The current block timestamp.
     */
    event CommentCreated(
        Types.CommentParams commentParams,
        uint256 indexed pubId,
        bytes referenceModuleReturnData,
        bytes[] actionModulesInitReturnDatas,
        bytes referenceModuleInitReturnData,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a mirror is successfully published.
     *
     * @param mirrorParams The parameters passed to create the mirror publication.
     * @param pubId The publication ID assigned to the created mirror.
     * @param referenceModuleReturnData The data returned by the mirrored publication reference module's
     * processMirror function, if the mirrored publication has a reference module set.
     * @param timestamp The current block timestamp.
     */
    event MirrorCreated(
        Types.MirrorParams mirrorParams,
        uint256 indexed pubId,
        bytes referenceModuleReturnData,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a quote is successfully published.
     *
     * @param quoteParams The parameters passed to create the quote publication.
     * @param pubId The publication ID assigned to the created quote.
     * @param referenceModuleReturnData The data returned by the quoted publication reference module's
     * processQuote function, if the quoted publication has a reference module set.
     * @param actionModulesInitReturnDatas The data returned from the action modules' initialization for this given
     * publication. This is ABI-encoded and depends on the action module chosen.
     * @param referenceModuleInitReturnData The data returned from the reference module at initialization. This is
     * ABI-encoded and depends on the reference module chosen.
     * @param timestamp The current block timestamp.
     */
    event QuoteCreated(
        Types.QuoteParams quoteParams,
        uint256 indexed pubId,
        bytes referenceModuleReturnData,
        bytes[] actionModulesInitReturnDatas,
        bytes referenceModuleInitReturnData,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a followNFT clone is deployed using a lazy deployment pattern.
     *
     * @param profileId The token ID of the profile to which this followNFT is associated.
     * @param followNFT The address of the newly deployed followNFT clone.
     * @param timestamp The current block timestamp.
     */
    event FollowNFTDeployed(
        uint256 indexed profileId,
        address indexed followNFT,
        uint256 timestamp
    );

    /**
     * @dev Emitted when a collectNFT clone is deployed using a lazy deployment pattern.
     *
     * @param profileId The publisher's profile token ID.
     * @param pubId The publication associated with the newly deployed collectNFT clone's ID.
     * @param collectNFT The address of the newly deployed collectNFT clone.
     * @param timestamp The current block timestamp.
     */
    event CollectNFTDeployed(
        uint256 indexed profileId,
        uint256 indexed pubId,
        address indexed collectNFT,
        uint256 timestamp
    );

    /**
     * @dev Emitted upon a successful collect action.
     *
     * @param collectActionParams The parameters passed to collect a publication.
     * @param collectModule The collect module that was used to collect the publication.
     * @param collectNFT The collect NFT that was used to collect the publication.
     * @param tokenId The token ID of the collect NFT that was minted as a collect of the publication.
     * @param collectActionResult The data returned from the collect module's collect action. This is ABI-encoded
     * and depends on the collect module chosen.
     * @param timestamp The current block timestamp.
     */
    event Collected(
        Types.ProcessActionParams collectActionParams,
        address collectModule,
        address collectNFT,
        uint256 tokenId,
        bytes collectActionResult,
        uint256 timestamp
    );

    /**
     * @dev Emitted upon a successful action.
     *
     * @param publicationActionParams The parameters passed to act on a publication.
     * @param actionModuleReturnData The data returned from the action modules. This is ABI-encoded and the format
     * depends on the action module chosen.
     * @param timestamp The current block timestamp.
     */
    event Acted(
        Types.PublicationActionParams publicationActionParams,
        bytes actionModuleReturnData,
        uint256 timestamp
    );

    /**
     * @dev Emitted upon a successful follow operation.
     *
     * @param followerProfileId The ID of the profile that executed the follow.
     * @param idOfProfileFollowed The ID of the profile that was followed.
     * @param followTokenIdAssigned The ID of the follow token assigned to the follower.
     * @param followModuleData The data to passed to the follow module, if any.
     * @param processFollowModuleReturnData The data returned by the followed profile follow module's processFollow
     * function, if the followed profile has a reference module set.
     * @param timestamp The timestamp of the follow operation.
     */
    event Followed(
        uint256 indexed followerProfileId,
        uint256 idOfProfileFollowed,
        uint256 followTokenIdAssigned,
        bytes followModuleData,
        bytes processFollowModuleReturnData,
        uint256 timestamp
    );

    /**
     * @dev Emitted upon a successful unfollow operation.
     *
     * @param unfollowerProfileId The ID of the profile that executed the unfollow.
     * @param idOfProfileUnfollowed The ID of the profile that was unfollowed.
     * @param timestamp The timestamp of the unfollow operation.
     */
    event Unfollowed(
        uint256 indexed unfollowerProfileId,
        uint256 idOfProfileUnfollowed,
        uint256 timestamp
    );

    /**
     * @dev Emitted upon a successful block, through a block status setting operation.
     *
     * @param byProfileId The ID of the profile that executed the block status change.
     * @param idOfProfileBlocked The ID of the profile whose block status have been set to blocked.
     * @param timestamp The timestamp of the block operation.
     */
    event Blocked(
        uint256 indexed byProfileId,
        uint256 idOfProfileBlocked,
        uint256 timestamp
    );

    /**
     * @dev Emitted upon a successful unblock, through a block status setting operation.
     *
     * @param byProfileId The ID of the profile that executed the block status change.
     * @param idOfProfileUnblocked The ID of the profile whose block status have been set to unblocked.
     * @param timestamp The timestamp of the unblock operation.
     */
    event Unblocked(
        uint256 indexed byProfileId,
        uint256 idOfProfileUnblocked,
        uint256 timestamp
    );

    /**
     * @dev Emitted via callback when a collectNFT is transferred.
     *
     * @param profileId The token ID of the profile associated with the collectNFT being transferred.
     * @param pubId The publication ID associated with the collectNFT being transferred.
     * @param collectNFTId The collectNFT being transferred's token ID.
     * @param from The address the collectNFT is being transferred from.
     * @param to The address the collectNFT is being transferred to.
     * @param timestamp The current block timestamp.
     */
    event CollectNFTTransferred(
        uint256 indexed profileId,
        uint256 indexed pubId,
        uint256 indexed collectNFTId,
        address from,
        address to,
        uint256 timestamp
    );

    /**
     * @notice Emitted when the ModuleGlobals governance address is set.
     *
     * @param prevGovernance The previous governance address.
     * @param newGovernance The new governance address set.
     * @param timestamp The current block timestamp.
     */
    event ModuleGlobalsGovernanceSet(
        address indexed prevGovernance,
        address indexed newGovernance,
        uint256 timestamp
    );

    /**
     * @notice Emitted when the ModuleGlobals treasury address is set.
     *
     * @param prevTreasury The previous treasury address.
     * @param newTreasury The new treasury address set.
     * @param timestamp The current block timestamp.
     */
    event ModuleGlobalsTreasurySet(
        address indexed prevTreasury,
        address indexed newTreasury,
        uint256 timestamp
    );

    /**
     * @notice Emitted when the ModuleGlobals treasury fee is set.
     *
     * @param prevTreasuryFee The previous treasury fee in BPS.
     * @param newTreasuryFee The new treasury fee in BPS.
     * @param timestamp The current block timestamp.
     */
    event ModuleGlobalsTreasuryFeeSet(
        uint16 indexed prevTreasuryFee,
        uint16 indexed newTreasuryFee,
        uint256 timestamp
    );

    /**
     * @notice Emitted when a currency is added to or removed from the ModuleGlobals whitelist.
     *
     * @param currency The currency address.
     * @param prevWhitelisted Whether or not the currency was previously whitelisted.
     * @param whitelisted Whether or not the currency is whitelisted.
     * @param timestamp The current block timestamp.
     */
    event ModuleGlobalsCurrencyWhitelisted(
        address indexed currency,
        bool indexed prevWhitelisted,
        bool indexed whitelisted,
        uint256 timestamp
    );

    /**
     * @dev Emitted when the metadata associated with a profile is set in the `LensPeriphery`.
     *
     * @param profileId The profile ID the metadata is set for.
     * @param metadata The metadata set for the profile and user.
     * @param timestamp The current block timestamp.
     */
    event ProfileMetadataSet(
        uint256 indexed profileId,
        string metadata,
        uint256 timestamp
    );

    /**
     * @dev Emitted when an address' Profile Guardian state change is triggered.
     *
     * @param wallet The address whose Token Guardian state change is being triggered.
     * @param enabled True if the Token Guardian is being enabled, false if it is being disabled.
     * @param tokenGuardianDisablingTimestamp The UNIX timestamp when disabling the Token Guardian will take effect,
     * if disabling it. Zero if the protection is being enabled.
     * @param timestamp The UNIX timestamp of the change being triggered.
     */
    event TokenGuardianStateChanged(
        address indexed wallet,
        bool indexed enabled,
        uint256 tokenGuardianDisablingTimestamp,
        uint256 timestamp
    );
}
