// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Array {
    uint[] public nums;
    uint[3] public numsFixedSizeThree;
    uint[] public teste = [1,2,3];
    uint[3] public numsFixedSize = [4,5,6];

    function examples() external {
        teste.push(4);
        uint x = teste[1];
        teste[2] = 777;
        delete teste[1];
        teste.pop();
        uint len = teste.length;

        //create array in memory
        uint[] memory a = new uint[](5); // need to be in fixed size (aka cant use pop or push);
        a[1] = 123;
        
    }

    function returnTeste() external view returns (uint[] memory) {
        return teste;
        // nao é recomendado retornar array (muito gas!)
    }


}
