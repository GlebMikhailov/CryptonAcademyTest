/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('.env').config();
require("@nomiclabs/hardhat-ethers");
module.exports = {
  solidity: "0.8.13",
  settings: {
    optimizer: {
      enabled: true,
      runs: 1000000,
    },
  },

  networks: {
    testnet: {
      url: process.env.NODE,
      accounts: [process.env.PRIVATE_KEY],

    },
    mainnet: {
      url: process.env.NODE,
      accounts: [process.env.PRIVATE_KEY],

    }
  },
  etherscan: {
    apiKey: process.env.API
  }
};
