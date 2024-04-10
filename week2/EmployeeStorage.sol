// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract EmployeeStorage {
    uint16 private shares;
    uint32 private salary;
    uint256 public idNumber; 
    string public name;

    constructor() {
        shares = 1000;
        name = "Pat";
        salary = 50000;
        idNumber = 112358132134;
    }

    function viewSalary() external view returns (uint32) {
        return salary;
    }

    function viewShares() external view returns (uint16) {
        return shares;
    }

    error TooManyShares(uint32 _shares);
    function grantShares(uint16 _newShares) external {
        if(_newShares > 5000) {
            revert("Too many shares");
        }

        uint16 sum = shares + _newShares;
        
        if(sum > 5000) {
            revert TooManyShares(sum);
        } else {
            shares = sum;
        }

    }

    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    function debugResetShares() public {
        shares = 1000;
    }
}
