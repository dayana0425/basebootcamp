// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {    
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();
    
    Haiku[] public haikus;

    mapping(address => uint256[]) public sharedHaikus;
    mapping(string => bool) private usedLines;

    uint256 public counter = 1;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function mintHaiku(string calldata _line1, string calldata _line2, string calldata _line3) external {
        if (usedLines[_line1] || usedLines[_line2] || usedLines[_line3]) {
            revert HaikuNotUnique();
        }
        
        usedLines[_line1] = true;
        usedLines[_line2] = true;
        usedLines[_line3] = true;

        Haiku memory newHaiku = Haiku({
            author: msg.sender,
            line1: _line1,
            line2: _line2,
            line3: _line3
        });

        haikus.push(newHaiku);
        uint256 newHaikuId = haikus.length;
        
        _safeMint(msg.sender, newHaikuId);
        counter++;
    }

    function shareHaiku(uint256 _id, address _to) public {
        if (ownerOf(_id) != msg.sender) {
            revert NotYourHaiku(_id);
        }

        sharedHaikus[_to].push(_id);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        if (sharedHaikus[msg.sender].length == 0) {
            revert NoHaikusShared();
        }
        
        Haiku[] memory _sharedHaikus = new Haiku[](sharedHaikus[msg.sender].length);
        for(uint256 i = 0; i < _sharedHaikus.length; i++) {
            _sharedHaikus[i] = haikus[sharedHaikus[msg.sender][i]];
        }
        
        return _sharedHaikus;
    }
}
