var HashRepo = artifacts.require("./HashRepo.sol");

module.exports = function(deployer) {
  deployer.deploy(HashRepo, "initial message");
};

