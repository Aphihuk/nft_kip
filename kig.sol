// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

contract onlyworknosleep {
    string public constant name = "Kig";
    string public constant symbol = "KIG";
    uint8 public constant decimals = 8;

    uint256 public constant totalSupply = 21_000_000 * 10 ** uint256(decimals);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    error TransferToZeroAddress();
    error InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error InsufficientAllowance(address spender, uint256 approved, uint256 needed);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        uint256 approved = allowance[from][msg.sender];
        if (approved != type(uint256).max && approved < amount) {
            revert InsufficientAllowance(msg.sender, approved, amount);
        }
        if (approved != type(uint256).max) {
            allowance[from][msg.sender] = approved - amount;
        }
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) private {
        if (to == address(0)) {
            revert TransferToZeroAddress();
        }
        uint256 balance = balanceOf[from];
        if (balance < amount) {
            revert InsufficientBalance(from, balance, amount);
        }
        unchecked {
            balanceOf[from] = balance - amount;
        }
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }
}
