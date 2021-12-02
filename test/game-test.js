const {expect} = require('chai');
const {utils} = require('ethers');
const {ethers} = require('hardhat');

describe('Game Tests', function () {
    beforeEach(async function deployContract() {

        const [owner, account, account2, account3, account4] = await ethers.getSigners();
        this.owner = owner;
        // this.clients = [account, account2, account3, account4];

        const FactoryExample = await ethers.getContractFactory('contracts/FactoryExample.sol:FactoryExample');

        this.factoryExample = await FactoryExample.deploy(this.owner.address);
        await this.factoryExample.deployed();
    });

    it('Game test #1', async function testGame() {
        await this.factoryExample.setTokenPrice(5);
        let price = await this.factoryExample.tokenPrice();
        expect(price.toString()).to.equal('5');
    });
});