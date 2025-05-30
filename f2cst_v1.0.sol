pragma solidity 0.5.10;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IoRC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function transfer(address payable to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address payable from, address payable to, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract StandardToken is IoRC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }
    
    function transfer(address payable to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function multiTransfer(address[] memory to, uint256[] memory value) public returns (bool) {
        require(to.length > 0 && to.length == value.length, "Invalid params");

        for (uint i = 0; i < to.length; i++) {
            _transfer(msg.sender, to[i], value[i]);
        }

        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address payable from, address payable to, uint256 value) public returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0), "oRC20: transfer to the zero address");

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);

        emit Transfer(from, to, value);
    }

    function _mint(address account, uint256 value) internal {
        require(account != address(0), "oRC20: mint to the zero address");

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);

        emit Transfer(address(0), account, value);
    }
    
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "oRC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);

        emit Transfer(account, address(0), value);
    }
    
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "oRC20: approve from the zero address");
        require(spender != address(0), "oRC20: approve to the zero address");

        _allowed[owner][spender] = value;

        emit Approval(owner, spender, value);
    }
    
    function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
    }
}

contract MintableToken is StandardToken, Ownable {
    bool public mintingFinished = false;

    event MintFinished(address account);

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    function finishMinting() onlyOwner canMint public returns (bool) {
        mintingFinished = true;
        emit MintFinished(msg.sender);
        return true;
    }

    function mint(address to, uint256 value) public canMint onlyOwner returns (bool) {
        _mint(to, value);
        return true;
    }
}

contract CappedToken is MintableToken {
    uint256 private _cap;

    constructor(uint256 cap) public {
        require(cap > 0, "oRC20Capped: cap is 0");
        _cap = cap;
    }

    function cap() public view returns (uint256) {
        return _cap;
    }

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap, "oRC20Capped: cap exceeded");
        super._mint(account, value);
    }
}

contract BurnableToken is StandardToken {
    function burn(uint256 value) public {
        _burn(msg.sender, value);
    }

    function burnFrom(address from, uint256 value) public {
        _burnFrom(from, value);
    }
}

contract Withdrawable is Ownable {
    event WithdrawOrgon(address indexed to, uint value);

    function withdrawOrgon(address payable _to, uint _value) onlyOwner public {
        require(_to != address(0));
        require(address(this).balance >= _value);

        _to.transfer(_value);

        emit WithdrawOrgon(_to, _value);
    }

    function withdrawTokensTransfer(IoRC20 _token, address payable _to, uint256 _value) onlyOwner public {
        require(_token.transfer(_to, _value));
    }

    function withdrawTokensTransferFrom(IoRC20 _token, address payable _from, address payable _to, uint256 _value) onlyOwner public {
        require(_token.transferFrom(_from, _to, _value));
    }

    function withdrawTokensApprove(IoRC20 _token, address _spender, uint256 _value) onlyOwner public {
        require(_token.approve(_spender, _value));
    }
}

contract Pausable is Ownable {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor() internal {
        _paused = false;
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function pause() public onlyOwner whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

contract Manageable is Ownable {
    address[] public managers;

    event ManagerAdded(address indexed manager);
    event ManagerRemoved(address indexed manager);

    modifier onlyManager() {
        require(isManager(msg.sender));
        _;
    }

    function countManagers() view public returns (uint) {
        return managers.length;
    }

    function getManagers() view public returns (address[] memory) {
        return managers;
    }

    function isManager(address _manager) view public returns (bool) {
        for (uint i = 0; i < managers.length; i++) {
            if (managers[i] == _manager) {
                return true;
            }
        }
        return false;
    }

    function addManager(address _manager) onlyOwner public {
        require(_manager != address(0));
        require(!isManager(_manager));
        managers.push(_manager);
        emit ManagerAdded(_manager);
    }

    function removeManager(address _manager) onlyOwner public {
        uint index = managers.length;
        for (uint i = 0; i < managers.length; i++) {
            if (managers[i] == _manager) {
                index = i;
            }
        }

        if (index < managers.length) {
            for (uint i = index; i < managers.length - 1; i++) {
                managers[i] = managers[i + 1];
            }
            managers.length--;
            emit ManagerRemoved(_manager);
        }
    }
}

contract RewardToken is StandardToken, Ownable {
    struct Payment {
        uint time;
        uint amount;
    }

    Payment[] public repayments;
    mapping(address => Payment[]) public rewards;

    event Repayment(address indexed from, uint256 amount);
    event Reward(address indexed to, uint256 amount);

    function repayment(uint amount) onlyOwner public {

        repayments.push(Payment({time : block.timestamp, amount : amount}));

        emit Repayment(msg.sender, amount);
    }

    function _reward(address payable _to) private returns(bool) {
        if(rewards[_to].length < repayments.length) {
            uint sum = 0;
            for(uint i = rewards[_to].length; i < repayments.length; i++) {
                uint amount = balanceOf(_to) > 0 ? (repayments[i].amount * balanceOf(_to) / totalSupply()) : 0;
                rewards[_to].push(Payment({time : block.timestamp, amount : amount}));
                sum += amount;
            }

            if(sum > 0) {
                _to.transfer(sum);
                emit Reward(_to, sum);
            }

            return true;
        }
        return false;
    }

    function reward() public returns(bool) {
        return _reward(msg.sender);
    }

    function transfer(address payable _to, uint256 _value) public returns(bool) {
        _reward(msg.sender);
        _reward(_to);
        return super.transfer(_to, _value);
    }

    function transferFrom(address payable _from, address payable _to, uint256 _value) public returns(bool) {
        _reward(_from);
        _reward(_to);
        return super.transferFrom(_from, _to, _value);
    }

    function availableRewards(address _to) public view returns(uint sum) {
        for(uint i = rewards[_to].length; i < repayments.length; i++) {
            sum += balanceOf(_to) > 0 ? (repayments[i].amount * balanceOf(_to) / totalSupply()) : 0;
        }
    }
}

contract Token is RewardToken, CappedToken, BurnableToken, Withdrawable {
    constructor() CappedToken(100000 * 1e4) StandardToken("F2CST", "F2CST", 4) public {
        
    }
}