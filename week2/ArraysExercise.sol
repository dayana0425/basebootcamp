// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract ArraysExercise {
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];
    address[] senders;
    uint[] timestamps; 

    function resetNumbers() public {
        delete numbers;
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; 
    }

    function resetSenders() public {
        delete senders;
    }

    function resetTimestamps() public {
        delete timestamps;
    }

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function saveTimestamp(uint _unixTimestamp) public {
        timestamps.push(_unixTimestamp);
        senders.push(msg.sender);
    }

    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint count = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                count++;
            }
        }
        address[] memory newSenders = new address[](count);
        uint[] memory newTimestamps = new uint[](count);

        count = 0;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                newSenders[count] = senders[i];
                newTimestamps[count] = timestamps[i];
                count++;
            }
        }
        return (newTimestamps, newSenders);
    }
}
