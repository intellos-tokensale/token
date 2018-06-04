const erc20 = require('./erc20');

const Token = artifacts.require('intellosToken');

contract('Erc20Test Smart Containers', function(accounts) {
    erc20({
        accounts: accounts,
        create: async() => {
            return await Token.new();
        },
        mint: async(contract, to, amount) => {
            await contract.mint(to, amount, { from: accounts[0] });
            await contract.finishMinting({ from: accounts[0] });
        }
    });
});