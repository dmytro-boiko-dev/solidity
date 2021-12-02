pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract ERC20Token is ERC20 {

    /**
     * @dev Mint _amount of tokens to deployer
     */
    constructor(address _owner, uint256 _amount) ERC20('Simple ERC20 Token', 'SET') {
        _mint(_owner, _amount);
    }

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}
