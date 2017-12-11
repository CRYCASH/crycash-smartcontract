var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = "[hidden]";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*",
      gas: 3000000
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"),
      network_id: 3,
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