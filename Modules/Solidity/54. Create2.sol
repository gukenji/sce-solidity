// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Using create2, contract address can be computed before it is deployed.

// Below is the contract to be deployed using create2.

contract DeployWithCreate2 {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }
}

// Here is the code to compute the address of the contract to be deployed with create2.

contract ComputeCreate2Address {
    function getContractAddress(
        address _factory,
        address _owner,
        uint256 _salt
    ) external pure returns (address) {
        bytes memory bytecode = getByteCode(_owner);
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), _factory, _salt, keccak256(bytecode))
        );

        return address(uint160(uint256(hash)));
    }

    function getByteCode(address _owner) public pure returns (bytes memory) {
        bytes memory bytecode = type(DeployWithCreate2).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }
}


contract Create2Factory {
    event Deploy(address addr);
    function deploy(uint256 _salt) external returns (address) {
        // Write your code here
        DeployWithCreate2 _contract = new DeployWithCreate2{salt: bytes32(_salt)}(msg.sender);
        emit Deploy(address(_contract));
    }
}
