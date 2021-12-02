require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
require('hardhat-gas-reporter');
require('dotenv').config();

const alchemyKey = process.env.ALCHEMY_KEY;
const mnemonic =
    process.env.MNEMONIC || 'test test test test test test test test test test test test';

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
    solidity: {
        version: '0.8.0',
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
    paths: {
        sources: './contracts',
        tests: './test',
        cache: './cache',
        artifacts: './artifacts',
    },
    mocha: {
        timeout: 60000,
    },
    networks: {
        localhost: {
            url: 'http://127.0.0.1:8545',
        },
        hardhat: {
            // forking: {
            //     url: `https://eth-mainnet.alchemyapi.io/v2/${alchemyKey}`,
            // },
            gasPrice: 'auto',
            accounts: {
                mnemonic,
                count: 10,
                accountsBalance: '100000000000000000000',
            },
        },
        rinkeby: {
            url: `https://eth-rinkeby.alchemyapi.io/v2/${alchemyKey}`,
            chainId: 4,
            // gasPrice: 'auto',
            // accounts: { mnemonic },
            // todo: uncomment on deploy
            // accounts: [`0x${RINKEBY_PRIVATE_KEY}`],
        },
        mainnet: {
            url: `https://eth-mainnet.alchemyapi.io/v2/${alchemyKey}`,
            chainId: 1,
            gasPrice: 20000000000,
            accounts: {mnemonic},
        },
        kovan: {
            url: `https://eth-kovan.alchemyapi.io/v2/${alchemyKey}`,
            chainId: 42,
            gasPrice: 'auto',
            accounts: {mnemonic},
        },
    },
};

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        console.log(account.address);
    }
});