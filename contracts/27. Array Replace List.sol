// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Another way to remove array element while keeping the array without any gaps is to copy the last element into the slot to remove and then remove the last element.
// This technique is more gas efficient than shifting array elements. Unlike the array shifting technique this does not preserve order of elements.

contract ArrayReplaceLast {
    uint256[] public arr = [1, 2, 3, 4];
    // [1,2,3,4] -- remove (1) --> [1,4,3]
    // [1,4,3] -- remove (2) --> [1,4]
    // dont preserve the order!
    function remove(uint256 index) external {
        // Write your code here
        arr[index] = arr[arr.length-1];
        arr.pop();
    }
}
