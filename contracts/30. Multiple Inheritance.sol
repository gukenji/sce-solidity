// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Solidity supports multiple inheritance. Order of inheritance is important. 
// You must list the parent contracts in the order from “most base-like” to “most derived”.


contract X {
    function foo() public pure virtual returns (string memory) {
        return "X";
    }

    function bar() public pure returns (string memory) {
        return "X";
    }
}

contract Y is X {
    // Overrides X.foo
    // Also declared as virtual, this function can be overridden by child contract
    function foo() public pure virtual override returns (string memory) {
        return "Y";
    }
}

// Order of inheritance - most base-like to derived
// NOT COMPILE IF "contract Z is Y,X"
contract Z is X, Y {
    // Overrides both X.foo and Y.foo
    function foo() public pure override(X, Y) returns (string memory) {
        return "Z";
    }
}
