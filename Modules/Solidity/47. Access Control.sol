// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessControl {
    event GrantRole(bytes32 indexed role, address indexed account);
    // indexed so we can quickly filter through the log
    event RevokeRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address => bool)) public roles;
    // role => account => bool;
    // role is byte32 to HASH the role (gas saver)
    bytes32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
    // private will use less gas
    // public to test contract to get the bytes32 hash 

    modifier onlyRole(bytes32 role) {
        require(roles[role][msg.sender], "not authorized");
        _;
    }

    function _grantRole(bytes32 role, address account) internal {
        // Write code here
        roles[role][account] = true;
        emit GrantRole(role, account);

    }

    constructor() {
        _grantRole(ADMIN, msg.sender);
    }

    function grantRole(bytes32 role, address account) external onlyRole(ADMIN) {
        // Write code here
        _grantRole(role, account);
    }

    function revokeRole(bytes32 role, address account) external onlyRole(ADMIN) {
        // Write code here
        roles[role][account] = false;
        emit RevokeRole(role, account);
    }
}