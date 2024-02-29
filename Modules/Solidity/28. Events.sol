// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Events allow smart contracts to log data to the blockchain without using state variables.

// Events are commonly used for debugging, monitoring and a cheap alternative to state variables for storing data.
contract Event {
    event Log(string message, uint256 val);
    // Up to 3 parameters can be indexed
    event IndexedLog(address indexed sender, uint256 val);

    function examples() external {
        emit Log("Foo", 123);
        emit IndexedLog(msg.sender, 123);
    }

    event Message(address indexed _from, address indexed _to, string message);

    function sendMessage(address _to, string calldata message) external {
        emit Message(msg.sender, _to, message);
    }
    
}
