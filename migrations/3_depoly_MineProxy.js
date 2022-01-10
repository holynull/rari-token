const RaRiMineV2 = artifacts.require("RaRiMineV2");
const MineProxy = artifacts.require("MineProxy");

module.exports = function (deployer) {
	return RaRiMineV2.deployed().then(mine => {
		return deployer.deploy(MineProxy, mine.address).then(() => {
			return mine.setProxy(MineProxy.address);
		});
	});
};
