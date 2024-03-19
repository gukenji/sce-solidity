// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CustomError {
    error MyError(address caller, uint256 i);
    error InvalidAddress();
    error NotAuthorized(address caller);
    
    address public owner = msg.sender;



    function myError(uint256 i) external {
        if (i < 10) {
            revert MyError(msg.sender, i);
        }
    }

    function setOwner(address _owner) external {
        // Write your code here
        if (_owner == address(0)) {
            revert InvalidAddress();
        }
        if (owner != msg.sender) {
            revert NotAuthorized(msg.sender);
        }
        owner = _owner;
    }
}
