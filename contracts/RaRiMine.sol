// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RariMine is Ownable {
    using SafeMath for uint256;

    event BalanceChange(address indexed owner, uint256 balance);

    struct Balance {
        address recipient;
        uint256 value;
    }

    ERC20 public token;
    address public tokenOwner;
    mapping(address => uint256) public balances;

    constructor(ERC20 _token, address _tokenOwner) {
        token = _token;
        tokenOwner = _tokenOwner;
    }

    function claim() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "balance should be positive");
        balances[msg.sender] = 0;
        require(
            token.transferFrom(tokenOwner, msg.sender, balance),
            "transfer is not successful"
        );
        emit BalanceChange(msg.sender, 0);
    }

    function plus(Balance[] memory _balances) public onlyOwner {
        for (uint256 i = 0; i < _balances.length; i++) {
            address recipient = _balances[i].recipient;
            uint256 value = _balances[i].value;
            require(recipient != address(0x0), "Recipient should be present");
            require(value != 0, "value should be positive");
            balances[recipient] = balances[recipient].add(_balances[i].value);
            emit BalanceChange(recipient, balances[recipient]);
        }
    }

    function minus(Balance[] memory _balances) public onlyOwner {
        for (uint256 i = 0; i < _balances.length; i++) {
            address recipient = _balances[i].recipient;
            uint256 value = _balances[i].value;
            require(recipient != address(0x0), "Recipient should be present");
            require(value != 0, "value should be positive");
            if (balances[recipient] > _balances[i].value) {
                balances[recipient] = balances[recipient] - _balances[i].value;
            } else {
                balances[recipient] = 0;
            }
            emit BalanceChange(recipient, balances[recipient]);
        }
    }
}
