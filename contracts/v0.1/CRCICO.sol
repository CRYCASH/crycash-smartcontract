pragma solidity ^0.4.17;

import './CryCashToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract CRCICO {  
  using SafeMath for uint256;

  /***
  * Events
  **/

  event ForeignBuy(address holder, uint256 crcValue, string txHash);
  event RunIco();
  event PauseIco();
  event FinishIco(address teamFund, address partnersFund, address longTermFund);

  /***
  * State
  **/

  CryCashToken public CRCToken;

  address public team;
  address public tradeRobot;
  modifier teamOnly {require(msg.sender == team); _;}
  modifier robotOnly {require(msg.sender == tradeRobot); _;}

  uint256 public tokensSold = 0;
  uint256 public ICOTotalSupply = 0;
  uint256 public tokenPrice;

  enum IcoState { Created, Running, Paused, Finished }
  IcoState public icoState = IcoState.Created;

  /***
  * Constructor
  ***/

  function CRCICO(address _team, address _tradeRobot, uint256 _tokenPrice) {
    CRCToken = new CryCashToken(this);
    team = _team;
    tradeRobot = _tradeRobot;
    tokenPrice = _tokenPrice;
  }

  /***
  * Public functions
  ***/

  function() external payable {
    buyFor(msg.sender);
  }


  function buyFor(address _investor) public payable {
    require(icoState == IcoState.Running);
    require(msg.value > 0);

    uint256 tokens = msg.value * tokenPrice;

    buy(_investor, tokens);
  }

  /***
  * Priveleged functions
  ***/

  /***
  * @dev his is called by our friendly robot to allow 
  * you to buy CRC for various cryptos.
  ***/
  function foreignBuy(address _investor, uint256 _crcValue, string _txHash) external robotOnly {
    require(icoState == IcoState.Running);
    require(_crcValue > 0);


    buy(_investor, _crcValue);
    ForeignBuy(_investor, _crcValue, _txHash);
  }

  /***
  * @dev Team can replace tradeRobot in case of malfunction.
  ***/
  function setRobot(address _robot) external teamOnly {
    tradeRobot = _robot;
  }

  function setTokenPrice(uint256 _tokenPrice) external teamOnly {
    tokenPrice = _tokenPrice;
  }

  /***
  * @dev ICO state management: start / pause / finish
  ***/

  function startIco() external teamOnly {
    require(icoState == IcoState.Created || icoState == IcoState.Paused);

    icoState = IcoState.Running;

    RunIco();
  }


  function pauseIco() external teamOnly {
    require(icoState == IcoState.Running);

    icoState = IcoState.Paused;

    PauseIco();
  }


  function finishIco(
    address _teamFund,
    address _partnersFund,
    address _longTermFund
  )
    external teamOnly
  {
    require(icoState == IcoState.Running || icoState == IcoState.Paused);

    uint256 CRCTotalSupply = CRCToken.totalSupply();

    // send funds to team/partners + support long term reserve
    CRCToken.mint(_teamFund, (CRCTotalSupply / 60).mul(15)); // 15%
    CRCToken.mint(_partnersFund, (CRCTotalSupply / 60).mul(10)); // 10%
    CRCToken.mint(_longTermFund, (CRCTotalSupply / 60).mul(15)); // 15%

    ICOTotalSupply += (CRCTotalSupply / 60).mul(15);
    ICOTotalSupply += (CRCTotalSupply / 60).mul(10);
    ICOTotalSupply += (CRCTotalSupply / 60).mul(15);

    // finish mint new tokens
    CRCToken.finishMinting();

    // finish state
    icoState = IcoState.Finished;

    FinishIco(_teamFund, _partnersFund, _longTermFund);
  }


  function withdrawEther(uint _value) external teamOnly {
    team.transfer(_value);
  }

  /***
  * Private functions
  ***/

  function buy(address _investor, uint256 _crcValue) internal {
    require(icoState == IcoState.Running);

    CRCToken.mint(_investor, _crcValue);
    tokensSold += _crcValue;
    ICOTotalSupply += _crcValue;
  }
}