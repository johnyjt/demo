//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//use chainlink for historical price by round id
contract Game is Ownable {

    using SafeERC20 for IERC20;

    AggregatorV3Interface internal priceFeed;
    IERC20 internal usdt;
    enum GameStatus{PROGRESS, END, FAIL}
    enum GamePriceResult{MAX, MIN}
    GameInfo[] private list;


    struct GameInfo {
        GameStatus status;//
        GamePriceResult user1Predict;
        uint128 endTime;// end time
        uint256 targetPrice; // target price
        uint256 amount; // usdt amount
        address user1;
        address user2;
    }
    constructor()  {}

    function config(address _chainLink, address _usdt) public onlyOwner {
        priceFeed = AggregatorV3Interface(_chainLink);
        usdt = IERC20(_usdt);
    }


    function start(uint256 _targetPrice, uint256 _amount, uint128 _endTime, bool isMax) public {
        if (_endTime == 0) {
            _endTime = uint128(block.timestamp + 120);
        }
        usdt.safeTransferFrom(msg.sender, address(this), _amount);
        list.push(GameInfo({
        status : GameStatus.PROGRESS,
        user1Predict : isMax ? GamePriceResult.MAX : GamePriceResult.MIN,
        endTime : _endTime,
        targetPrice : _targetPrice,
        amount : _amount,
        user1 : msg.sender,
        user2 : address(0)
        }));
    }

    function join(uint256 gameId) public {
        GameInfo storage info = list[gameId];
        require(info.status == GameStatus.PROGRESS, 'game is in progress!');
        require(info.user2 == address(0), 'can not join');
        usdt.safeTransferFrom(msg.sender, address(this), info.amount);
        info.user2 = msg.sender;
    }

    function end(uint256 gameId, uint80 roundId) public {

        GameInfo storage info = list[gameId];
        require(info.status == GameStatus.PROGRESS, 'game status error!');
        require(info.user2 != address(0), 'game is in progress ');

        (
        uint80 id,
        int price,
        uint startedAt,
        uint timeStamp,
        uint80 answeredInRound
        ) = priceFeed.getRoundData(roundId);

        (
        uint80 id1,
        int price2,
        uint startedAt1,
        uint timeStamp1,
        uint80 answeredInRound1
        ) = priceFeed.getRoundData(roundId-1);

        require(timeStamp1 <= info.endTime && timeStamp >= info.endTime, 'roundId error');
        uint256 price1 = uint256(price);
        if (price1 > info.targetPrice && info.user1Predict == GamePriceResult.MAX ||
            price1 < info.targetPrice && info.user1Predict == GamePriceResult.MIN) {
            usdt.transfer(info.user1, info.amount * 2);
        } else if (price1 < info.targetPrice && info.user1Predict == GamePriceResult.MAX ||
            price1 > info.targetPrice && info.user1Predict == GamePriceResult.MIN) {
            usdt.transfer(info.user2, info.amount * 2);
        }
        info.status = GameStatus.END;
    }

    // if no winner
    function cancel(uint256 gameId) public {
        GameInfo storage info = list[gameId];
        require(info.status == GameStatus.PROGRESS, 'game status error!');
        require(msg.sender == info.user1, 'can not cancel');
        info.status = GameStatus.FAIL;
        usdt.transfer(info.user1, info.amount);
        if (info.user2 != address(0)) {
            usdt.transfer(info.user2, info.amount);
        }
    }

    function gameLen() public view returns (uint256){
        return list.length;
    }

    function getGame(uint256 _index) public view returns (GameInfo memory){
        return list[_index];
    }
}
