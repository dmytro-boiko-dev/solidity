// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract ERC20Token is ERC20 {

    /**
     * @dev Mint _amount of tokens to deployer
     */
    constructor(uint256 _amount) ERC20('Sample Game Token', 'SGT') {
        _mint(msg.sender, _amount);
    }

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}
