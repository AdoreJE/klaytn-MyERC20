// test-claytn.js
const Caver = require('caver-js');
const caver = new Caver('http://127.0.0.1:8551');
// enter your smart contract address
const constant = require('./constant.js')

// caver.klay.getCode(contractAddress).then(console.log);
// add lines
const MyERC20 = require('../build/contracts/MyERC20.json')
// enter your smart contract address 
const contractAddress = MyERC20.networks["1001"].address
const erc20 = new caver.klay.Contract(MyERC20.abi, contractAddress);

erc20.events.Transfer({fromBlock:0, toBlock:'latest'}, function(err, event){
    console.log(event);
}).on('data', function(event){
    console.log(event);
}).on('changed', function(event){
    console.log(event);
}).on('error', console.error);
