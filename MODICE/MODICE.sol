// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract MODICEToken is ERC20, Ownable {
    using ECDSA for bytes32;

    mapping (uint256 => uint256) public claimedNonces;

    event GetMODICE(address indexed sender, uint256 value, uint256 nonce);

    constructor() ERC20("Tokenized MODIC", "MODICE") {}

    function decimals() public override pure returns (uint8) {
        return 8;
    }

    function getMODICE(uint256 value, uint256 nonce, bytes memory signature) public {
        require(claimedNonces[nonce] == 0, "Nonce is already used");
        require(keccak256(abi.encodePacked(msg.sender, value, nonce, address(this))).toEthSignedMessageHash().recover(signature) == owner(), "Invalid signature");
        claimedNonces[nonce] = value;
        _mint(msg.sender, value);
        emit GetMODICE(msg.sender, value, nonce);
    }
}
