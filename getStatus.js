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
// erc20.methods.getName().call().then(function(result){
//     console.log("token name: " + result)
// })

// erc20.methods.getSymbol().call().then(function(result){
//     console.log("token symbol: " + result)
// })

// erc20.methods.totalSupply().call().then(function(result){
//     console.log("totalSupply: " + result)
// })

erc20.methods.balanceOf(account1).call().then(function(result){
    console.log(account1.substr(0,4) + " account1's balanceOf: " + result)
    console.log("===============================")
})

erc20.methods.balanceOf(account2).call().then(function(result){
    console.log(account2.substr(0,4) + " account2's balanceOf: " + result)
    console.log("===============================")
})
