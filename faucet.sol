// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PollenFaucet {
    address public owner;
    uint256 public amountAllowed = 0.1 ether; // 0.1 POLLEN
    mapping(address => uint256) public lastRequestTime;

    constructor() {
        owner = msg.sender;
    }

    function requestTokens(address recipient) public {
        require(block.timestamp >= lastRequestTime[recipient] + 1 days, "You can only request once per day");
        require(address(this).balance >= amountAllowed, "Faucet is empty");

        lastRequestTime[recipient] = block.timestamp;
        payable(recipient).transfer(amountAllowed);
    }

    receive() external payable {}
}