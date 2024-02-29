// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// New contracts can be created from a contract using the keyword new.

// This is the contract that is deployed using new for this challenge.

contract Bank {
    Account[] public accounts;

    function createAccount(address owner) external {
        Account account = new Account(owner, 0);
        accounts.push(account);
    }

    function createAccountAndSendEther(address owner) external payable {
        Account account = (new Account){value: msg.value}(owner, 0);
        accounts.push(account);
    }

    function createSavingsAccount(address owner) external {
        // Write your code here
        Account account = (new Account)(owner, 1000);
        accounts.push(account);
    }
}

contract Account {
    address public bank;
    address public owner;
    uint256 public withdrawLimit;

    constructor(address _owner, uint256 _withdrawLimit) payable {
        bank = msg.sender;
        owner = _owner;
        withdrawLimit = _withdrawLimit;
    }
}