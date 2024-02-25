// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Libraries are similar to contracts, but you can't declare any state variable and you can't send Ether.

// A library is embedded into the contract if all functions in the library are internal.
// If some function is not internal, the library MUST BE DEPLOYED SEPARATELY.
// Otherwise the library must be deployed and then linked before the contract is deployed.
library Math {
    // CANT USE STATE VARIABLE INSIDE LIBRARY
    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x : y;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x<=y ? x: y;
    }
}

contract TestMath {
    function max(uint256 x, uint256 y) external pure returns (uint256) {
        return Math.max(x, y);
    }

    function min(uint256 x, uint256 y) external pure returns (uint256) {
        return Math.min(x,y);
    }
}

library ArrayLib {
    function find(uint256[] storage arr, uint256 x)
        internal
        view
        returns (uint256)
    {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == x) {
                return i;
            }
        }
        revert("not found");
    }

    function sum(uint256[] storage arr) internal view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            sum += arr[i];
        }
        return sum;
    }
}

contract TestArray {
    using ArrayLib for uint256[];
    // attach all functionalities inside ArrayLib to any state varaibles of type uint256[]
    uint256[] public arr = [3, 2, 1];

    function find() external view {
        arr.find(2);
        // ArrayLib.find(arr,2);
    }

    function sum() external view returns (uint256) {
        return arr.sum();
    }
}
