// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract EthBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external payable {
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(sent, "failed to send ETH");

        balances[msg.sender] = 0;
    }
}


interface IEthBank {
    function deposit() external payable;
    function withdraw() external payable;
}

contract EthBankExploit {
    IEthBank public bank;

    receive() external payable {}
    constructor(address _bank) {
        bank = IEthBank(_bank);
    }

    function pwn() external payable {
        (bool sent, ) = address(bank).call{value: getBalance()}("");
        

    }

    function getBalance() public view returns (uint) {
        return address(bank).balance;
    }

}