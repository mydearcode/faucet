// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PollenFaucet {
    IERC20 public pollenToken;
    uint256 public amountAllowed = 0.1 ether; // 0.1 POLLEN (assuming 18 decimals)
    mapping(address => uint256) public lastRequestTime;

    constructor(address _tokenAddress) {
        pollenToken = IERC20(_tokenAddress);
    }

    function requestTokens() external {
        require(block.timestamp >= lastRequestTime[msg.sender] + 1 days, "You can only request once per day");
        require(pollenToken.balanceOf(address(this)) >= amountAllowed, "Faucet is empty");

        lastRequestTime[msg.sender] = block.timestamp;
        require(pollenToken.transfer(msg.sender, amountAllowed), "Transfer failed");
    }

    // Allow anyone to deposit POLLEN tokens to the faucet
    function deposit(uint256 amount) external {
        require(pollenToken.transferFrom(msg.sender, address(this), amount), "Deposit failed");
    }

    // Allow receiving POLLEN tokens directly
    receive() external payable {}
}