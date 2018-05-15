var Token = artifacts.require("./intellosToken.sol");
var AdvisorVesting = artifacts.require("./AdvisorVesting.sol");
var TeamVesting = artifacts.require("./TeamVesting.sol");

module.exports = function(deployer) {
    deployer.deploy(Token);
    var advisor, team, token;
    //**** TODO: "HERE must be the correct numbers!"
    const date = new Date('2017.06.20').getTime() / 1000;
    const teamAmount = 1000;
    const advisorAmount = 1000;
    deployer.then(function() {
        return AdvisorVesting.new(date);
    }).then(function(instance) {
        advisor = instance;
        return TeamVesting.new(date);
    }).then(function(instance) {
        team = instance;
        return Token.new();
    }).then(function(instance) {
        token = instance;
        return token.mint(team.address, teamAmount);
    }).then(function() {
        return token.mint(advisor.address, advisorAmount);
    });
};