const { SecretsManager } = require("@chainlink/functions-toolkit");
const { providers, Wallet } = require("ethers");

require("dotenv").config();

const RPC_URL = process.env.MUMBAI_RPC_URL;

if (!RPC_URL) {
  throw Error("❌\nMUMBAI_RPC_URL env var not set");
}
if (!process.env.PRIVATE_KEY){
    throw Error("❌\nPRIVATE_KEY env var not set")
}
if (!process.env.EVENTBRITE_OAUTH_TOKEN) {
  throw Error("❌\nEVENTBRITE_OAUTH_TOKEN env var not set");
}

const provider = new providers.JsonRpcProvider(RPC_URL);
const wallet = new Wallet(process.env.PRIVATE_KEY || "UNSET");
const signer = wallet.connect(provider);

const polygonMumbaiConfigs = {
  gasPrice: 20_000_000_000,
  nonce: undefined,
  accounts: [process.env.PRIVATE_KEY],
  verifyApiKey: process.env.POLYGONSCAN_API_KEY || "UNSET",
  chainId: 80001,
  confirmations: 1,
  nativeCurrencySymbol: "MATIC",
  linkToken: "0x326C977E6efc84E512bB9C30f76E30c160eD06FB",
  linkPriceFeed: "0x12162c3E810393dEC01362aBf156D7ecf6159528", // LINK/MATIC
  functionsRouter: "0x6E2dc0F9DB014aE19888F539E59285D2Ea04244C",
  donId: "fun-polygon-mumbai-1",
  gatewayUrls: [
    "https://01.functions-gateway.testnet.chain.link/",
    "https://02.functions-gateway.testnet.chain.link/",
  ],
};

const { donId, functionsRouter, gatewayUrls } = polygonMumbaiConfigs;

const encryptAndUploadSecrets = async () => {
  const secretsManager = new SecretsManager({
    signer,
    functionsRouterAddress: functionsRouter,
    donId,
  });

  // initialize secrets manager.
  await secretsManager.initialize();

  // Encrypt secrets & upload them to the DON.
  // Set the TTL to 1 DAY in minutes  (enough for the setup + demo!)
  const TTL_ONE_DAY_IN_MIN = 1440; // TODO @dev
  const secrets = { OAUTH_KEY: process.env.EVENTBRITE_OAUTH_TOKEN };

  console.log("\nEncrypting secrets...");
  const encryptedSecretsObj = await secretsManager.encryptSecrets(secrets);

  const slotId = 0; //  @dev this can be to whatever slotId you want to use/update. For now we use 0.
  const minutesUntilExpiration = TTL_ONE_DAY_IN_MIN;

  console.log("\nUploading encrypted secrets to DON...");
  const { version, success } = await secretsManager.uploadEncryptedSecretsToDON(
    {
      slotId,
      minutesUntilExpiration,
      gatewayUrls,
      encryptedSecretsHexstring: encryptedSecretsObj.encryptedSecrets,
    }
  );

  console.log(
    `\n✅Please make a note of the slotId:  ${slotId} and the version ${version}. You will need this as input when calling the Open Action.`
  );

  //   const encryptedSecretsReference =
  //     secretsManager.buildDONHostedEncryptedSecretsReference({
  //       slotId,
  //       version,
  //     });

  //   console.log(
  //     "\nPlease make a note of this encryptedSecretsReference:  ",
  //     encryptedSecretsReference
  //   );
};

encryptAndUploadSecrets().catch((err) => {
  console.log("❌\nError encrypting and uploading secrets: ", err);
});
