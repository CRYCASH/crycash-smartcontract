var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*",
      gas: 3000000
    },
    live: {
      host: "[hidden]",
      port: 8545,
      network_id: "*",
      gas: 3000000
    }
  }
};