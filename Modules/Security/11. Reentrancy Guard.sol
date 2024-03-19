// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


contract TestReentrancyGuard {
    // Maximum number of times fallback will call back msg.sender
    uint256 public immutable max;
    // Actual amount of time fallback was executed
    uint256 public count;

    constructor(uint256 _max) {
        max = _max;
    }

    fallback() external {
        if (count < max) {
            count += 1;
            (bool success, ) = msg.sender.call(
                abi.encodeWithSignature("exec(address)", address(this))
            );
            require(success, "call back failed");
        }
    }
}

contract ReentrancyGuard {
    // Count stores number of times the function test was called
    uint256 public count;
    bool private locked;

    modifier lock() {
        require(!locked, "locked");
        locked = true;
        _;
        locked = false;
    }

    function exec(address target) external lock {
        (bool ok,) = target.call("");
        require(ok, "call failed");
        count += 1;
    }
}
