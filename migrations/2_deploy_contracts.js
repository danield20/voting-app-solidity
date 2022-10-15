const Ballot = artifacts.require("Ballot");

module.exports = function(deployer) {
  deployer.deploy(Ballot, ["Proposal1", "Proposal2"]);
};
