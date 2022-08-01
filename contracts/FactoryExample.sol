// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/FactoryInterface.sol";
import "./libraries/HeroLibrary.sol";
import "./ERC20Token.sol";

contract FactoryExample is FactoryInterface, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private heroId;

    uint256 public tokenPrice;
    uint8 constant MINIMAL_TOKEN_AMOUNT_TO_PLAY = 10;
    uint8 constant UPGRADE_PRICE = 20;
    uint8 constant BASE_STRENGTH = 100;
    uint8 constant BASE_DEFENCE = 80;
    address private tokenAddress;

    mapping(address => uint256) private userTokens;
    mapping(address => mapping(uint256 => HeroLibrary.Hero)) private heroes;

    constructor(address _token){
        tokenAddress = _token;
    }

    function setTokenPrice(uint256 _newPrice) external override onlyOwner {
        tokenPrice = _newPrice;
    }

    function buyTokens(uint256 _amount) external override payable {
        require(msg.value >= tokenPrice, "Incorrect price");

        ERC20Token(tokenAddress).mint(msg.sender, _amount);

        userTokens[msg.sender] += _amount;

        emit TokensMinted(msg.sender, _amount);
    }

    function getUserTokens(address _user) external view override returns (uint256){
        return userTokens[_user];
    }

    function createHero(string memory _name) external override {
        require(userTokens[msg.sender] >= MINIMAL_TOKEN_AMOUNT_TO_PLAY, "Not enough tokens to play.");
        HeroLibrary.Rarity baseRarity = HeroLibrary.Rarity.COMMON;

        heroId.increment();

        HeroLibrary.Hero memory newHero = HeroLibrary.Hero(
            heroId.current(),
            _name,
            BASE_STRENGTH,
            BASE_DEFENCE,
            baseRarity
        );

        heroes[msg.sender][heroId.current()] = newHero;

        emit HeroCreated();
    }

    function getHero(uint256 _heroId) external view override returns (HeroLibrary.Hero memory){
        return heroes[msg.sender][_heroId];
    }

    function upgradeHero(uint256 _heroId) external override {
        require(userTokens[msg.sender] >= UPGRADE_PRICE, "Not enough tokens to upgrade.");

        HeroLibrary.Hero memory hero = heroes[msg.sender][_heroId];
        hero.strength++;
        hero.defence++;
        hero.rarity = HeroLibrary.Rarity.RARE;

        // update user tokens balance
        userTokens[msg.sender] -= UPGRADE_PRICE;

        // transfer tokens from user to factory
        ERC20Token(tokenAddress).transferFrom(msg.sender, address(this), UPGRADE_PRICE);

        emit HeroUpgraded();
    }

    function withdraw() external override onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
