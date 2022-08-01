// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

library HeroLibrary {

    enum Rarity {
        COMMON,
        RARE,
        EPIC
    }

    struct Hero {
        uint256 id;
        string name;
        uint256 strength;
        uint256 defence;
        Rarity rarity;
    }
}
