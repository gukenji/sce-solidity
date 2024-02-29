// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
// = dict in python
// {"alice" : true, "bob": false}...
contract Mapping {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => bool)) public isFriend;

    function examples() external {
        balances[msg.sender] = 123;
        uint bal = balances[msg.sender];
        uint bal2 = balances[address(1)]; // will return default value = 0 -> no balance for address 1
        balances[msg.sender] += 456;
        delete balances[msg.sender];

        isFriend[msg.sender][address(this)] = true; // msg.sender is friend of this contract
    }
}