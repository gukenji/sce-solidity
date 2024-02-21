// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


// Contracts can inherit other contract by using the is keyword.

// Function that can be overridden by a child contract must declare virtual.

// Function that is overriding a parent function must declare override.
contract A {
    // foo() can be overridden by child contract
    function foo() public pure virtual returns (string memory) {
        return "A";
    }

    function bar() public pure virtual returns (string memory) {
        return "A";
    }
}

// Inherit other contracts by using the keyword 'is'.
contract B is A {
    // Overrides A.foo()
    function foo() public pure override returns (string memory) {
        return "B";
    }

    function bar() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is B {
    function bar() public pure override returns (string memory) {
        return "C";
    }
}