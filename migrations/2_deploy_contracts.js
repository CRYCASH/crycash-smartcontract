const CRCICO = artifacts.require("./CRCICO.sol");

module.exports = function(deployer) {
  // 0x40410023209bb53a104b395088d9c1595f0c9d13 robot
  // 0xc120399a1ee8067e52f8e083da5dab0f62fedda7 team

  const team = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57";
  const tradeRobot = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57";
  const tokenPrice = 1000;

  deployer.deploy(CRCICO, team, tradeRobot, tokenPrice);
};


// TRUFFLE TEST FUNCS

// CRCICO.deployed().then(function(instance) { meta = instance; return meta.tokenPrice() })
// CRCICO.deployed().then(function(instance) { meta = instance; return meta.tradeRobot() })

// CRCICO.deployed().then(function(instance) { meta = instance; return meta.icoState() })
// CRCICO.deployed().then(function(instance) { meta = instance; return meta.startIco() })
// CRCICO.deployed().then(function(instance) { meta = instance; return meta.tokensSold() })

// 1000000000000000000

// CRCICO.deployed().then(function(instance) { meta = instance; return meta.foreignBuy(0xC5fdf4076b8F3A5357c5E395ab970B5B54098Fef, 100000000000000000000, '0x7b882cf9610adb94457822442c8791299c0fc2f11ef69d6e12d8cc4fc7d0ff07') })
// CRCICO.deployed().then(function(instance) { meta = instance; return meta.finishIco('0x821aEa9a577a9b44299B9c15c88cf3087F3b5544', '0x0d1d4e623D10F9FBA5Db95830F7d3839406C6AF2', '0x2932b7A2355D6fecc4b5c0B6BD44cC31df247a2e') })