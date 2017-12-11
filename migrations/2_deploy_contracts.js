const CRCICO = artifacts.require("./CRCICO.sol");

module.exports = function(deployer) {
  const team = "0x033E80De71897A38aA2aAbeEb2d70f1cf89b1388";
  const tradeRobot = "0x033E80De71897A38aA2aAbeEb2d70f1cf89b1388";
  const tokenPrice = 0.001;

  deployer.deploy(CRCICO, team, tradeRobot, tokenPrice);
};

// CRCICO.deployed().then(function(instance) { meta = instance; return meta.tokenPrice() })
// CRCICO.deployed().then(function(instance) { meta = instance; return meta.tradeRobot() })