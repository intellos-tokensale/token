
pragma solidity ^0.4.18;


import "./token/ERC223/TokenVesting.sol";


/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract TeamVesting is TokenVesting {

  constructor(uint256 _startDate)
    TokenVesting(0xf51E1b1000aF9f7fB1CE1124f1dEBAB4C89AAE1D,_startDate, 3*30*24*60*60, 356*6*24*60*60,true)
   public {
  }

}
