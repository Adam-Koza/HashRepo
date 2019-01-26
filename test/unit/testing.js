const assert = require("chai").assert;
const { BN, constants, expectEvent, shouldFail } = require('openzeppelin-test-helpers');

const HashRepo = artifacts.require('HashRepo.sol');

const _repoID = '11';
const _commitHash = 'QmaqpNu4ExDP7pe3wwmahqm1dT3K7TUgrqwsnfatRSsP9N';
const _commitMessage = 'Hello IPFS';

contract('HashRepo', function ([owner, initialRecipient, transferRecipient]) {
    beforeEach(async function(){
        this.repo = await HashRepo.new(_repoID, _commitHash, _commitMessage, { from: owner });
    });

    describe('Sending Commits', function(){// sendCommit(_repoID, _commitHash, _commitMessage){
        
        it('Should have the correct repo ID', async function(){
            (await this.repo.repoID())
                .should.be.bignumber.equal(new BN(11));
        });
        it('Should have the correct Hash commited', async function(){
            (await this.repo.sendCommit(_repoID, _commitHash, _commitMessage))
                .should.be.equal(_commitHash);
        });
        it('Should have the correct message from hash', async function(){
            (await this.repo.commitMessage())
                .should.be.bignumber.equal(_commitMessage);
        });
        it('Should have the correct permission: public' , async function(){
            (await this.repo.isPublic())
                //pending
        });
    });

    describe('Commit Count', function(){

        it('Should increment and update count with each commit', async function(){
            (await this.repo.commitCount())
                //pending
        });
        it('Should increment repoID with each commit', async function(){
            (await this.repo.repoID())
                //pending
        });
    });

    describe('Whitelist', function(){
        it('Should be on the whitelist', async function(){
            (await this.repo.whiteList())
                //pending
        });
        it('Should be removed on the whitelist', async function(){
            (await this.repo.whiteList())
                //pending
        });
    });

    describe('Retrive Data', function(){
        it('Should return the name of the Repo', async function(){
            (await this.repo.name())
                //nameToRepoID[_name];
        });
        it('Should return Repo ID', async function(){
            (await this.repo.repoID())
                //idToName[_repoID];
        });
        it('Should return data from Repo ID', async function(){
            (await this.repo.repoInfo())
                //
        });
    });
});
