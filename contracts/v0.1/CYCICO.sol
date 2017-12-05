pragma solidity ^0.4.17;

import './CryCashToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract CYCICO {  

  using SafeMath for uint256;

  /***
  * Events
  **/

  event ForeignBuy(address holder, uint cycValue, string txHash);
  event RunIco();
  event PauseIco();
  event FinishIco(address teamFund, address partnersFund, address longTermFund);

  /***
  * State
  **/

  CryCashToken public CYCToken;

  address public team;
  address public tradeRobot;
  modifier teamOnly {require(msg.sender == team); _;}
  modifier robotOnly {require(msg.sender == tradeRobot); _;}

  uint256 public tokensSold = 0;
  uint256 public tokenPrice;

  enum IcoState { Created, Running, Paused, Finished }
  IcoState icoState = IcoState.Created;

  /***
  * Constructor
  ***/

  function CYCICO(address _team, address _tradeRobot, uint256 _tokenPrice) internal {
    CYCToken = new CryCashToken(this);
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
    require(msg.value >= tokenPrice);

    uint256 tokens = msg.value / tokenPrice;

    buy(_investor, tokens);
  }

  /***
  * Priveleged functions
  ***/

  /***
  * @dev his is called by our friendly robot to allow 
  * you to buy CYC for various cryptos.
  ***/
  function foreignBuy(address _investor, uint256 _cycValue, string _txHash)
    external robotOnly
  {
    require(icoState == IcoState.Running);
    require(_cycValue > 0);

    buy(_investor, _cycValue);
    ForeignBuy(_investor, _cycValue, _txHash);
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

    uint256 totalSupply = CYCToken.totalSupply();

    // send funds to team/partners + support long term reserve
    CYCToken.mint(_teamFund, (totalSupply / 100).mul(15)); // 15%
    CYCToken.mint(_partnersFund, (totalSupply / 100).mul(10)); // 10%
    CYCToken.mint(_longTermFund, (totalSupply / 100).mul(15)); // 15%

    // finish mint new tokens
    CYCToken.finishMinting();

    // finish state
    icoState = IcoState.Finished;

    FinishIco(_teamFund, _partnersFund, _longTermFund);
  }


  /***
  * Private functions
  ***/

  function buy(address _investor, uint _cycValue) internal {
    require(icoState == IcoState.Running);

    CYCToken.mint(_investor, _cycValue);
    tokensSold += _cycValue;
  }
}