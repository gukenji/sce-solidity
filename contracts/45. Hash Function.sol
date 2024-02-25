// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// keccak256 is a cryptographic hash funciton commonly used in Solidity.

// Some use cases are:

// Creating a deterministic unique ID from inputs
// Cryptographic signatures
// Commit reveal scheme
// Here you will learn the basics, how to use keccak256.

// abi.encodePacked:
// abi.encode: prevent hash collision (same hash with different inputs) because of the size of the encoding
contract HashFunc {
    function hash(string memory text, uint256 num, address addr)
        external
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(text, num, addr));
        //abi.encodePacked -> transform to bytes
    }

    function getHash(address addr, uint256 num)
        external
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(addr,num));
    }

    function collision(string memory text0, string memory text1) external pure returns(bytes32) {
        return keccak256(abi.encodePacked(text0,text1));
        // test "AAA", "ABBB" and "AAAA", "BBB", they will not change
        // one way to prevent this is use encode or dont use dynamic inputs close to each other, like:
        // return keccak256(abi.encodePacked(string, num, string));

    }
 }
