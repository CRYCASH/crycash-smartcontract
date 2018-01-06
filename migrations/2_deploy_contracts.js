const CRCICO = artifacts.require("./CRCICO.sol");

module.exports = function(deployer) {
  const team = "0xc120399a1ee8067e52f8e083da5dab0f62fedda7";
  const tradeRobot = "0x40410023209bb53a104b395088d9c1595f0c9d13";
  const tokenPrice = 1000;

  deployer.deploy(CRCICO, team, tradeRobot, tokenPrice);
};