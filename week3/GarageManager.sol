// Structs Exercise

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract GarageManager {

    struct Car {
        uint8 numberOfDoors; 
        string make;
        string model;
        string color;    
    }

    mapping(address => Car[]) public garage;

    function addCar(string memory make, string memory model, string memory color, uint8 numberOfDoors) public {
        Car memory newCar = Car(numberOfDoors, make, model, color); 
        garage[msg.sender].push(newCar);
    }

    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    error BadCarIndex(uint index);
    function updateCar(uint index, string memory make, string memory model, string memory color, uint8 numberOfDoors) public {
        Car[] storage myCars = garage[msg.sender];
        if (index >= myCars.length) {
            revert BadCarIndex(index);
        }

        myCars[index] = Car(make, model, color, numberOfDoors);
    }

    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
