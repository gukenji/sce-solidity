// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// 2 ways to call parent constructors
contract U is S("S"), T("T") {}

contract V is S, T {
    // Pass the parameters here in the constructor,
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}

// can combine both
contract W is S("S"), T {
        constructor(string memory _text) T(_text) {}
}


// Order of execution:
// 1. S
// 2. T
// 3. Z
contract Z is S, T {
        constructor(string memory _name, string memory _text) T(_text) S(_name) {}
}