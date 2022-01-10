// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MineProxy {
    using ECDSA for bytes32;

    Ownable public mine;

    constructor(address _mine) {
        mine = Ownable(_mine);
    }

    function claim(bytes calldata callData, bytes memory signCallData) public {
        bytes32 _hash = keccak256(callData);
        address pubkey = _hash.toEthSignedMessageHash().recover(signCallData);
        require(pubkey == mine.owner(), "SIGNATURE_IS_WRONG");
        (bool success, ) = address(mine).call(callData);
        require(success, "DELEGATE_CALL_FAILED");
    }
}
