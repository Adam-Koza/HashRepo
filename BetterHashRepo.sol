pragma solidity ^0.5.2;

contract BetterHashRepo {

    uint public repoID;
    
    struct Repo {
        address repoMaster;
        uint commitCount;
        bool isPublic;
        mapping(address => bool) whiteList;
        mapping(uint => string) commitLog;
    }
    
    mapping(uint => Repo) public repoInfo;
    mapping(bytes32 => uint) public nameToRepoID;
    mapping(uint => bytes32) public idToName;

    
    event NewRepo (uint indexed repo, address indexed owner, bytes32 name, bool isPublic, uint forkOf);
    event AddCommit (uint indexed repo, uint commitCount, address indexed commiter, string IPFS, string message, uint timestamp);

    constructor() public {}
    
    function sendCommit (uint _repoID, string memory _commitHash, string memory _commitMessage) public {
        require(repoInfo[repoID].isPublic || repoInfo[_repoID].whiteList[msg.sender], "You are not authorized to commit to this repo.");
        repoInfo[_repoID].commitLog[repoInfo[_repoID].commitCount] = _commitHash;
        emit AddCommit (_repoID, repoInfo[_repoID].commitCount, msg.sender, _commitHash, _commitMessage, now);
        repoInfo[_repoID].commitCount += 1;

    }

    function newHashRepo (bytes32 _name, bool _isPublic) public returns (uint) {
        require(nameToRepoID[_name] == 0, "Repo name has been taken, please choose another name.");
        repoID += 1;
        repoInfo[repoID].repoMaster = msg.sender;
        repoInfo[repoID].whiteList[msg.sender] = true;
        repoInfo[repoID].commitCount = 0;
        repoInfo[repoID].isPublic = _isPublic;
        nameToRepoID[_name] = repoID;
        idToName[repoID] = _name;
        emit NewRepo (repoID, msg.sender, _name, _isPublic, 0);
        return repoID;
    }
    
    function forkRepo (uint _repoID, bytes32 _name, bool _isPublic) public returns (uint) {
        require(nameToRepoID[_name] == 0, "Repo name has been taken, please choose another name.");
        repoID += 1;
        repoInfo[repoID].repoMaster = msg.sender;
        repoInfo[repoID].whiteList[msg.sender] = true;
        repoInfo[repoID].commitCount = repoInfo[_repoID].commitCount;
        repoInfo[repoID].isPublic = _isPublic;
        repoInfo[repoID].isPublic = _isPublic;
        nameToRepoID[_name] = repoID;
        for (uint i = 0; i<repoInfo[_repoID].commitCount; i++) {
            repoInfo[repoID].commitLog[i] = repoInfo[_repoID].commitLog[i];
        }
        emit NewRepo (repoID, msg.sender, _name, _isPublic, _repoID);
        return repoID;
    }

    function AddToWhiteList (uint _repoID, address _add) public {
        require(repoInfo[_repoID].repoMaster == msg.sender, "You are not the repo master.");
        repoInfo[repoID].whiteList[_add] = true;
    }

    function RemoveFromWhiteList (uint _repoID, address _remove) public {
        require(repoInfo[_repoID].repoMaster == msg.sender, "You are not the repo master.");
        repoInfo[repoID].whiteList[_remove] = false;
    }
    
    function GetCommitCount (uint _repoID) public view returns(uint) {
        return repoInfo[_repoID].commitCount;
    }

    function GetCommitHash (uint _repoID, uint _commitID) public view returns(string memory) {
        return repoInfo[_repoID].commitLog[_commitID];
    }

    function GetRepoID (bytes32 _name) public view returns(uint) {
        return nameToRepoID[_name];
    }

    function GetRepoName (uint _repoID) public view returns(bytes32) {
        return idToName[_repoID];
    }
}
