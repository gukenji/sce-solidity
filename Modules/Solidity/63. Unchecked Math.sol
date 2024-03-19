// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


// Less gas
contract UncheckedMath {
    function add(uint256 x, uint256 y) external pure returns (uint256) {
        // 22291 gas
        // return x + y;

        // 22103 gas
        unchecked {
            return x + y;
        }
    }

    function sub(uint256 x, uint256 y) external pure returns (uint256) {
        // 22329 gas
        // return x - y;
        // Code
        unchecked {
            return x - y;
        }
    }

    function sumOfSquares(uint256 x, uint256 y)
        external
        pure
        returns (uint256)
    {
        // Wrap complex math logic inside unchecked
        unchecked {
            uint256 x2 = x * x;
            uint256 y2 = y * y;

            return x2 + y2;
        }
    }

    function sumOfCubes(uint256 x, uint256 y) external pure returns (uint256) {
        // Code
        unchecked {
            return x ** 3 + y ** 3 ;
        }
    }
}
