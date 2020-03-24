const MyERC20 = artifacts.require("./MyERC20.sol");

contract('MyERC20', function([deployer, user1, user2]){
    let erc20;
    beforeEach(async() => {
        erc20 = await MyERC20.new("ethereum", "eth", 1000)
    })

    describe('Basic INFO', function() {
        it('getName should return token name', async() => {
            let name = await erc20.getName();
            assert.equal(name, "ethereum")
        })
        it('getSymbol should return token symbol', async() => {
            let symbol = await erc20.getSymbol();
            assert.equal(symbol, "eth")
        })
        it('totalSupply should return total amount of token', async() => {
            let totalSupply = await erc20.totalSupply();
            assert.equal(totalSupply, 1000)
        })
    })

    it('balanceOf should return token amount owned by address', async() =>{
        let amount = await erc20.balanceOf(deployer);
        assert.equal(amount, 1000);
    })

    describe.only('Transfer', function() {
        it('transfer test', async() => {
            let result = await erc20.transfer(deployer, user1, 3);
            let callerAmount = await erc20.balanceOf(deployer);
            let recipientAmount = await erc20.balanceOf(user1);
            assert.equal(callerAmount, 997);
            assert.equal(recipientAmount, 3);
            console.log(result.logs[0].event)
        })
    })
   
})