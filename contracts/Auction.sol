// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Auction {
    address payable owner;
    uint256 public minAmount = 0.01 ether;
    uint256 public votingPeriod = 3 days;
    uint256 totalVotes = 0;

    constructor() {
        owner = payable(msg.sender);
    }

    struct Votes {
        uint256 id;
        uint256 budget;
        uint256 votesCount;
        mapping(address => Voter) voters;
        mapping(uint256 => Voter) votersInt;
        uint256 createdAt;
        bool isFinished;
    }

    struct Voter {
        bool voted;
        uint256 bid;
        string name;
        address voterAddress;
        uint256 id;
    }

    mapping(uint256 => Votes) votes;


    modifier onlyOwner {
        require(msg.sender == owner, "Error! You're not the smart contract owner!");
        _;
    }

    function addVoting() public onlyOwner {
        totalVotes++;
        Votes storage vote = votes[totalVotes];
        vote.id = totalVotes;
        vote.createdAt = block.timestamp;
        vote.isFinished = false;
    }

    function addUserAndVote(uint256 voteId, string memory _username, address _sendTo) payable public  {
        require(votes[voteId].id != 0, "vote id not found");
        require(msg.value >= minAmount, "min amount must more then 0.01 or equals it!");
        Votes storage voting = votes[voteId];
        Voter memory receiver = votes[voteId].voters[_sendTo];
        require(voting.voters[msg.sender].voted == false, "user already voted!");
        owner.transfer(msg.value);
        voting.budget += msg.value;
        receiver.bid += msg.value;
        voting.voters[_sendTo] = receiver;
        voting.votesCount += 1;
        voting.voters[msg.sender] = Voter(true, msg.value, _username, msg.sender,  voting.votesCount);
        voting.votersInt[voting.votesCount] = Voter(true, msg.value, _username, msg.sender,  voting.votesCount);
    }

    function getVoters(uint256 voteId) external view returns(Voter[] memory) {
        require(votes[voteId].id != 0, "vote id not found");
        uint256 allVoters = votes[voteId].votesCount;
        Voter[] memory voters = new Voter[](allVoters);
        for (uint256 i = 0; i < allVoters; i++) {
            voters[i] = votes[voteId].votersInt[i];
        }
        return voters;
    }

    function finishVote(uint256 voteId) public {
        require(votes[voteId].createdAt + votingPeriod < block.timestamp, "You can finish this vote on 3 days after creating");
        votes[voteId].isFinished = true;
    }

    function getVotesCount() external view returns(uint256) {
        return totalVotes;
    }
}
