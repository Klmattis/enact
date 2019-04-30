require('dotenv').config();
const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/ReferendumFactory.json');

const _MNEMONIC = process.env.RINKEBY_MNEMONIC;
const provider = new HDWalletProvider(
	_MNEMONIC,
	'https://rinkeby.infura.io/v3/c46d445e4e1b4f398737bcc8922167f8'
);
const web3 = new Web3(provider, null, {transactionConfirmationBlocks: 1});

const deploy = async () => {
	const accounts = await web3.eth.getAccounts();

	console.log('Attempting to deploy from account', accounts[0])

	const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
		.deploy({ data: compiledFactory.bytecode })
		.send({ from: accounts[0], gas: '1000000' });

		console.log('Contract deployed to', result.options.address);
};
deploy();