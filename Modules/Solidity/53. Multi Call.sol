// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// MultiCall is a handy contract that queries multiple contracts in a single function call and returns all the results.

// This function can be modified to work with call or delegatecall.

// However for this challenge we will use staticcall to query other contracts.

contract TestMultiCall {
    function test() external pure returns (uint256) {
        return 1;
    }

    function testWithParameter(uint256 _j) external view returns (uint256) {
        return _j;
    }

    function getData1() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.test.selector);
    }

    function getData2(uint _j) external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.testWithParameter.selector, _j);
    }
}


contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (bytes[] memory)
    {
        require(targets.length == data.length, "target length != data length");
        bytes[] memory results = new bytes[](data.length);
        for (uint i ; i < targets.length ; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            //staticcall for view/query;
            //call for sending transactions;
            require(success, "call failed");
            results[i] = result;

        }
        return results;
    }
}
