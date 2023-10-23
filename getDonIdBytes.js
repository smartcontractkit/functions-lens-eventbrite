const ethers = require("ethers");

const dontIdStr = process.argv[2]

if (!dontIdStr) {
    throw Error("Please pass in the donId as the first argument")
}

console.log(`DonId '${dontIdStr}' as bytes32 string: `, ethers.utils.formatBytes32String(dontIdStr))