///@title Campaign Smart Contract v1.0
///@author Keith Mattison

pragma solidity ^0.4.25;

// +--------------------+
// | Factory Definition |
// +--------------------+
contract ReferendumFactory {
    Referendum[] public deployedReferendums;
    function createReferendum(string _title, string _description, uint _startingDatetime, uint _endingDatetime) public {
        Referendum referendum = new Referendum(_title, _description, _startingDatetime, _endingDatetime, msg.sender);
        deployedReferendums.push(referendum);
    }
    
    function getDeployedReferendums() public view returns (Referendum[] memory) {
        return deployedReferendums;
    }
}


// +---------------------+
// | Contract Definition |
// +---------------------+
contract Referendum {
    
    address public owner;
    string public title;
    string public description;
    uint public startingDatetime;
    uint public endingDatetime;
    uint public votesFor;
    uint public votesAgainst;
    uint public creationTime;
    bool public openToPublic;
    bool public completed;
    mapping (address => bool) hasVoted;
    mapping (address => uint) voterId;
    Voter[] approvedVoters;
    
    struct Voter {
        address voterAddress;
        string name;
    }
    
    event NewApprovedVoter(address voterAddress, string name);
    event Voted(address voterAddress, string name);
    
    // Modifier to ensure only approved voters may continue if not public, and that person has not yet voted
    modifier onlyApprovedVoters() {
        require(hasVoted[msg.sender] == false);
        if(openToPublic) {
            require(voterId[msg.sender] != 0);
        }
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    // Modifier to ensure votes can only in the voting window
    modifier onlyDuringVotingTime() {
        require(startingDatetime <= now);
        require(now <= endingDatetime);
        _;
    }
    
    // Modifier to ensure it's past voting time 
    modifier onlyAfterVotingTime() {
        require(now > endingDatetime);
        _;
    }
    
    // Constructor sets initial variables
    constructor(string _title, string _description, uint _startingDatetime, uint _endingDatetime, address _owner) public {
        owner = _owner;
        title = _title;
        description = _description;
        startingDatetime = _startingDatetime;
        endingDatetime = _endingDatetime;
        votesFor = 0;
        votesAgainst = 0;
        openToPublic = false;
        completed = false;
        creationTime = now;
    }
    
    // Voting function, 0 = vote against, 1 = vote for
    function vote(bool _vote) external onlyApprovedVoters onlyDuringVotingTime {
        if(_vote) {
            votesFor++;
        } else {
            votesAgainst = votesAgainst++;
        }
        hasVoted[msg.sender] = true;
    }
    
    // Adds an approved voter and assigns voterId
    function addVoter(address _voterAddress, string _name) external onlyOwner {
        uint id = voterId[_voterAddress];
        if (id == 0) {
            voterId[_voterAddress] = approvedVoters.length;
            id = approvedVoters.length++;
        }

        approvedVoters[id] = Voter({voterAddress: _voterAddress, name: _name});
        emit NewApprovedVoter(_voterAddress, _name);
    }
    
    // Removes an approved voter and unsassigns voterId
    function removeVoter(address _voterAddress) external onlyOwner {
        require(voterId[_voterAddress] != 0);

        for (uint i = voterId[_voterAddress]; i<approvedVoters.length-1; i++){
            approvedVoters[i] = approvedVoters[i+1];
            voterId[approvedVoters[i].voterAddress] = i;
        }
        voterId[_voterAddress] = 0;
        delete approvedVoters[approvedVoters.length-1];
        approvedVoters.length--;
    }
    
    // Allows owner to open or close vote to public
    function openVoteToPublic(bool _openToPublic) external onlyOwner {
        openToPublic = _openToPublic;
    }

    // Gets the array of approved voters
    function getApprovedVoters(uint index) view external returns (address, string) {
        Voter memory tempVoter = approvedVoters[index];
        return (tempVoter.voterAddress, tempVoter.name);
    }
    
    // Gets the number of approved voters
    function getApprovedVotersCount() view external returns (uint) {
        return approvedVoters.length;
    }
    
    function closeReferendum() external onlyOwner {
        completed = true;
    }

}