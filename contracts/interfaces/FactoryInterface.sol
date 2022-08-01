// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import "../libraries/HeroLibrary.sol";

interface FactoryInterface {

    function setTokenPrice(uint256 _newPrice) external;

    function buyTokens(uint256 _amount) external payable;

    function getUserTokens(address _user) external view returns (uint256);

    function createHero(string memory _name) external;

    function getHero(uint256 _heroId) external view returns (HeroLibrary.Hero memory);

    function upgradeHero(uint256 _heroId) external;

    /**
     * @dev withdraw ETH by owner
     */
    function withdraw() external;

    event TokensMinted(address _to, uint256 _amount);

    event HeroCreated();

    event HeroUpgraded();
}
