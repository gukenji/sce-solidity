// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// In Solidity 0.8 fallback can take in an input and an output of bytes.

// This can simplify the code for a proxy contract.

// Before this feature was available, the only way to handle inputs and outputs in the fallback was by writting your code in assembly.


// TASK:
// Implement fallback that takes an input of bytes and returns an output of bytes.

// fallback(bytes calldata data) external payable returns (bytes memory) {}

// Call target with data from input, send msg.value
// Require that the call above is successful
// Return response from the call above

contract FallbackInputOutput {
    address immutable target;

    constructor(address _target) {
        target = _target;
    }

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool ok, bytes memory res) = target.call{value: msg.value}(data);
        require(ok, "call failed");
        return res;
    }
}