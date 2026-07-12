import hre from 'hardhat';
import {Abi_GreetingsRegistry} from '../generated/abis/GreetingsRegistry.js';
import {loadEnvironmentFromHardhat} from '../rocketh/environment.js';

const args = process.argv.slice(2);
const account = args[0];
const message = args[1];

async function main() {
	const env = await loadEnvironmentFromHardhat({hre});

	const accountAddress = /^0x[a-fA-F0-9]{40}$/.test(account) || !/^\d+$/.test(account)
		? account
		: env.unnamedAccounts[parseInt(account)];

	const GreetingsRegistry = env.get<Abi_GreetingsRegistry>('GreetingsRegistry');
	await env.execute(GreetingsRegistry, {
		account: accountAddress,
		functionName: 'setMessage',
		args: [message || 'hello'],
	});
}
main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
