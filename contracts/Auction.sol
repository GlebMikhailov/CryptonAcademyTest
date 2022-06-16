// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Auction {
    address public owner;
    uint256 public minAmount = 0.01 ether;
    uint256 public votingPeriod = 3 days;
    /** for test **/
    //uint256 public votingPeriod = 1 minutes;
    uint256 totalVotes;
    uint256 comission;

    constructor() {
        owner = msg.sender;
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
        votes[totalVotes].id = totalVotes;
        votes[totalVotes].createdAt = block.timestamp;
        votes[totalVotes].isFinished = false;

    }


    function addUser(uint256 voteId, string memory _username, address _sendTo) payable external {
        require(totalVotes >= voteId);
        require(voteId != 0);
        require(msg.value >= minAmount, "min amount must more then 0.01 or equals it!");
        require(votes[voteId].voters[msg.sender].voted == false);
        votes[voteId].votesCount++;

        votes[voteId].budget += msg.value;
        votes[voteId].voters[_sendTo].bid += msg.value;

        votes[voteId].voters[msg.sender] = Voter(true, msg.value, _username, msg.sender, votes[voteId].votesCount);
        votes[voteId].votersInt[votes[voteId].votesCount] = Voter(true, msg.value, _username, msg.sender, votes[voteId].votesCount);

    }

    function getVoters(uint256 voteId) external view returns(Voter[] memory) {
        require(totalVotes >= voteId);
        require(voteId != 0);

        uint256 allVoters = votes[voteId].votesCount;

        Voter[] memory voters = new Voter[](allVoters);

        for (uint256 i; i < allVoters; i++) {
            voters[i] = votes[voteId].votersInt[i + 1];
        }
        return voters;
    }

    function finishVote(uint256 voteId) external returns(address){
        require(totalVotes >= voteId);
        require(voteId != 0);

        require(votes[voteId].createdAt + votingPeriod < block.timestamp, "You can finish this vote on 3 days after creating");
        votes[voteId].isFinished = true;

        uint256 allVoters = votes[voteId].votesCount;

        Voter[] memory voters = new Voter[](allVoters);

        address voterMax;
        uint256 maxMoney;

        for (uint256 i; i < allVoters; i++) {
            voters[i] = votes[voteId].votersInt[i + 1];
            if(voters[i].bid > maxMoney){
                voterMax = voters[i].voterAddress;
                maxMoney = voters[i].bid;
            }
        }

        (bool success, ) = payable(voterMax).call {
                value: votes[voteId].budget / 100 * 90
            }("");
        require(success);
        comission += votes[voteId].budget / 100 * 10;

        return(voterMax);

    }

    function getVotesCount() external view returns(uint256) {
        return totalVotes;
    }

    function withdraw() external onlyOwner{
        (bool success, ) = payable(owner).call{
            value: comission
        }("");
        require(success);
    }
}
