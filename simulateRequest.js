const fs = require("fs");
const path = require("path");
const {
    simulateScript,
    ReturnType,
    decodeResult,
} = require("@chainlink/functions-toolkit");
const ethers = require("ethers");
require("@chainlink/env-enc").config();

const simulateRequest = async () => {

    // Initialize functions settings
    const source = fs
        .readFileSync(path.resolve(__dirname, "source.js"))
        .toString();

    const args = [process.argv[2], process.argv[3], process.argv[4]]
    const secrets = { OAUTH_KEY: process.env.OAUTH_KEY };


    ///////// START SIMULATION ////////////

    console.log("Start simulation...");

    const response = await simulateScript({
        source: source,
        args: args,
        bytesArgs: [], // bytesArgs - arguments can be encoded off-chain to bytes.
        secrets: secrets,
    });

    console.log("Simulation result", response);
    const errorString = response.errorString;
    if (errorString) {
        console.log(`❌ Error during simulation: `, errorString);
    } else {
        const returnType = ReturnType.string;
        const responseBytesHexstring = response.responseBytesHexstring;
        if (ethers.utils.arrayify(responseBytesHexstring).length > 0) {
            const decodedResponse = decodeResult(
                response.responseBytesHexstring,
                returnType
            );
            console.log(`✅ Decoded response to ${returnType}: `, decodedResponse);
        }
    }

};

simulateRequest().catch((e) => {
    console.error(e);
    process.exit(1);
});
