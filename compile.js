const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const referendumPath = path.resolve(__dirname, 'contracts', 'Referendum.sol');
const source = fs.readFileSync(referendumPath, 'utf8');
const output = solc.compile(source, 1).contracts;

fs.ensureDirSync(buildPath);

for (let contract in output) {
	let name = contract.replace(':', '');
	fs.outputJsonSync(
		path.resolve(buildPath, name + '.json'),
		output[contract]
	);
}