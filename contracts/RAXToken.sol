pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import 'zeppelin-solidity/contracts/ownership/HasNoTokens.sol';
import 'zeppelin-solidity/contracts/ownership/HasNoEther.sol';
import 'zeppelin-solidity/contracts/ownership/Contactable.sol';
import './DistributableToken.sol';


/*
 * RAXToken is a ERC20 token that
 *  - caps total number at 100 million tokens
 *  - can pause and unpause token transfer (and authorization) actions
 *  - mints new tokens when purchased (rather than transferring tokens pre-granted to a holding account)
 *  - attempts to reject ERC20 token transfers to itself and allows token transfer out
 *  - attempts to reject ether sent and allows any ether held to be transferred out
 */
contract RAXToken is Contactable, HasNoTokens, HasNoEther, PausableToken, DistributableToken {
    string public constant name = "RAXToken";
    string public constant symbol = "RAX";

    uint8 public constant decimals = 18;
    uint256 public constant ONE_TOKENS = (10 ** uint256(decimals));
    uint256 public constant BILLION_TOKENS = (10**9) * ONE_TOKENS;
    uint256 public constant TOTAL_TOKENS = 10 * BILLION_TOKENS;

    function RAXToken(RegisteredUsers _regUsers)
    Contactable()
    HasNoTokens()
    HasNoEther()
    PausableToken()
    TokenHolders()
    DistributableToken(_regUsers, 1)
    {
        contactInformation = 'https://token.samuraix.io/';
    }

    // cap minting so that totalSupply <= TOTAL_TOKENS
    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
        require(totalSupply_.add(_amount) <= TOTAL_TOKENS);
        return super.mint(_to, _amount);
    }

    /*
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) onlyOwner public {
        // do not allow self ownership
        require(newOwner != address(this));
        super.transferOwnership(newOwner);
    }

    function calculateProfit(uint256 _totalProfit, address _holder) public view returns(uint256) {
      require(_totalProfit > 0);
      require(isHolder(_holder));

      uint256 _balance = balanceOf(_holder);
      uint256 _profit = (_balance.mul(_totalProfit)).div(TOTAL_TOKENS);
      return _profit;
    }
}
