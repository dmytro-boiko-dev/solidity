pragma solidity ^0.8.0;

library HeroLibrary {

    enum Rarity {
        COMMON,
        RARE,
        EPIC
    }

    struct Hero {
        string name;
        uint256 strength;
        uint256 defence;
        Rarity rarity;
    }
}
