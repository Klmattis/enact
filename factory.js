import web3 from '../web3';
import ReferendumFactory from './build/ReferendumFactory.json';

const instance = new web3.eth.Contract(
	JSON.parse(ReferendumFactory.interface),
	'0x6080a807192363646fE8110F681c890B436faD36'
);

export default instance;