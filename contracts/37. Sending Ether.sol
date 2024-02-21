// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SendEther {
    uint send_value;
    constructor() payable {} 
    receive() external payable {} // enable contract to receive
    function sendViaTransfer(address payable to) external payable {
        // This function is no longer recommended for sending Ether.
        to.transfer(send_value);
    }

    function sendViaSend(address payable to) external payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = to.send(send_value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable to) external payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = to.call{value: send_value}("");
        require(sent, "Failed to send Ether");
    }

    function setValue(uint _value) external {
        send_value = _value;
    }
}

contract EthReceiver {
    event Log(uint amount, uint gas);
    receive() external payable {
        emit Log(msg.value, gasleft());
    }
}