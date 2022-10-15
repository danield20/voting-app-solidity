pragma solidity >=0.7.0;

contract Ballot {

    struct Voter {
        bool voted;
        uint weight;
        uint vote;
    }

    struct Proposal {
        string name;
        uint voteCount;
    }

    Proposal[] public proposals;
    mapping(address => Voter) public voters;

    address public chairperson;
    
    constructor(string[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    modifier onlyChairman() {
        if(msg.sender == chairperson)
            _;
    }

    function giveRightToVote(address voter) public onlyChairman {
        require(!voters[voter].voted, "The user has already voted");
        voters[voter].weight = 1;
    }

    function vote(uint proposal) public {
        Voter storage voter = voters[msg.sender];
        require(voter.weight > 0);
        require(!voter.voted);
        voter.voted = true;
        voter.vote = proposal;

        proposals[proposal].voteCount += voter.weight;
    }

    function winningProposal() public view returns (uint winning_proposal) {
        uint winProposal = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winProposal) {
                winProposal = proposals[i].voteCount;
                winning_proposal = i;
            }
        }
    }

    function winningName() public view returns (string memory winning_name) {
        winning_name = proposals[winningProposal()].name;
    }
}