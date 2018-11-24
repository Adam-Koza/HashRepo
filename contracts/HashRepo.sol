pragma solidity ^0.4.25;

contract HashRepo {

    uint public repoID;

    struct Commit {
        address commiter;
        string hashMessage;
        uint commitBlock;
    }
    
    struct Repo {
        address repoMaster;
        uint commitCount;
        bool isPrivate;
        mapping(address => bool) whiteList;
        mapping(uint => Commit) commitLog;
    }

    mapping(uint => Repo) public repoInfo;

    constructor() public {
        repoID = 0;
    }

    function newHashRepo (bool _private) public {
        repoInfo[repoID].repoMaster = msg.sender;
        repoInfo[repoID].whiteList[msg.sender] = true;
        repoInfo[repoID].commitCount = 0;
        repoInfo[repoID].isPrivate = _private;
        repoID += 1;
    }

    function sendHash (uint _repoID, string _msg) public {
        require(!repoInfo[repoID].isPrivate || repoInfo[_repoID].whiteList[msg.sender], "You are not the authorized to push to this repo.");
        repoInfo[_repoID].commitLog[repoInfo[_repoID].commitCount].commiter = msg.sender;
        repoInfo[_repoID].commitLog[repoInfo[_repoID].commitCount].hashMessage = _msg;
        repoInfo[_repoID].commitLog[repoInfo[_repoID].commitCount].commitBlock = block.number;
        repoInfo[_repoID].commitCount += 1;

    }

    function AddToWhiteList (uint _repoID, address _add) public {
        require(repoInfo[_repoID].repoMaster == msg.sender, "You are not the repo master.");
        repoInfo[repoID].whiteList[_add] = true;
    }

    function RemoveFromWhiteList (uint _repoID, address _remove) public {
        require(repoInfo[_repoID].repoMaster == msg.sender, "You are not the repo master.");
        repoInfo[repoID].whiteList[_remove] = false;
    }

}
