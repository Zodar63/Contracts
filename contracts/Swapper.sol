// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Swapper is Ownable {
    address public token;
    
    constructor(address _token) Ownable(msg.sender) {
        token = _token;
    }

    function swap(address _user, uint256 _value) public onlyOwner {
        IERC20(token).transfer(_user, _value);
        emit Swapped(_user, _value);
    }

    function setTokenAddress(address _token) public onlyOwner {
        token = _token;
    }

    event Swapped(address indexed user, uint256 value);
}