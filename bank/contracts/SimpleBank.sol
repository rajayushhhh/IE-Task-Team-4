// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract SimpleBank {
    address public owner;

    // mapping to track user balances
    mapping(address => uint256) public balances;

    // events for deposit/withdrawal
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    // owner only modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // deposit funds
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    
    // withdraw funds
    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        emit Withdraw(msg.sender, _amount);
    }

    // fetch contract balance (owner only)
    function getContractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }
}
