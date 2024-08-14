// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FaucetToken {
    IERC20 public token;
    uint256 public currentAirdropAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function claimTokens(address recipient, uint256 amount) external {
        currentAirdropAmount += amount;
        token.transfer(recipient, amount);
    }
}
