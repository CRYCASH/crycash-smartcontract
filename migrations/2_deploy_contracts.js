var CRCICO = artifacts.require("./CRCICO.sol");

module.exports = function(deployer) {
  const team = "0x033e80de71897a38aa2aabeeb2d70f1cf89b1388";
  const tradeRobot = "0x033e80de71897a38aa2aabeeb2d70f1cf89b1388";
  const tokenPrice = 0.001;

  deployer.deploy(CRCICO, team, tradeRobot, tokenPrice);
};