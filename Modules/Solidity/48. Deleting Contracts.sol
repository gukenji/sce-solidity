// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
/*
Contracts can be deleted forever from the blockchain with the function selfdestruct.

selfdestruct takes in a single argument, a payable address to forcefully send all of Ether store in the contract.

For example

selfdestruct(payable(msg.sender))

Casts msg.sender to a payable address
Sends all of Ether held by the contract to msg.sender
Deletes the contract from the blockchain.
*/
contract Kill {

    constructor() payable{}

    function kill() external {
        // Write your code here
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns (uint) {
        return 123;
    }
}

contract Helper {
    // even tough doesnt have any fallback function, it will receive ether because of selfdestruct
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function kill(Kill _kill) external {
        _kill.kill();
    }
}
