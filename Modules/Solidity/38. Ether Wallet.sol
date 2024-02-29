// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Create a contract that can receive Ether from anyone. Only the owner can withdraw.


contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw(uint _amount) external {
        require(msg.sender == owner, "caller is not owner");
        // owner.transfer(_amount); // use more gas  -> using storage variable owner
        payable(msg.sender).transfer(_amount); // use less gas -> not using storage variable owner

        // (bool sent, ) = msg.sender.call{value: _amount}("");
        // require(sent, "Failed to send Ether");
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
