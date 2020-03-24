pragma solidity ^0.5.1;

contract MyERC20 {
    string Name;
    string Symbol;
    address Owner;
    uint TotalSupply;

    mapping (address=>uint) balance;

    event Transfer(
        address Caller,
        address Recipient,
        uint Amount
    );


    constructor (string memory _name, string memory _symbol, uint _totalSupply) public {
        Name = _name;
        Symbol = _symbol;
        TotalSupply = _totalSupply;
        Owner = msg.sender;
        balance[Owner] = balance[Owner] + TotalSupply;
    }

    // getName is call function
    // returns token name
    function getName() public view returns(string memory name) {
        return Name;
    }

    // getSymbol is call function
    // returns token symbol
    function getSymbol() public view returns(string memory symbol) {
        return Symbol;
    }

    // totalSupply is call
    // returns total amount of token
    function totalSupply() public view returns(uint) {
        return TotalSupply;
    }

    // balanceOf is call function
    // params - owner's address
    // returns balance of the owner
    function balanceOf(address account) public view returns (uint) {
        return balance[account];
    }

    // transfer is send function that moves token from owner to recipient
    // params - caller address, recipient address, amount of token
    // returns the success or fail
    function transfer(address caller, address recipient, uint amount) public returns(bool) {
        require(caller != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

         // get caller amount
        uint callerAmount = balance[Owner];

        // get recipient amount
        uint recipientAmount = balance[recipient];

        // check callerAmount result is positive
        // false인 경우에도 가스가 소모됨. 해결방안은?
        if (int(callerAmount) - int(amount) < 0) {
            return false;
        }

        //calculate amount
        balance[Owner] = callerAmount - amount;
        balance[recipient] = recipientAmount + amount;

        // emit Transfer event
        emit Transfer(caller, recipient, amount);
        return true;
    }
}