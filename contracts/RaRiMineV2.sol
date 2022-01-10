// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract RariMineV2 is Ownable {
    using SafeMath for uint256;

    event Claim(address indexed owner, uint256 value);
    event Value(address indexed owner, uint256 value);

    struct Balance {
        address recipient;
        uint256 value;
    }

    ERC20 public token;
    address public tokenOwner;
    mapping(address => uint256) public claimed;

    address public proxy;

    constructor() // ERC20 _token,
    // address _tokenOwner,
    // address _proxy
    {
        // token = _token;
        // tokenOwner = _tokenOwner;
        // proxy = _proxy;
    }

    function setProxy(address _proxy) public onlyOwner {
        proxy = _proxy;
    }

    // function _claim(Balance[] memory _balances, bytes memory signature) public {
    function claim(address who, uint256 amt) public {
        // require(
        //     bytes(prepareMessage(_balances)).recover(signature) == owner(),
        //     "owner should sign balances"
        // );
        require(msg.sender == proxy, "PROXY_ONLY");
        emit Claim(who, amt);
        // for (uint256 i = 0; i < _balances.length; i++) {
        //     address recipient = _balances[i].recipient;
        //     if (msg.sender == recipient) {
        //         uint256 toClaim = _balances[i].value.sub(claimed[recipient]);
        //         require(toClaim > 0, "nothing to claim");
        //         claimed[recipient] = _balances[i].value;
        //         require(
        //             token.transferFrom(tokenOwner, msg.sender, toClaim),
        //             "transfer is not successful"
        //         );
        //         emit Claim(recipient, toClaim);
        //         emit Value(recipient, _balances[i].value);
        //         return;
        //     }
        // }
        // revert("msg.sender not found in receipients");
    }

    function doOverride(Balance[] memory _balances) public onlyOwner {
        for (uint256 i = 0; i < _balances.length; i++) {
            claimed[_balances[i].recipient] = _balances[i].value;
            emit Value(_balances[i].recipient, _balances[i].value);
        }
    }

    // function prepareMessage(Balance[] memory _balances)
    //     internal
    //     returns (string memory)
    // {
    //     return toString(keccak256(abi.encode(_balances)));
    // }

    function toString(bytes32 value) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(64);
        for (uint256 i = 0; i < 32; i++) {
            str[i * 2] = alphabet[uint8(value[i] >> 4)];
            str[1 + i * 2] = alphabet[uint8(value[i] & 0x0f)];
        }
        return string(str);
    }
}
