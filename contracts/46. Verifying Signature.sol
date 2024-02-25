// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Data can be signed off chain and then verified on chain.

// The process of verifying a signature is 3 steps.

// Hash the message to sign (call smart contract).
// Sign the message hash (off chain).
// Verify signature (call smart contract).
contract VerifySig {
    function getMessageHash(string memory message)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(message));
    }

    function getEthSignedMessageHash(bytes32 messageHash)
        public
        pure
        returns (bytes32)
    {
        /*
        This is the actual hash that is signed, keccak256 of
        \x19Ethereum Signed Message\n + len(msg) + msg
        */
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );
    }

    // Function to split signature into 3 parameters needed by ecrecover
    function _split(bytes memory sig)
        internal
        pure
        returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(sig.length == 65, "invalid signature length");
        // the first 32 bytes returns the length of the data
        // sig is not the signature, is just a pointer in the memory

        assembly {
            r := mload(add(sig, 32)) //get the value of r: go to memory 32 bytes from the pointer -> skip the first 32 bytes (= length of the data).
            // read: from the pointer of sig, skip the first 32 bytes (because it holds the length of the array) and the value of r is stored in the next 32 bytes
            s := mload(add(sig, 64)) //skip 64 bytes (length of data + value of r);
            v := byte(0, mload(add(sig, 96))) // skip 96 bytes (length of data + value of r + value of s) and get only the first byte.
        }
        // implicitly return (r, s, v), dont need to return
    }

    // Recovers the signer
    function recover(bytes32 ethSignedMessageHash, bytes memory sig)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = _split(sig);
        return ecrecover(ethSignedMessageHash, v, r, s);
    }

    // Function to verify signature
    // returns true if `message` is signed by `signer`
    function verify(address signer, string memory message, bytes memory sig)
        public
        pure
        returns (bool)
    {
        bytes32 messageHash = getMessageHash(message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, sig) == signer;
    }

    bool public signed;

    function checkSignature(address signer, bytes memory sig) external {
        string memory message = "secret";
        // Write code here
        signed = verify(signer, message, sig);
        require(signed, "error");
    }
}
