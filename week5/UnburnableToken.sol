// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract UnburnableToken {

    mapping(address => uint256) public balances;
    mapping(address => bool) public hasClaimed;

    uint256 public totalSupply;
    uint256 public totalClaimed;

    error AllTokensClaimed();
    error TokensClaimed();
    error UnsafeTransfer(address _addr);


    constructor() {
        totalSupply =  100_000_000;
    }

    function claim() public {
        if (totalClaimed == totalSupply) {
            revert AllTokensClaimed();
        }
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        totalClaimed += 1_000;
        balances[msg.sender] += 1_000;
        hasClaimed[msg.sender] = true;
    }

    function safeTransfer(address _to, uint256 _amount) public {
        if (_to == address(0) || _to.balance == 0) {
            revert UnsafeTransfer(_to);
        }
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
