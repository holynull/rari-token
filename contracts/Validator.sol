// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Validator {
    constructor() {}

    function verify(bytes32 msgHash, bytes32 signature)
        public
        returns (address)
    {}
}
