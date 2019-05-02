import web3 from '../web3';
import Referendum from './build/Referendum.json';

export default (address) => {
	return new web3.eth.Contract(
		JSON.parse(Referendum.interface), 
		address
	);
};