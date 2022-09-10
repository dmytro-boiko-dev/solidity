# Solidity Example Project

Hello!  
This is my example project with simple logic just for demonstrate Solidity using

Stack used:
- Solidity (0.8.3)
- OpenZeppelin
- Hardhat
- Ethers
- Chai
- Gas reporter
- Mythril

### Tasks:

Compile contracts:
```shell
npx hardhat compile
```
Run tests:
```shell
npx hardhat test
```
Deploy contracts:
```shell
npx hardhat run ./scripts/deploy.js
```

### Audit example:

Here is audit example for staking contract

You can find audit report at:
```shell
reports/Audit_Report_Example-Staking_contract.pdf
```

You can find Staking contract at:
```shell
contracts/audit/Staking.sol
```
**NOTICE: this is example, and it is full of errors!**