// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// delegatecall is like call, except the code of callee is executed inside the caller.

// For example contract A calls delegatecall on contract B. Code inside B is executed using A's context such as storage, msg.sender and msg.value.


/*A calls B, sends 100 wei    
    B calls C, sends 50 wei
A ---> B ---> C
                msg.sender = B
                msg.value = 50
                execute code on C's state variables
                use ETH on C
A calls B, sends 100 wei
        B delegatecall calldata
A --> B --> C 
                msg.sender = A
                msg.value = 100
                execute conde on B's state variables
                use ETH on B
*/
                
contract DelegateCall {
    uint256 public num;
    address public sender;
    uint256 public value;
    // state variables MUST match the delegated call IN THE SAME ORDER!
    function setVars(address test, uint256 _num) external payable {
        // This contract's storage is updated, TestDelegateCall's storage is not modified.
        // (bool success, bytes memory data) = test.delegatecall(
        //     abi.encodeWithSignature("setVars(uint256)", _num)
        // );
        (bool success, bytes memory data) = test.delegatecall(abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num));
        // 2 ways to use. 2nd is better if the function signature change
        require(success, "tx failed");
    }

    function setNum(address test, uint256 _num) external {
        // Write your code here
        // (bool success, bytes memory data) = test.delegatecall(abi.encodeWithSignature("setNum(uint256)", _num));

        (bool success, bytes memory data) = test.delegatecall(abi.encodeWithSelector(TestDelegateCall.setNum.selector, _num));
        require(success, "tx failed");
    }
}

contract TestDelegateCall {
    // Storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }

    function setNum(uint256 _num) external {
        num = _num;
    }
}
