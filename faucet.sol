// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract POLLENFaucet {
    IERC20 public token;  // ERC20 token interface
    uint256 public claimAmount = 0.1 * 10**18; // Adjust for the token's decimals, assuming 18
    mapping(address => uint256) public lastClaimed;

    // Set the token contract address upon deployment
    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    // Function to claim POLLEN tokens
    function claimTokens() external {
        require(
            block.timestamp > lastClaimed[msg.sender] + 24 hours,
            "You already claimed POLLEN test token in the last 24 hours."
        );

        lastClaimed[msg.sender] = block.timestamp;
        require(
            token.transfer(msg.sender, claimAmount),
            "Token transfer failed."
        );
    }
}
