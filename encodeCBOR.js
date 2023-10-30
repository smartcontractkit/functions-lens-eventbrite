const {
  SecretsManager,
  buildRequestCBOR,
  Location,
  CodeLanguage,
} = require("@chainlink/functions-toolkit");

const { ethers } = require("ethers");
const { providers, Wallet } = require("ethers");
const fs = require("fs");
const path = require("path");

require("@chainlink/env-enc").config();

const provider = new providers.JsonRpcProvider(process.env.MUMBAI_RPC_URL);
const signer = new Wallet(process.env.PRIVATE_KEY, provider);
const functionsRouterAddress = "0x6E2dc0F9DB014aE19888F539E59285D2Ea04244C";

const encode = async () => {
  const sm = new SecretsManager({
    signer,
    functionsRouterAddress,
    donId: "fun-polygon-mumbai-1",
  });

  await sm.initialize();

  const encryptedSecretsReference = sm.buildDONHostedEncryptedSecretsReference({
    slotId: 0,
    version: 1698393952,
  });

  const organizationId = "1835739841923";
  const eventId = "737036755777";
  const msgSender = "0x208AA722Aca42399eaC5192EE778e4D42f4E5De3";
  const percentageOff = ethers.utils.formatBytes32String("90");
  const quantityAvailable = ethers.utils.solidityPack(["string"], ["10"]);

  console.log("test : ", quantityAvailable,  Buffer.from(quantityAvailable).toString("utf8"));

  const CBOR = buildRequestCBOR({
    codeLocation: 0,
    secretsLocation: Location.DONHosted,
    codeLanguage: CodeLanguage.JavaScript,
    source: fs.readFileSync(path.resolve(__dirname, "source.js")).toString(),
    encryptedSecretsReference,
    args: [], // TODO
  });
};

encode().catch(e => {
  console.error(e);
  process.exit(1);
});
