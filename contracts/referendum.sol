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
    bool public approved;
    mapping (address => bool) hasVoted;
    mapping (address => string) voterId;
    Voter[] approvedVoters;
    
    struct Voter {
        address voterAddress;
        string name;
    }
    
    event NewApprovedVoter(address voterAddress, string name);
    event Voted(address voterAddress, string name);
    event Closed(address contractAddress, bool approved);
    
    // Modifier to ensure only approved voters may continue if not public, and that person has not yet voted
    modifier onlyApprovedVoters() {
        require(hasVoted[msg.sender] == false);
        if(!openToPublic) {
            require(keccak256(abi.encodePacked(voterId[msg.sender])) != keccak256(abi.encodePacked("")));
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
        approved = false;
    }
    
    // Voting function, 0 = vote against, 1 = vote for
    function vote(bool _vote) external onlyApprovedVoters onlyDuringVotingTime {
        if(_vote) {
            votesFor++;
        } else {
            votesAgainst++;
        }
        hasVoted[msg.sender] = true;
    }
    
    // Adds an approved voter and assigns voterId
    function addVoter(address _voterAddress, string _name) external onlyOwner {
        voterId[_voterAddress] = _name;
        
        uint id = approvedVoters.length++;
        approvedVoters[id] = Voter({voterAddress: _voterAddress, name: _name});
        emit NewApprovedVoter(_voterAddress, _name);
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

    // Sets the referendum to closed
    function closeReferendum() external onlyOwner onlyAfterVotingTime {
        completed = true;
        if (votesFor > votesAgainst) {
           approved = true; 
        }
        emit Closed(this, approved);
    }

    // Gets the summary of the referendum   
    function getSummary() public view returns (address, string, string, uint, uint, uint, uint, bool, bool, bool) {
        return (
            owner,
            title,
            description,
            startingDatetime,
            endingDatetime,
            votesFor,
            votesAgainst,
            openToPublic,
            completed,
            approved
        );
    }

}