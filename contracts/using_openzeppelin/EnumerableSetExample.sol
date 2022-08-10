// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

contract EnumerableSetExample {
    // Add the library methods
    using EnumerableSet for EnumerableSet.UintSet;
    using Counters for Counters.Counter;

    struct Token {
        uint256 id;
        address user;
    }

    mapping(address => mapping(uint256 => Token)) private m_addressToMap;

    mapping(uint256 => uint256) private m_idToIndex;

    EnumerableSet.UintSet private indexSet;

    Counters.Counter private latestIndex;

    function add(Token memory _token) internal {
        // get next index
        latestIndex.increment();
        uint256 newIndex = latestIndex.current();

        // save unique index; O(1)
        EnumerableSet.add(indexSet, newIndex);
        // add pair of index and Id;  O(1)
        m_idToIndex[_token.id] = newIndex;
        // save new token by it's index;  O(1)
        m_addressToMap[_token.user][newIndex] = _token;
    }

    function remove(address _user, uint256 _tokenId) internal returns (bool){
        uint256 index = m_idToIndex[_tokenId];

        // check that user is token owner; O(1)
        require(m_addressToMap[_user][index].user == _user, "No such token");

        // remove index from set;  O(1)
        return EnumerableSet.remove(indexSet, index);
    }

    function get(address _user, uint256 _tokenId) external view returns (Token memory) {
        return _get(_user, _tokenId);
    }

    function _get(address _user, uint256 _tokenId) internal view returns (Token memory) {
        uint256 index = m_idToIndex[_tokenId];

        // check is token available for this user; O(1)
        require(EnumerableSet.contains(indexSet, index), "No such index");
        require(m_addressToMap[_user][index].user == _user, "User is not hre owner");

        //  O(1)
        return m_addressToMap[_user][index];
    }

    function update(Token memory _token, address _user) internal {
        Token memory token = _get(_user, _token.id);
        token = _token;

        uint256 index = m_idToIndex[token.id];
        m_addressToMap[_user][index] = token;
    }

    function foo() private pure returns (uint256){
        uint256 a = 2 + 2;
        return a;
    }
}
