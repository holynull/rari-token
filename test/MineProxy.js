const MineProxy = artifacts.require("MineProxy");
const RaRiMineV2 = artifacts.require("MineProxy");
const RaRiMineV2Json = require("../build/contracts/RariMineV2.json");
const mnemonic = require('../secret');
const ethers = require('ethers');
const signer = ethers.Wallet.fromMnemonic(mnemonic.deployer);
const log4js = require('log4js');
const log4jsConfig = {
	appenders: {
		stdout: {
			type: 'stdout',
			layout: {
				type: 'pattern',
				pattern: '%[[%d] [%p] [%f{2}:%l] %m'
			}
		},
	},
	categories: { default: { appenders: ["stdout"], level: "debug", enableCallStack: true } }
};
log4js.configure(log4jsConfig);
const logger = log4js.getLogger('Test RaRi');

contract("MineProxy", accounts => {
	it("测试proxy的claim，应该执行成功。", async () => {
		let proxy = await MineProxy.deployed();
		try {
			// const mine=await RaRiMineV2.deployed();
			// const mineContract= new ethers.Contract(mine.address,RaRiMineV2Json.abi,new ethers.providers.JsonRpcProvider('http://localhost:8545'));
			// await mineContract.connect(signer).claim(accounts[0],ethers.utils.parseEther('100'));
			const mineInterface = new ethers.utils.Interface(RaRiMineV2Json.abi);
			const callData = mineInterface.encodeFunctionData('claim', [accounts[0], ethers.utils.parseEther('100')]);
			logger.info('callData: ' + callData);
			// let arr = ethers.utils.arrayify(callData);
			let hash = ethers.utils.keccak256(callData);
			logger.info('hash: ' + hash);
			const signature = await signer.signMessage(ethers.utils.arrayify(hash));
			logger.info('publickey: ' + signer.address);
			logger.info('signature: ' + signature);
			let res = await proxy.claim(callData, signature);
			logger.info("res is: " + JSON.stringify(res));
		} catch (e) {
			logger.error(e.message);
			assert.equal(1, 0, 'claim failed!');
		}
	});
});