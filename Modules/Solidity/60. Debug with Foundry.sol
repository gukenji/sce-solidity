// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// All solidity challenges in smartcontract.engineer can be debugged with Foundry's console.sol.

// You can print logging messages and contract variables by calling console.log.

// Run the tests and messages will be printed along with the output of the tests.
import {console} from "forge-std/Test.sol";

contract Token {
    mapping(address => uint256) public balances;

    constructor() {
        balances[msg.sender] = 100;
    }

    function transfer(address to, uint256 amount) external {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        console.log("transfer",msg.sender, to, amount);
    }
}
