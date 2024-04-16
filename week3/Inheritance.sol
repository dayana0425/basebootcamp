// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

abstract contract Employee {
    uint256 public idNumber;
    uint256 public managerId;

    constructor(uint256 id, uint256 manager) {
        idNumber = id;
        managerId = manager;
    }

    function getAnnualCost() public virtual returns(uint256);
}

contract Salaried is Employee {
    uint256 public annualSalary;
 
    constructor(uint256 id, uint256 manager, uint256 salary) 
    Employee(id, manager) {
        annualSalary = salary;
    }
    
    function getAnnualCost() public override returns(uint256) {
        return annualSalary;
    }
}

contract Hourly is Employee {
    uint256 public hourlyRate;

    constructor(uint256 id, uint256 manager, uint256 rate) 
    Employee(id, manager) {
        hourlyRate = rate;
    }

    function getAnnualCost() public override returns (uint256)  {
        return hourlyRate * 2080;
    }
}

contract Manager {
    uint256[] employeeIds;

    function addReport(uint256 id) public {
        employeeIds.push(id);
    }

    function resetReports() public {
        delete employeeIds;
    }
}

contract SalesPerson is Hourly {

    constructor(uint256 id, uint256 manager, uint256 rate)
    Hourly(id, manager, rate) {

    }
}

contract EngineeringManager is Salaried, Manager {
     constructor(uint256 id, uint256 manager, uint256 salary)
     Salaried(id, manager, salary) {

     }
}
