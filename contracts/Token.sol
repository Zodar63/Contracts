// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() ERC20("Token", "TBA") {
        _mint(msg.sender, 10_00_000_000 * 10 ** decimals());
    }
}
