// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;


contract TestContract {
    uint256 public x;
    uint256 public value = 123;

    function setX(uint256 _x) external {
        x = _x;
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function setXandReceiveEther(uint256 _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXandValue() external view returns (uint256, uint256) {
        return (x, value);
    }

    function setXtoValue() external payable {
        x = msg.value;
    }

    function getValue() external view returns (uint256) {
        return value;
    }
}


contract CallTestContract {
    function setX(TestContract test, uint256 x) external {
        test.setX(x);
    }

    function setXfromAddress(address addr, uint256 x) external {
        TestContract test = TestContract(addr);
        test.setX(x);
    }

    function getX(address addr) external view returns (uint256) {
        uint256 x = TestContract(addr).getX();
        return x;
    }

    function setXandSendEther(TestContract test, uint256 x)
        external
        payable
    {
        test.setXandReceiveEther{value: msg.value}(x);
    }

    function getXandValue(address addr)
        external
        view
        returns (uint256, uint256)
    {
        (uint256 x, uint256 value) = TestContract(addr).getXandValue();
        return (x, value);
    }

    function setXwithEther(address addr) external payable {
        TestContract test = TestContract(addr);
        test.setXtoValue{value: msg.value}();
    }

    function getValue(address addr) external view returns (uint256) {
        return TestContract(addr).getValue();
    }
}