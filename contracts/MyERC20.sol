pragma solidity ^0.5.1;

contract MyERC20 {
    string Name;
    string Symbol;
    address Owner;
    // uint TotalSupply;

    mapping (address=>uint) balance;
    mapping (address=>mapping(address=>uint)) _allowance;
    mapping (string=>uint) _TotalSupply;
    
    event Transfer(
        address Caller,
        address Recipient,
        uint Amount
    );
    event Approval(
        address Owner,
        address Spender,
        uint Allowance
    );


    constructor (string memory _name, string memory _symbol, uint _totalSupply) public {
        Name = _name;
        Symbol = _symbol;
        _TotalSupply[Name] = _totalSupply;
        // TotalSupply = _totalSupply;
        Owner = msg.sender;
        balance[Owner] = balance[Owner] + _TotalSupply[Name];
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
        return _TotalSupply[Name];
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
        // false인 경우에도 가스가 소모됨. 해결방안은?   => require?
        require(int(callerAmount) - int(amount) >= 0, "callerAmount result must be positive");

        //calculate amount
        balance[Owner] = callerAmount - amount;
        balance[recipient] = recipientAmount + amount;

        // emit Transfer event
        emit Transfer(caller, recipient, amount);
        return true;
    }

    // allowance is call function
    // params - owner's address, spender's address
    // returns the remaining amount of token to invoke {transferFrom}
    function allowance(address owner, address spender) public view returns (uint){
        uint amount = _allowance[owner][spender];
        return amount;
    }

    // approve is send function that sets amount as the allowance
    // of spender over the owner tokens
    // params - owner's address, spender's address, amount of token
    function approve(address owner, address spender, uint amount) public{
        require(int(amount) >= 0, "amount must be positive");
        _allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    // transferFrom is send function that moves amount of token from sender (owner) to recipient
    // using allowance of spender
    // params - owner's address, spender's address, recipient's address, amount of token
    function transferFrom(address owner, address spender, address recipient, uint amount) public {
        uint spenderAllowance = _allowance[owner][spender];
        transfer(owner, recipient, amount);
        require(int(spenderAllowance) - int(amount) >= 0, "spenderAllowance not sufficient");
        uint approveAmount = spenderAllowance - amount;
        approve(owner, spender, approveAmount);
    }

    // increaseAllowance is send function that increases spender's allowance by owner
    // params - owner's address, spender's address, amount of allowance
    function increaseAllowance(address owner, address spender, uint amount) public {
        // check amount is positive
        require(int(amount) > 0, "amount must be positive");

        // get allowance
        uint spenderAllowance = allowance(owner, spender);

        // save allowance
        approve(owner, spender, spenderAllowance + amount);
    }

    // decreaseAllowance is send function that decreases spender's allowance by owner
    // params - owner's address, spender's address, amount of allowance
    function decreaseAllowance(address owner, address spender, uint amount) public {
        // check amount is positive
        require(int(amount) > 0, "amount must be positive");

        // get allowance
        uint spenderAllowance = allowance(owner, spender);
        require(int(spenderAllowance) - int(amount) >= 0, "spenderAllowance not sufficient");
        // save allowance
        approve(owner, spender, spenderAllowance - amount);
    }

    // mint is send function that creates amount tokens and assign them to address, increasing the total supply
    // params - tokenName, recipient's address, amount
    function mint(string memory tokenName, address recipient, uint amount) public {
        // amount must be positive
        require(int(amount) > 0, "amount must  be positive");

        // increase TotalSupply
        _TotalSupply[tokenName] = _TotalSupply[tokenName] + amount;

        // increase owner balance
        uint curBalance = balanceOf(recipient);
        balance[recipient] = curBalance + amount;

        // emit TransferEvent
        emit Transfer(recipient, recipient, amount);
    }

    // burn is send function that decreases the total supply
    // params - tokenName, recipient's address, amount
    function burn(string memory tokenName, address recipient, uint amount) public {
        // amount must be positive
        require(int(amount) > 0, "amount must  be positive");
        require(int(_TotalSupply[tokenName]) - int(amount) >= 0, "totalSupply not sufficient");
        
        // decrease TotalSupply
        _TotalSupply[tokenName] = _TotalSupply[tokenName] - amount;

        // decrease owner balance
        uint curBalance = balanceOf(recipient);
        balance[recipient] = curBalance - amount;
    }
}