// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {    
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public maxSupply = 1_000_000;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 proposedQuorum);
    error AlreadyVoted();
    error VotingClosed();

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }
    
     struct ReturnableIssue {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    Issue[] internal issues;

    mapping(address => bool) public hasClaimed;

    enum Vote {
        AGAINST, 
        FOR,
        ABSTAIN
    }

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        issues.push();

        Issue storage firstIssue = issues[issues.length - 1];
        firstIssue.issueDesc = "Initial Issue";
        firstIssue.quorum = 0;
        firstIssue.closed = true;
    }

    function claim() external {
        if (totalSupply() == maxSupply) revert AllTokensClaimed();
        if (hasClaimed[msg.sender]) revert TokensClaimed();

        uint256 claimAmount = 100;

        _mint(msg.sender, claimAmount);
        hasClaimed[msg.sender] = true;
    }

    function createIssue(string calldata _description, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) revert NoTokensHeld();  
        if (_quorum > totalSupply()) revert QuorumTooHigh(_quorum); 

        issues.push();

        Issue storage newIssue = issues[issues.length - 1];
        newIssue.issueDesc = _description;
        newIssue.quorum = _quorum;

        return issues.length - 1; 
    }

    function getIssue(uint256 _id) external view returns (ReturnableIssue memory) {
        Issue storage issue = issues[_id];
        return ReturnableIssue(
            issue.voters.values(),
            issue.issueDesc,
            issue.votesFor,
            issue.votesAgainst,
            issue.votesAbstain,
            issue.totalVotes,
            issue.quorum,
            issue.passed,
            issue.closed
        );
    }

    function vote(uint256 _issueId, Vote _vote) external {
        Issue storage issue = issues[_issueId];
        if(issue.closed) revert VotingClosed();
        if(issue.voters.contains(msg.sender)) revert AlreadyVoted();


        uint256 voterBalance = balanceOf(msg.sender);
        if (_vote == Vote.FOR) {
            issue.votesFor += voterBalance;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else if (_vote == Vote.ABSTAIN) {
            issue.votesAbstain += voterBalance;
        }

        issue.voters.add(msg.sender);

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
