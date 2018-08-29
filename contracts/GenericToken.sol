pragma solidity ^0.4.23;


library SafeMath {
  
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }
}


contract IntellosToken  {
  using SafeMath for uint256;

  string public constant name = "<NAME>"; 
  string public constant symbol = "<SYMBOL>"; 
  uint8 public constant decimals = 18;  //replace with definition
  uint8 public constant tokenPerWei = 1; //replace with definiton
  uint256 public constant maxSupply = 10**9 *10**18;  //replace with definition


  constructor() public {
     //mint(<Tokenholder1,<amount1 in wei>);
     //mint(<Tokenholder2,<amount2 in wei>);
     //....     
     owner = msg.sender;
  }

  //Owner Management

  address public owner;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  //Minting


  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;
  

  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  modifier notMinting() {
    require(mintingFinished);
    _;
  }

  function() canMint public payable {
      mint(msg.sender,msg.value.mul(tokenPerWei));
  }


  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    assert(totalSupply_<maxSupply); 
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  function finishMinting() onlyOwner canMint public returns (bool) {
    require(totalSupply_<maxSupply); 
    mintingFinished = true;
    msg.sender.transfer(address(this).balance);
    emit MintFinished();
    return true;
  }

  //Erc20 Management

  event Transfer(address indexed from, address indexed to, uint256 value);
  mapping(address => uint256) balances;


  uint256 totalSupply_;

  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }


  function transfer(address _to, uint256 _value) notMinting public returns (bool) {
    require(_to != address(0)); 
    require(_value <= balances[msg.sender]);

    uint codeLength;
    assembly {
      codeLength := extcodesize(_to)
    }
    require(codeLength<=0); 

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);
    return true; 
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }


  //Standart Token Management
  event Approval(address indexed owner, address indexed spender, uint256 value);

  mapping (address => mapping (address => uint256)) internal allowed;

  function transferFrom(address _from, address _to, uint256 _value) notMinting public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    uint codeLength;
    assembly {
      codeLength := extcodesize(_to)
    }
    require(codeLength<=0); 
    

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);
    return true;
  }


  function approve(address _spender, uint256 _value) public returns (bool) {

    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

 
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}