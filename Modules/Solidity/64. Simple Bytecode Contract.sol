// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Factory {
    event Log(address addr);

    function deploy() external returns (address addr) {
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        assembly {
            // Deploy contract with bytecode loaded in the memory
            // create(value = amount of ether send, offset = where the code is located in memory, size)
            
            addr := create(0, add(bytecode, 0x20), 0x13)
            //                              0x20 = skip first 32 bytes (the first 32 bytesstore the length of this variable) 
                                                  // 0x13 = 19
        }
        require(addr != address(0));

        emit Log(addr);
    }
}

interface IContract {
    function getMeaningOfLife() external view returns (uint);
}

/* Runtime Code:
1. Store 42 to memory:
First 5 bytes

602a600052
PUSH1 0x2a
PUSH1 0
MSTORE

MSTORE stores 32 bytes at a memory offset.
Here we store 42 (0x2a) at memory offset 0.

2. Return 32 bytes from memory
Last 5 bytes
60206000f3
PUSH1 0x20
PUSH1 0
RETURN

RETURN ends code execution and returns the data stored in memory.
Here we return 32 bytes in memory (0x20) starting from memory offset 0.


Creation Code:
This is the creation code. It will simply return the runtime code.
69602a60005260206000f3600052600a6016f3

1. Store run time code to memory
69602a60005260206000f3600052
PUSH10 0X602a60005260206000f3
PUSH1 0
MSTORE

Push 10 bytes of runtime code (0X602a60005260206000f3) into stack. Next push 0 into stack. 
Last, store the runtime code at memory offset 0.

2. Return 10 bytes from memory starting at offset 22
600a6016f3
PUSH1 0x0a
PUSH1 0x16
RETURN

Return 10 bytes (0x0a), this is the runtime code, starting from memory offest 22 (0x16).

Why is the offset 22?
In step 1, we stored the runtime code. Runtime code is 10 bytes. MSTORE stores 32 bytes. 
If the data is smaller than 32 bytes, it will be padded with zeros.

So inside the memory, the runtime code will look like this.
00000000000000000000000000000000000000000000602a60005260206000f3
First 22 bytes are all zeros. Hence the offset of 22.

*/