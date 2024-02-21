// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Immutable {
    // Write your code here
    // immutable variables use less gas
    address public immutable owner; //will not change anymore

    constructor() {
        owner = msg.sender;
        //will not change anymore after contract is deployed
    }

    uint public x;
    function foo() external {
        require(msg.sender == owner);
        x += 1 ;
    }


}
