let secret = require("./secret")

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-tracer");
require('@nomiclabs/hardhat-ethers');


const { API_URL, PRIVATE_KEY, ETHERSCAN_KEY} = process.env;


module.exports = {
  solidity: "0.8.13",
  networks: {

    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/8z0tKgcsVGTeYDZJkbGSzoeQNfl-Vuas",
      accounts: [secret.key]
    },
    mainnet: {
      url: "",
      accounts: [secret.key]
    },
  },
  etherscan: {
    apiKey: "7UGSWT65SYBDSP593J7CPMKFE8X8WTRGXH"
  }
};
