pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import "./interfaces/FactoryInterface.sol";
import "./ERC20Token.sol";
import "./libraries/HeroLibrary.sol";

contract FactoryExample is FactoryInterface, Ownable {

    uint256 public tokenPrice;
    uint8 constant MINIMAL_TOKEN_AMOUNT_TO_PLAY = 10;
    uint8 constant UPGRADE_PRICE = 20;
    uint8 constant BASE_STRENGTH = 100;
    uint8 constant BASE_DEFENCE = 80;
    ERC20Token token;

//    address private token;

    mapping(address => uint256) private userTokens;
    mapping(address => HeroLibrary.Hero) private heroes;

    constructor(address _owner){
        transferOwnership(_owner);
    }

    function setTokenPrice(uint256 _newPrice) external override onlyOwner {
        require(_newPrice > 0, "Invalid price!");
        tokenPrice = _newPrice;
    }

    function buyTokens(uint256 _amount) external override payable {
        require(msg.value >= tokenPrice, "Incorrect price");

        token.mint(msg.sender, _amount);

        userTokens[msg.sender] += _amount;

        emit TokensMinted(msg.sender, _amount);
    }

    function getUserTokens(address _user) external view override returns (uint256){
        return userTokens[_user];
    }

    function createHero(string memory _name) external override {
        require(userTokens[msg.sender] >= MINIMAL_TOKEN_AMOUNT_TO_PLAY, "Not enough tokens to play.");
        HeroLibrary.Rarity baseRarity = HeroLibrary.Rarity.COMMON;

        HeroLibrary.Hero memory newHero = HeroLibrary.Hero(
            _name,
            BASE_STRENGTH,
            BASE_DEFENCE,
            baseRarity
        );

        heroes[msg.sender] = newHero;
    }

    function upgradeHero() external override {
        require(userTokens[msg.sender] >= UPGRADE_PRICE, "Not enough tokens to upgrade.");

        HeroLibrary.Hero memory hero = heroes[msg.sender];
        hero.strength++;
        hero.defence++;
        hero.rarity = HeroLibrary.Rarity.RARE;

        token.transfer(address(this), UPGRADE_PRICE);

        emit HeroUpgraded();
    }


}
