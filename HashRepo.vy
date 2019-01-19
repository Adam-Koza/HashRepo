# HashRepo

# Events
NewRepo: event({_repo: indexed(uint256), _owner: indexed(address), _name: bytes[32], _isPublic: bool, _forkOf: uint256})
AddCommit: event({_repo: indexed(uint256), _commitCount: uint256, _commiter: indexed(address), _IPFS: bytes[32], _message: bytes[32], _timestamp: timestamp})

# Repo information
#Repo: {
#    repoMaster: address,
#    commitCount: uint256,
#    isPublic: bool,
#    whiteList: bool[address],
#    commitLog: bytes[32][uint256]
#}

# Contract owner
owner: public(address)
repoID: public(uint256)

# Repo[uint256] mapping work arround.
repoInfo_Master: public(address[uint256])
repoInfo_Count: public(uint256[uint256])
repoInfo_Public: public(bool[uint256])
repoInfo_White: public(bool[address][uint256])
repoInfo_Log: public(bytes[32][uint256][uint256])


@public
def __init__():
    self.owner = msg.sender
    
@public
def sendCommit (_repoID: uint256, _commitHash: bytes[32], _commitMessage: bytes[32]):
    assert self.repoInfo_Public[_repoID] or self.repoInfo_White[_repoID][msg.sender]
    self.repoInfo_Log[_repoID][self.repoInfo_Count[_repoID]] = _commitHash
    log.AddCommit(_repoID, self.repoInfo_Count[_repoID], msg.sender, _commitHash, _commitMessage, block.timestamp)
    self.repoInfo_Count[_repoID] += 1
    
@public
def newHashRepo (_name: bytes[32], _isPublic: bool) -> uint256:
    self.repoID += 1
    self.repoInfo_Master[self.repoID] = msg.sender
    self.repoInfo_White[self.repoID][msg.sender] = True
    self.repoInfo_Public[self.repoID] = _isPublic
    log.NewRepo(self.repoID, msg.sender, _name, _isPublic, 0)
    return self.repoID
    
@public
def addToWhiteList (_repoID: uint256, _add: address):
    assert self.repoInfo_Master[_repoID] == msg.sender
    self.repoInfo_White[_repoID][_add] = True
    

@public
def removeFromWhiteList (_repoID: uint256, _remove: address):
    assert self.repoInfo_Master[_repoID] == msg.sender
    self.repoInfo_White[_repoID][_remove] = False
    

