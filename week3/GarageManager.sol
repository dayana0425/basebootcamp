// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract GarageManager {

    struct Car {
        string make;
        string model;
        string color;  
        uint256 numberOfDoors; 
    }

    mapping(address => Car[]) public garage;

    function addCar(string memory make, string memory model, string memory color, uint256 numberOfDoors) external {
        Car memory newCar = Car(make, model, color, numberOfDoors); 
        garage[msg.sender].push(newCar);
    }

    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address addr) external view returns (Car[] memory) {
        return garage[addr];
    }

    error BadCarIndex(uint256 index);
    function updateCar(uint256 index, string memory make, string memory model, string memory color, uint256 numberOfDoors) external {
        Car[] storage myCars = garage[msg.sender];
        if (index >= myCars.length) {
            revert BadCarIndex(index);
        }

        myCars[index] = Car(make, model, color, numberOfDoors);
    }

    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}
