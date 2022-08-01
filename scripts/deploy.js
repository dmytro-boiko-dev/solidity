const { ethers } = require('hardhat');

async function main() {
    const [owner] = await ethers.getSigners();

    console.log('Deploying contracts with the account:', owner.address);
    console.log('Account balance:', (await owner.getBalance()).toString());
    const today = new Date();
    const date = `${today.getFullYear()}-${
        today.getMonth() + 1
    }-${today.getDate()}`;
    const time = `${today.getHours()}:${today.getMinutes()}:${today.getSeconds()}`;
    console.log('Current date: ', date);
    console.log('Current time: ', time);
    console.log('------------------------------------------------------------');

    const FactoryExample = await ethers.getContractFactory('FactoryExample');
    const ERC20Token = await ethers.getContractFactory('ERC20Token');

    const token = await ERC20Token.deploy(100);
    await token.deployed();

    const factoryExample = await FactoryExample.deploy(token.address);
    await factoryExample.deployed();
    console.log('FactoryExample deployed to: ', factoryExample.address);
    console.log('------------------------------------------------------------');
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
