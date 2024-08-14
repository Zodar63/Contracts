// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Contract for DevFee
contract AdminFee {
    address public admin;
    address public token; // Token address

    constructor(address _token) {
        admin = msg.sender;
        token = _token;
    }

    function setToken(address _token) public onlyAdmin {
        token = _token;
    }

    // function for updating admin only can be updated by the admin
    function updateAdmin(address _admin) external {
        require(_admin != address(0), "Invalid address");
        require(msg.sender == admin, "Only admin can perform this action");
        admin = _admin;
    }

    // function to withdraw token only by admin
    function withdraw(uint256 amount) external onlyAdmin {
        require(msg.sender == admin, "Only admin can perform this action");
        IERC20(token).transfer(msg.sender, amount);
    }

    // Modifier only admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
}
