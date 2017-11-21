var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = "[hidden]";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 4600000
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"),
      network_id: 3,
      gas: 4600000
    },
    live: {
      host: "[hidden]",
      port: 8545,
      network_id: "*",
      gas: 4600000
    }
  }
};