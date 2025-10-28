// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GreenToken - A Blockchain-Based Carbon Credit Marketplace
/// @author ...
/// @notice This contract allows minting, trading, and redeeming carbon credits.

contract GreenToken {
    string public name = "GreenToken";
    string public symbol = "GTN";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Redeem(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Mint new carbon credits to a user
    /// @param to Address to receive tokens
    /// @param amount Number of tokens to mint
    function mint(address to, uint256 amount) external onlyOwner {
        require(amount > 0, "Invalid amount");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    /// @notice Transfer carbon credits to another user
    /// @param to Recipient address
    /// @param amount Amount to transfer
    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /// @notice Redeem (burn) tokens to offset carbon
    /// @param amount Number of tokens to burn
    function redeem(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Redeem(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }
}
