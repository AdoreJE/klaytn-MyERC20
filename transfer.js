// test-claytn.js
const Caver = require('caver-js');
const caver = new Caver('http://127.0.0.1:8551');
// enter your smart contract address
const constant = require('./constant.js')


const account1 = constant.account1
const account2 = constant.account2
// caver.klay.getCode(contractAddress).then(console.log);
// add lines
const MyERC20 = require('../build/contracts/MyERC20.json')
// enter your smart contract address 
const contractAddress = MyERC20.networks["1001"].address
const erc20 = new caver.klay.Contract(MyERC20.abi, contractAddress);

erc20.methods.transfer(account2, 1 ).send({from:account1, gas:20000000},function(result){
    console.log("transfer result: " + result)
    console.log("===============================")
})

erc20.getPastEvents('Transfer',{fromBlock:0, toBlock:'latest'}, function(err, event){
    console.log(event);
})