// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is Ownable {
    using ECDSA for bytes32;

    address public immutable token;
    address public admin;
    address public immutable dev; // AdminContract Address where the token holds
    uint256 public fees = 5 * 1e18; // percentage fees should be in 18 decimals
    uint256 public exchangeRate = 1 * 1e18; // 1 vTBA = 1 TBA

    mapping(uint256 => bool) public nonces;
    address private immutable _self;

    constructor(
        address _token,
        address _devAddress
    ) Ownable(msg.sender) {
        token = _token;
        dev = _devAddress;
        _self = address(this);
    }

    // setFees
    function setFees(uint256 _fees) public onlyOwner() {
        assert(fees != _fees);
        fees = _fees;
    }

    function setExchangeRate(uint256 _exchangeRate) public onlyOwner() {
        exchangeRate = _exchangeRate;
    }

    function buyvTBA(
        bytes memory signature,
        address _user,
        uint256 _amount,
        uint256 _deadline,
        uint256 nonce
    ) external verify(signature, _user, _amount, _deadline, nonce) {
        uint256 _feeAmount = (_amount * fees) / 100;
        _feeAmount = _feeAmount / 1e18;
        uint256 _amountToTransfer = _amount - _feeAmount;
        _amountToTransfer = (_amountToTransfer * exchangeRate) / 1e18;
        
        IERC20(token).transferFrom(_user, _self, _amountToTransfer);
        IERC20(token).transfer(dev, _feeAmount);
        
        nonces[nonce] = true;
        emit vTBADBBought(_amountToTransfer, nonce, _user);
    }

    function sellvTBA(
        bytes memory signature,
        address _user,
        uint256 _amount,
        uint256 _deadline,
        uint256 nonce
    ) external verify(signature, _user, _amount, _deadline, nonce) {
        uint256 _amountToTransfer = (_amount * 1e18) / exchangeRate;
        IERC20(token).transfer(_user, _amountToTransfer);
        
        emit vTBADBSold(_amountToTransfer, nonce, _user);
    }

    function getMessageHash(string memory message) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(message));
    }

    function getEthSignedMessageHash(bytes32 messageHash) private pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
    }

    function verifyInputs(bytes memory signature, address _user, uint256 _amount, uint256 _deadline, uint256 nonce) public view returns (bool) {
        bytes32 messageHash = keccak256(abi.encodePacked(_user, _amount, _deadline, nonce));
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == owner();
    }

    modifier verify(
        bytes memory signature,
        address _user,
        uint256 _amount,
        uint256 _deadline,
        uint256 nonce
    ) {
        require(_deadline > block.timestamp, "Signature expired");
        require(_amount > 0, "Amount should be greater than 0");
        require(nonces[nonce] == false, "Nonce already used");

        bytes32 messageHash = keccak256(abi.encodePacked(_user, _amount, _deadline, nonce));
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        address signer = recoverSigner(ethSignedMessageHash, signature);

        require(verifyInputs(signature, _user, _amount, _deadline, nonce) == true, "Invalid signature");

        _;
    }

    // Modifier only admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function recoverSigner(bytes32 ethSignedMessageHash, bytes memory signature) private pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(signature);

        return ecrecover(ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig) private pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        return (r, s, v);
    }

    event vTBADBBought(uint256 amount, uint256 nonce, address indexed account);
    event vTBADBSold(uint256 amount, uint256 nonce, address indexed account);
}
