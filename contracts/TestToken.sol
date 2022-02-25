//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//use chainlink for historical price by round id
contract USDT is Ownable, ERC20PresetMinterPauser {

    constructor(string memory name, string memory symbol) ERC20PresetMinterPauser(name, symbol)  {
    }

}
