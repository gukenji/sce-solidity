// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Hodl is a contract where users can deposit ETH but can only withdraw after a certain time has elapsed.


contract Hodl {
    uint256 private constant HODL_DURATION = 3 * 365 days;

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public lockedUntil;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
        lockedUntil[msg.sender] = block.timestamp + HODL_DURATION;
    }

    function withdraw() external payable {
        require(lockedUntil[msg.sender] <= block.timestamp, "token still locked");
        payable(msg.sender).transfer(balanceOf[msg.sender]);
        balanceOf[msg.sender] = 0;
    }
}
