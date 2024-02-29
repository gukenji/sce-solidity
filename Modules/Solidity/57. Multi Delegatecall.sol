// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Let's say you need to call two functions in a smart contract. You will need to send two transactions.

// MultiDelegatecall is a handy smart contract that enables a contract to execute multiple functions in a single transaction.

// Alice -> Multi Call --- CALL ---> test(msg.sender = multi call)
// Alice -> test --- DELEGATECALL --> test(msg.sender = alice)
contract MultiDelegatecall {
    error DelegatecallFailed();
    function multiDelegatecall(bytes[] calldata data)
        external
        payable
        returns (bytes[] memory results)
    {
        // code here
        results = new bytes[](data.length);
        for (uint i ; i < data.length ; i++) {
            (bool success, bytes memory res) = address(this).delegatecall(data[i]);
            if (!success) {
                revert DelegatecallFailed();
            }
            results[i] = res;
        }
    }
}

contract TestMultiDelegatecall is MultiDelegatecall {
    event Log(address caller, string func, uint256 i);

    function func1(uint256 x, uint256 y) external {
        emit Log(msg.sender, "func1", x + y);
    }

    function func2() external returns (uint256) {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }
}

contract Helper {
    function getFunc1Data(uint256 x, uint256 y) external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegatecall.func1.selector, x,y);
    } 

    function getFunc2Data() external pure returns (bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegatecall.func2.selector);
    } 
}