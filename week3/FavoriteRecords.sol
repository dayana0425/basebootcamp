// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract FavoriteRecords {
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) public userFavorites;
    string[] private records = [ "Thriller", 
            "Back in Black", 
            "The Bodyguard", 
            "The Dark Side of the Moon", 
            "Their Greatest Hits (1971-1975)", 
            "Hotel California", 
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"];

    constructor() {
        for(uint i = 0; i < records.length; i++) {
            approvedRecords[records[i]] = true;
        }
    }

    function getApprovedRecords() public view returns (string[] memory) {
        return records;
    }

    error NotApproved(string recordName);
    function addRecord(string calldata recordName) external {
        if(approvedRecords[recordName]) {
            userFavorites[msg.sender][recordName] = true;
        } else {
            revert NotApproved(recordName);
        }
    }

    function getUserFavorites(address user) public view returns (string[] memory) {
        string[] memory tempFavs = new string[](records.length);
        uint count = 0;

        for(uint i = 0; i < records.length; i++) {
            if(userFavorites[user][records[i]]) {
                tempFavs[count] = records[i];
                count++;
            }
        }

        string[] memory favs = new string[](count);
        for(uint i = 0; i < count; i++) {
            favs[i] = tempFavs[i];
        }

        return favs;
    }

    function resetUserFavorites() external {
        for(uint i = 0; i < records.length; i++) {
            userFavorites[msg.sender][records[i]] = false;
        }
    }
}
