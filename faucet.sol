// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Faucet {
    address public owner;
    IERC20 public pollenToken;
    uint256 public amountAllowed = 0.1 ether; // 0.1 POLLEN (assuming 18 decimals)
    mapping(address => uint256) public lockTime;

    constructor(address _tokenAddress) {
        owner = msg.sender;
        pollenToken = IERC20(_tokenAddress);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    function setOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function setAmountAllowed(uint256 _amountAllowed) public onlyOwner {
        amountAllowed = _amountAllowed;
    }

    function requestTokens() public {
        require(block.timestamp > lockTime[msg.sender], "You already claimed POLLEN test token in the last 24 hours.");
        require(pollenToken.balanceOf(address(this)) >= amountAllowed, "Not enough tokens in the faucet.");

        lockTime[msg.sender] = block.timestamp + 1 days;
        require(pollenToken.transfer(msg.sender, amountAllowed), "Token transfer failed.");
    }

    function withdrawTokens(uint256 amount) public onlyOwner {
        require(pollenToken.transfer(owner, amount), "Token withdrawal failed.");
    }
}