import web3 from '../web3';
import ReferendumFactory from './build/ReferendumFactory.json';

const instance = new web3.eth.Contract(
	JSON.parse(ReferendumFactory.interface),
	'0x6cf8bD9Bf474b4ED775C642B87F963e2d28e4fC5'
);

export default instance;