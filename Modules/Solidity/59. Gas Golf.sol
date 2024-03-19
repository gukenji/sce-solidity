// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//Gas optimize the function sumIfEvenAndLessThan99 to less than or equal to 48628 gas.
// data = [1,2,3,4,5,100]
// start - 50782 gas
// use calldata - 49054 gas
// load state variable to memory - 48843 gas
// cache array length - 47457 gas
// load array elements to memory - 47253 gas 


contract GasGolf {
    uint256 public total;

    function sumIfEvenAndLessThan99(uint256[] calldata nums) external {
        uint256 _total = total;
        uint length = nums.length;
        for (uint256 i = 0; i < length; ++i) {
            // bool isEven = nums[i] % 2 == 0;
            // bool isLessThan99 = nums[i] < 99;
            uint num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }
        total = _total;
    }
}
