// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// fallback is a function that is called when a function to call does not exist.

// For example, call doesNotExist(), this will trigger the fallback function.
contract Fallback {
    string[] public answers = ["receive", "fallback"];

    event Log(string func, address sender, uint value, bytes data);

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }
}

contract Fallback2 {
    event Log(string func, address sender, uint value, bytes data);

    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

}
