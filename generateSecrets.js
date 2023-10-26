const {
    SecretsManager
} = require("@chainlink/functions-toolkit");
const { providers, Wallet } = require("ethers");
require("@chainlink/env-enc").config();

const generateSecrets = async () => {
    const provider = new providers.JsonRpcProvider(process.env.POLYGON_MUMBAI_RPC_URL)
    const signer = new Wallet(process.env.PRIVATE_KEY, provider)
    const functionsRouterAddress = '0x6E2dc0F9DB014aE19888F539E59285D2Ea04244C'

    const secretsManager = new SecretsManager({
        signer, functionsRouterAddress, donId: 'fun-polygon-mumbai-1'
    });
    await secretsManager.initialize();

    const secrets = { OAUTH_KEY: process.env.OAUTH_KEY };
    const SLOT_ID = 0;
    const EXPIRE_AFTER_MINUTES = 4320; // 3 days

    const encryptedSecrets = await secretsManager.encryptSecrets(secrets)
    const { version } = await secretsManager.uploadEncryptedSecretsToDON({
        encryptedSecretsHexstring: encryptedSecrets.encryptedSecrets,
        gatewayUrls: ['https://01.functions-gateway.testnet.chain.link/'],
        slotId: SLOT_ID,
        minutesUntilExpiration: EXPIRE_AFTER_MINUTES,
    });

    console.log(`Version: ${version}`);
    console.log(`Slot ID: ${SLOT_ID}`);

    return { version, SLOT_ID }
}

generateSecrets().catch((e) => {
    console.error(e);
    process.exit(1);
});



