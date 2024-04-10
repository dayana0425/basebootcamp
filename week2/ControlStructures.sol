// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract ControlStructures {
    function fizzBuzz(uint256 _number) external pure returns (string memory) {
        if (_number % 3 == 0 || _number % 5 == 0) {
            return "FizzBuzz";
        } else if (_number % 3 == 0) {
            return "Fizz";
        } else if (_number % 5 == 0) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }

    error AfterHours(uint256 _time);
    function doNotDisturb(uint256 _time) external pure returns (string memory) {
        assert(_time < 2400);

        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }

        if (_time > 1200 && _time < 1259) {
            revert("At lunch!");
        }

        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }

        if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        } 
        
        if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        return "Unknown";
    }
}
