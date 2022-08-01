const {expect} = require('chai');
const {utils} = require('ethers');
const {ethers} = require('hardhat');

describe('Game Tests', function () {
    beforeEach(async function deployContract() {

        const [owner, account, account2, account3, account4] = await ethers.getSigners();
        this.owner = owner;
        this.clients = [account, account2, account3, account4];

        const FactoryExample = await ethers.getContractFactory('FactoryExample');
        const ERC20Token = await ethers.getContractFactory('ERC20Token');

        this.token = await ERC20Token.deploy(100);
        await this.token.deployed();

        this.factoryExample = await FactoryExample.deploy(this.token.address);
        await this.factoryExample.deployed();
    });

    it('Set price test', async function setPriceTest() {
        await this.factoryExample.setTokenPrice(5);
        let price = await this.factoryExample.tokenPrice();
        expect(price.toString()).to.equal('5');
    });

    it('Buy tokens test', async function buyTokensTest() {

        // set ERC20 token price
        await this.factoryExample.setTokenPrice(1);

        // buy tokens by user
        await this.factoryExample.connect(this.clients[0]).buyTokens(10, {value: utils.parseEther('5')});

        // check that user have tokens
        const amount = await this.token.balanceOf(this.clients[0].address);
        expect(amount.toNumber()).to.be.eq(10);

        // check amount of user tokens from factory
        const userTokensAmount = await this.factoryExample.getUserTokens(this.clients[0].address);
        expect(userTokensAmount.toNumber()).to.be.eq(10);
    });

    describe('Hero tests', function () {
        beforeEach(async function init() {
            await this.factoryExample.setTokenPrice(1);
            await this.factoryExample.connect(this.clients[0]).buyTokens(100, {value: utils.parseEther('5')});
        });

        it('Create hero test', async function createHeroTest() {
            const tx = await this.factoryExample.connect(this.clients[0]).createHero('My Hero');
            const txr = await tx.wait();

            expect(txr.events[0].event).to.be.eq('HeroCreated');
        });

        it('Get user hero test', async function getHeroTest() {
            await this.factoryExample.connect(this.clients[0]).createHero('My Hero');

            const [id, name, strength, defence, rarity] = await this.factoryExample.connect(this.clients[0]).getHero(1);

            expect(id.toNumber()).to.be.eq(1);
            expect(name).to.be.eq('My Hero');
            expect(strength.toNumber()).to.be.eq(100);
            expect(defence.toNumber()).to.be.eq(80);
            expect(rarity).to.be.eq(0);
        });

        it('Update hero test', async function updateHeroTest() {
            await this.factoryExample.connect(this.clients[0]).createHero('My Hero');

            await this.token.connect(this.clients[0]).approve(this.factoryExample.address, 20)
                .then((tx) => tx.wait());

            const tx = await this.factoryExample.connect(this.clients[0]).upgradeHero(1);
            const txr = await tx.wait();

            expect(txr.events[2].event).to.be.eq('HeroUpgraded');
        });
    });
});