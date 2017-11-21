pragma solidity ^0.4.17;

import './CryCashToken.sol';

contract CYCICO {  
  /***
  * Events
  **/

  event ForeignBuy(address holder, uint cycValue, string txHash);
  event RunIco();
  event PauseIco();
  event FinishIco(address teamFund, address ecosystemFund, address bountyFund);


  /***
  * State
  **/

  CryCashToken public CYCToken;

  address public team;
  address public tradeRobot;
  modifier teamOnly {require(msg.sender == team); _;}
  modifier robotOnly {require(msg.sender == tradeRobot); _;}

  uint tokensSold = 0;

  enum IcoState { Created, Running, Paused, Finished }
  IcoState icoState = IcoState.Created;

  /***
  * Constructor
  ***/

  function ICO(address _team, address _tradeRobot) {
    CYCToken = new CryCashToken(this);
    team = _team;
    tradeRobot = _tradeRobot;
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
    buy(_investor, msg.value);
  }


  /***
  * Priveleged functions
  ***/

  /***
  * @dev his is called by our friendly robot to allow 
  * you to buy SNM for various cryptos.
  ***/
  function foreignBuy(address _investor, uint _cycValue, string _txHash)
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
    address _ecosystemFund,
    address _bountyFund
  )
    external teamOnly
  {
    require(icoState == IcoState.Running || icoState == IcoState.Paused);

    uint alreadyMinted = CYCToken.totalSupply();
    uint totalAmount = alreadyMinted * 1110 / 889;

    CYCToken.mint(_teamFund, 10 * totalAmount / 111);
    CYCToken.mint(_ecosystemFund, totalAmount / 10);
    CYCToken.mint(_bountyFund, totalAmount / 111);

    CYCToken.finishMinting();

    icoState = IcoState.Finished;
    FinishIco(_teamFund, _ecosystemFund, _bountyFund);
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