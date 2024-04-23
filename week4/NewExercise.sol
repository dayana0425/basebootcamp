// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    struct Contact {
        uint256 id;
        string firstName;
        string lastName;
        uint256[] phoneNumbers;
    }

    Contact[] contacts;

    mapping (uint256 => uint256) public idToIndex;

    constructor(address _owner) Ownable(_owner) {}

    function addContact(
        uint256 _id,
        string calldata _firstName,
        string calldata _lastName,
        uint256[] calldata _phoneNumbers
    ) external onlyOwner() {
        idToIndex[_id] = contacts.length + 1;
        contacts.push(Contact(_id, _firstName, _lastName, _phoneNumbers));
    }

    error ContactNotFound(uint _id);
    function deleteContact(uint _id) external onlyOwner() {
        if(idToIndex[_id - 1] <= 0) revert ContactNotFound(_id);
        
        delete contacts[idToIndex[_id - 1]];
    }

    function getContact(uint _id) external view returns(Contact memory) {
        if(idToIndex[_id - 1] <= 0) revert ContactNotFound(_id);
        return contacts[idToIndex[_id - 1]];
    }

    function getAllContacts() external view returns(Contact[] memory) {
        return contacts;
    }
}

contract AddressBookFactory {
    function deploy() external returns (address) {
        AddressBook newAddressBook = new AddressBook(msg.sender);
        return address(newAddressBook);
    }
}
