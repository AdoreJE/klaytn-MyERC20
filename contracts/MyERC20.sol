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

    /**
     * @dev getName is call functon
     * @return token Name
     */
    function getName() public view returns(string memory name) {
        return Name;
    }

    /**
     * @dev getSymbol is call functon
     * @return token symbol
     */
    function getSymbol() public view returns(string memory symbol) {
        return Symbol;
    }

    /**
     * @dev totalSupply is call functon
     * @return total amount of token
     */
    function totalSupply() public view returns(uint) {
        return _TotalSupply[Name];
    }

    /**
     * @dev balanceOf is call functon that returns the amount owned by owner
     * @param account owner's address
     * @return balance of the owner
     */
    function balanceOf(address account) public view returns (uint) {
        return balance[account];
    }

    /**
     * @dev transfer is send functon that moves token from owner to recipient
     * @param caller caller's address
     * @param recipient recipient's address
     * @param amount amount of token
     * @return the success or fail
     */
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

    /**
     * @dev allowance is call functon that returns the amount of token to invoke {transferFrom}
     * @param owner owner's address
     * @param spender spender's address
     * @return the remaining amount of token
     */
    function allowance(address owner, address spender) public view returns (uint){
        uint amount = _allowance[owner][spender];
        return amount;
    }

    /**
     * @dev approve is send functon that sets amount as the allowance of spender over the owner tokens
     * @param owner owner's address
     * @param spender spender's address
     * @param amount amount of token
     */
    function approve(address owner, address spender, uint amount) public{
        require(int(amount) >= 0, "amount must be positive");
        _allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev transferFrom is send functon that moves amount of token from sender(owner) to recipient using allowance of spender
     * @param owner owner's address
     * @param spender spender's address
     * @param recipient recipient's address
     * @param amount amount of token
     */
    function transferFrom(address owner, address spender, address recipient, uint amount) public {
        uint spenderAllowance = _allowance[owner][spender];
        transfer(owner, recipient, amount);
        require(int(spenderAllowance) - int(amount) >= 0, "spenderAllowance not sufficient");
        uint approveAmount = spenderAllowance - amount;
        approve(owner, spender, approveAmount);
    }

    /**
     * @dev increaseAllowance is send functon that increases spender's allowance by owner
     * @param owner owner's address
     * @param spender spender's address
     * @param amount amount of allowance
     */
    function increaseAllowance(address owner, address spender, uint amount) public {
        // check amount is positive
        require(int(amount) > 0, "amount must be positive");

        // get allowance
        uint spenderAllowance = allowance(owner, spender);

        // save allowance
        approve(owner, spender, spenderAllowance + amount);
    }

    /**
     * @dev decreaseAllowance is send functon that decrease spender's allowance by owner
     * @param owner owner's address
     * @param spender spender's address
     * @param amount amount of allowance
     */
    function decreaseAllowance(address owner, address spender, uint amount) public {
        // check amount is positive
        require(int(amount) > 0, "amount must be positive");

        // get allowance
        uint spenderAllowance = allowance(owner, spender);
        require(int(spenderAllowance) - int(amount) >= 0, "spenderAllowance not sufficient");
        // save allowance
        approve(owner, spender, spenderAllowance - amount);
    }

    /**
     * @dev mint is send functon that creates amount tokens and assign them to address, incresing the total supply
     * @param tokenName token name
     * @param recipient recipient's address
     * @param amount amount of token
     */
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

    /**
     * @dev mint is send functon that decreases the total supply
     * @param tokenName token name
     * @param recipient recipient's address
     * @param amount amount of token
     */
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