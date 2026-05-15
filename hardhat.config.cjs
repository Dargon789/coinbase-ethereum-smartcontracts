const {loadEnv} = require('ldenv');
loadEnv();
require('@nomicfoundation/hardhat-network-helpers');
const {addForkConfiguration, addNetworksFromEnv} = require('hardhat-rocketh');

const {task} = require('hardhat/config');
// we override the node task to set up our block time interval
// setting it up in the config below would also set it in tests and we do not want that
Split the “node”‐task override into its own file and flatten the network config so it’s easier to follow. For example:

// tasks/node-time.js
const { task } = require('hardhat/config');
task('node').setAction(async (args, hre, runSuper) => {
  if (process.env.BLOCK_TIME) {
    // only affects `npx hardhat node`
    hre.config.networks.hardhat.mining = {
      auto: true,
      interval: parseInt(process.env.BLOCK_TIME, 10) * 1000,
    };
  }
  return runSuper(args);
});

// hardhat.config.js
require('ldenv').loadEnv();
require('@nomicfoundation/hardhat-network-helpers');
require('./tasks/node-time');
const { addNetworksFromEnv } = require('hardhat-rocketh');

const defaultVersion = '0.8.25';
const defaultSettings = {
  optimizer: { enabled: true, runs: 999_999 },
  viaIR: true,
  outputSelection: { '*': { '*': ['evm.methodIdentifiers'] } },
};

// build base networks from env
const baseNetworks = addNetworksFromEnv({
  hardhat: {
    initialBaseFeePerGas: process.env.HARDHAT_FORK ? 1 : 0,
    allowUnlimitedContractSize: !process.env.HARDHAT_FORK,
  },
});

// attach forking if set
const hardhatNetwork = {
  ...baseNetworks.hardhat,
  ...(process.env.HARDHAT_FORK
    ? { forking: { url: process.env.HARDHAT_FORK } }
    : {}),
};

module.exports = {
  solidity: { compilers: [{ version: defaultVersion, settings: defaultSettings }] },
  networks: {
    ...baseNetworks,
    hardhat: hardhatNetwork,
  },
  paths: { sources: 'src' },
};
	if (process.env['BLOCK_TIME']) {
		hre.config.networks.hardhat.mining = hre.config.networks.hardhat.mining || {};
		hre.config.networks.hardhat.mining.auto = true;
		hre.config.networks.hardhat.mining.interval = parseInt(process.env['BLOCK_TIME']) * 1000;
	}
	return runSuper(args);
});

const defaultVersion = '0.8.25';
const defaultSettings = {
	optimizer: {
		enabled: true,
		runs: 999999,
	},
	viaIR: true,
	outputSelection: {
		'*': {
			'*': ['evm.methodIdentifiers'],
		},
	},
};

const config = {
	solidity: {
		compilers: [
			{
				version: defaultVersion,
				settings: {...defaultSettings},
			},
		],
	},
	networks:
		// this setup forking for netwoirk if env var HARDHAT_FORK is set
		addForkConfiguration(
			// this add network for each respective env var found (ETH_NODE_URI_<network>)
			addNetworksFromEnv({
				hardhat: {
					initialBaseFeePerGas: process.env.HARDHAT_FORK ? 1 : 0,
					allowUnlimitedContractSize: process.env.HARDHAT_FORK ? false : true,
				},
			}),
		),
	paths: {
		sources: 'src',
	},
};

module.exports = config;
