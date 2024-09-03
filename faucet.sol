// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PollenFaucet {
    address public owner;
    uint256 public amountAllowed = 0.1 ether; // 0.1 POLLEN
    mapping(address => uint256) public lastRequestTime;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function requestTokens() external {
        require(block.timestamp >= lastRequestTime[msg.sender] + 1 days, "You can only request once per day");
        require(address(this).balance >= amountAllowed, "Faucet is empty");

        lastRequestTime[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(amountAllowed);
    }

    function withdraw(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(owner).transfer(amount);
    }

    receive() external payable {}
}