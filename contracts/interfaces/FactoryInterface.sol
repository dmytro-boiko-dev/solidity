pragma solidity ^0.8.0;

interface FactoryInterface {

    function setTokenPrice(uint256 _newPrice) external;

    function buyTokens(uint256 _amount) external payable;

    function getUserTokens(address _user) external view returns(uint256);

    function createHero(string memory _name) external;

    function upgradeHero() external;

    event TokensMinted(address _to, uint256 _amount);

    event HeroUpgraded();
}
