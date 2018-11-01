pragma solidity ^0.4.18;
 
/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}
 
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}
 
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
 
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }
 
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a); 
    return a - b; 
  } 
  
  function add(uint256 a, uint256 b) internal pure returns (uint256) { 
    uint256 c = a + b; assert(c >= a);
    return c;
  }
 
}
 
/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;
 
  mapping(address => uint256) balances;
 
  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]); 
    // SafeMath.sub will throw if there is not enough balance. 
    balances[msg.sender] = balances[msg.sender].sub(_value); 
    balances[_to] = balances[_to].add(_value); 
    emit Transfer(msg.sender, _to, _value); 
    return true; 
  } 
 
  /** 
   * @dev Gets the balance of the specified address. 
   * @param _owner The address to query the the balance of. 
   * @return An uint256 representing the amount owned by the passed address. 
   */ 
  function balanceOf(address _owner) public constant returns (uint256 balance) { 
    return balances[_owner]; 
  } 
} 
 
/** 
 * @title Standard ERC20 token 
 * 
 * @dev Implementation of the basic standard token. 
 * @dev https://github.com/ethereum/EIPs/issues/20 
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
 */ 
contract StandardToken is ERC20, BasicToken {
 
  mapping (address => mapping (address => uint256)) internal allowed;
 
  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]); 
    balances[_from] = balances[_from].sub(_value); 
    balances[_to] = balances[_to].add(_value); 
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
    emit Transfer(_from, _to, _value); 
    return true; 
  } 
 
 /** 
  * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
  * 
  * Beware that changing an allowance with this method brings the risk that someone may use both the old 
  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
  * @param _spender The address which will spend the funds. 
  * @param _value The amount of tokens to be spent. 
  */ 
  function approve(address _spender, uint256 _value) public returns (bool) { 
    allowed[msg.sender][_spender] = _value; 
    emit Approval(msg.sender, _spender, _value); 
    return true; 
  }
 
 /** 
  * @dev Function to check the amount of tokens that an owner allowed to a spender. 
  * @param _owner address The address which owns the funds. 
  * @param _spender address The address which will spend the funds. 
  * @return A uint256 specifying the amount of tokens still available for the spender. 
  */ 
  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { 
    return allowed[_owner][_spender]; 
  } 
 
 /** 
  * approve should be called when allowed[_spender] == 0. To increment 
  * allowed value is better to use this function to avoid 2 calls (and wait until 
  * the first transaction is mined) * From MonolithDAO Token.sol 
  */ 
  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
    return true; 
  }
 
  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
    uint oldValue = allowed[msg.sender][_spender]; 
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
 
  function () public payable {
    revert();
  }
 
}
 
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;
 
 
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
 
  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }
 
 
  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
 
 
  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
 
}
 
/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
 
contract MintableToken is StandardToken, Ownable {
    
  event Mint(address indexed to, uint256 amount);
  
  event MintFinished();
 
  bool public mintingFinished = false;
 
  address public saleAgent;
 
  function setSaleAgent(address newSaleAgnet) public {
    require(msg.sender == saleAgent || msg.sender == owner);
    saleAgent = newSaleAgnet;
  }
 
  function mint(address _to, uint256 _amount) public returns (bool) {
    require(msg.sender == saleAgent && !mintingFinished);
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    return true;
  }
 
  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() public returns (bool) {
    require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
 
  
}
 
contract SberRuble is MintableToken {
    
    string public constant name = "Sberbank Ruble";
    
    string public constant symbol = "SBR";
    
    uint32 public constant decimals = 2;
    
    //Проценты по кредитам
    uint private loanInterest = 10;
    
    //Проценты по депозитам
    uint private depositInterest = 5;
    
    //Коэффициент увеличения кредитного рейтинга клиента
    uint32 private rateKoef = 10;
    //Зададим базовый кредитный рейтинг
    uint32 private baseWhite = 1000;
    
    uint private lastDepoPayTime = div(now, 60);
    
    //Счета (и кредитные и депозитные) будем вести в таком виде
    struct account {
        uint endTime;
        uint bal;
    }
    
    //По клиенту будем вести массив кредитов, признак вхождения в блэклист, кредитный рейтинг
    struct clientInfo {
        account[] loans;
        bool black;
        int white;
    }
    
    //Кому и сколько вернуть за депозит
    struct depoOwner {
        address client;
        uint bal;
    }
    
    //Заводим мэппинг адреса и информации по клиенту
    mapping(address => clientInfo) info;
    
    //Заводим мэппинг для отслеживания денежного потока, в нем ведем предполагаемое изменение потока
    //Это нужно будет для определения достаточности средств для выдачи кредита
    //Ключ - минута действия, значение - предполагаемая сумма прихода или расхода
    //Например, при открытии депозита в moneyFlow по ключу "дата закрытия депозита" уменьшится значение на сумму выплаты депозита
    mapping(uint => uint) moneyFlow;
    
    //Мэпинг для гашени кредитов ключ - срок гашения, содержимое - кридиты к гашению
    mapping(uint => depoOwner[]) depoPay;
    
    //Вспомогательные переменные
    account[] accs;
    account acc;
    depoOwner dept;
    depoOwner[] depts;
    
    //Открытие депозита
    function openDeposit(uint _lifeTime, uint _amount) public returns (string) {
        //Высчитаем сразу дату закрытия депозита
        acc.endTime = add(div(now, 60),_lifeTime));
        acc.bal = _amount;
        
        //Проверка и списание на просроченный кредитов
        //Проверяем наличие просроченных кредитов у клиента. 
        //Бежим циклом по кредитам клиента. Если есть просроченный, то:
        
        for(uint index=0; index<info[msg.sender].loans.length; index++){
            //проверяем просрочку
            if(info[msg.sender].loans[index].endTime < now)
            {
                //заносим клиента в черный список
                info[msg.sender].black = true;
                //гасим, полностью или частично, кредит за счет средств депозита
                if(sub(acc.bal,info[msg.sender].loans[index].bal)) >= 0
                {
                    if(transfer(owner, info[msg.sender].loans[index].bal){
                       acc.bal = sub(acc.bal,info[msg.sender].loans[index].bal)
                       info[msg.sender].loans[index].delete;
                    }
                }
                //если задолженность по кредиту больше суммы открытия депозита, то гасим кредит частично на всю доступную сумму
                else if sub(acc.bal,info[msg.sender].loans[index].bal) < 0 && acc.bal > 0
                {
                     if(transfer(owner, acc.bal) {
                       info[msg.sender].loans[index].bal = sub(info[msg.sender].loans[index].bal,acc.bal);
                       //денег на депозит не осталось, выходим из функции
                       return "Депозит не открыт. Деньги направлены на погашение задолженности по просроченным кредитам";
                    }
                }
            };

        };
        if (acc.bal < _amount) {
            
        }
        
        //Если остались деньги на открытие депозита, то открываем его
        if (acc.bal > 0 && transfer(owner,acc.bal) {
            //Открываем депозит на остаток средств
            emit OpenDeposit(msg.sender,acc.endTime,acc.bal);        
            
            //Записываем данные депозита в дату выплаты
            //Тут нас интересует сумма выплаты уже с процентами, посчитаем и запишем ее
            dept.bal = div(mul(acc.bal,100+depositInterest),100);
            dept.client = msg.sender;
            depts = depoPay[acc.endTime];
            depts.push(dept);
            depoPay[acc.endTime] = depts;
 
            //Запишем, что в дату выплаты депозита наш баланс уменьшится на сумму депозита
            moneyFlow[acc.endTime] = sub(moneyFlow[acc.endTime],acc.bal);
        }
    }   
    
    //Выдача кредита
    function getLoan(uint _lifeTime, uint _amount) public returns (string) {
        if (_amount <= 0) return "Введена неверная сумма";
        //Проверяем что клиент не в блэклисте если есть - отказываем
        if (info[msg.sender].black) return "Вы находитесь в черном списке, в выдаче отказано!";
        acc.bal = 0; //чтобы не заводить новую переменную используем что есть для проверки достаточности кредитного рейтинга
        acc.endTime = div(now, 60);
        //Проверяем, что выдача в пределах кредитного рейтига, если нет - отказываем
        //Высчитаем текущий рейтинг с учетом ранее выданных кредитов
        //Сразу проверим, что нет просрочки, если есть - добавим клиента в черный список и прекратим выдачу
        for(uint index=0; index<info[msg.sender].loans.length; index++){
            //проверяем просрочку
            if(info[msg.sender].loans[index].endTime < now)
            {
                info[msg.sender].black = true;
                return "Есть просроченные кредиты, в выдаче отказано!";
            };
            
            //по всем кредитам рассчитаем рейтинг как остаток срока * на сумму
            acc.bal += mul((info[msg.sender].loans[index].endTime-acc.endTime+1),info[msg.sender].loans[index].bal);
        };
        //если недостаточно кредитного рейтинга выходим
        if (add(mul(_lifeTime,_amount),acc.bal) > sum(info[msg.sender].white, baseWhite) return "Кредитного рейтинга недостаточно";
        
        acc.bal = 0; //переиспользуем эту переменную для определения достаточности капитала
        //Проверим, что у нас хватает капитала для исполнения обязательств в каждую минуту с открытия до погашения кредита
        for (int time=acc.endTime; time <= add(acc.endTime,_lifeTime);time++){
            acc.bal = add(acc.bal,moneyFlow[time]);
            //Если хоть в какой-то момент баланс ниже суммы кредита, то отказываем в выдаче
            if (_amount > balanceOf(owner) + acc.bal) return "В банке недостаточно ликвидности, в выдаче кредита отказано";
        }
        acc.endTime = add(acc.endTime, _lifeTime); //переопределим переменную по назначению
        acc.bal = div(mul(_amount, 100 + loanInterest), 100); //рассчитаем сумму к погашению (с процентами)
        info[msg.sender].loans.push(acc);
        
        return "Кредит успешно выдан!";
    }
    
    //Автоматическая выплата по депозитам. Вызывается оракулом
    function closeDepos() public {
        acc.bal = 0; //используем под флаг дефолта
        acc.endTime = div(now, 60); // переиспользуем для храненияя текущего времени
        //Проверим и погасим все кредиты с последней даты гашения по текущее время
        for (uint time=getlastDepoPayTime(); time <= acc.endTime;time++){
            for(uint index=0; index<depoPay[time].length; index++){
                if(depoPay[time][index].bal > 0){
                   //Если денег хватает - выплачиваем депозит
                   if(sub(balanceOf(owner),depoPay[time][index].bal) > 0)
                   {
                       //если надо гасить
                       if(depoPay[time][index].bal > 0)
                       {
                          transfer(depoPay[time][index].client, depoPay[time][index].bal);
                          depoPay[time][index].bal = 0;
                       };
                   }
                   //Дефолт, попробуем погасить кредить следующей итерацией, вдруг кредиты вернут...
                   else
                   {
                       acc.bal =-1;
                   };
                };
            };
        };
        if(acc.bal == 0){
            setlastDepoPayTime(acc.endTime);
        };
    }
    
    //Гашение кредита (вызывается клиентом)
    function payCredit(uint _endTime, uint _bal) public returns (string) {
        if (_bal <= 0) return "Некорректная сумма!";
        acc.bal = _bal;
        //Бежим по всем кредитам, нужные (совпадающие по дате гашения) гасим
        for(uint index=0; index<info[msg.sender].loans.length; index++){
            if(info[msg.sender].loans[index].endTime = _endTime)
            {
                if(sub(acc.bal,info[msg.sender].loans[index].bal)) >= 0
                {
                    if(transfer(owner, info[msg.sender].loans[index].bal){
                       acc.bal = sub(acc.bal,info[msg.sender].loans[index].bal)
                       //Увеличим кредитный рейтинг клиенту
                       info[msg.sender].white = div(mul(info[msg.sender].white, 100 + rateKoef),100);
                       info[msg.sender].loans[index].delete;
                    }
                }
                else if sub(acc.bal,info[msg.sender].loans[index].bal) < 0 && acc.bal > 0
                {
                     if(transfer(owner, acc.bal) {
                       info[msg.sender].loans[index].bal = sub(info[msg.sender].loans[index].bal,acc.bal);
                       break;
                    }
                }
            };
        };
        if acc.bal > 0 {
            return "При гашении возникла переплата, она не была списана с Вашего счета";
        }
        else if acc.bal = 0 {
            return "Гашение кредита выполнено";
        }
    }
    
    //Получить список кредитов
    function getLoansList() public returns (accs) {
        return info[sender.msg].loans;
    }

    function getlastDepoPayTime() public returns (uint) {
        return lastDepoPayTime;
    }

    function setlastDepoPayTime(uint _time) onlyOwner public returns (bool){
        lastDepoPayTime = _time;
    }

    function getLoanInterest() onlyOwner public returns (uint){
        return loanInterest;
    }
    
    function setLoanInterest(uint _interest) onlyOwner public returns (bool){
        loanInterest = _interest;
    }
    
    function getDepositInterest() onlyOwner public returns (uint){
        return depositInterest;
    }
    
    function setDepositInterest(uint _interest) onlyOwner public returns (bool){
        depositInterest = _interest;
    }
    
    function getRateKoef() onlyOwner public returns (uint){
        return rateKoef;
    }
    
    function setDepositInterest(uint _rateKoef) onlyOwner public returns (bool){
        rateKoef = _rateKoef;
    }
    
     function getBaseWhite() onlyOwner public returns (uint){
        return baseWhite;
    }
    
    function setBaseWhite(uint _baseWhite) onlyOwner public returns (bool){
        baseWhite = _baseWhite;
    }
    
}
