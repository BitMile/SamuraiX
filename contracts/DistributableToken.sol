pragma solidity ^0.4.20;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import './TokenHolders.sol';
import './RegisteredUsers.sol';


contract DistributableToken is TokenHolders, MintableToken {
  uint256 id;
  RegisteredUsers public regUsers;

  function DistributableToken(RegisteredUsers _regUsers, uint256 _id) {
    id = _id;
    regUsers = _regUsers;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(regUsers.isUserRegistered(_to));

    if (!isHolder(_to)) {
      addHolder(_to);
    }

    super.transfer(_to, _value);
  }

  function calculateProfit(uint256 _totalProfit, address _holder) public view returns(uint256);

  function getID() public view returns(uint256){
    return id;
  }
}
