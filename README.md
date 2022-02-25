# use chainlink for historical price by round id

# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample
script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/deploy.js
npx hardhat help
```

# deploy

```
script : ./script/deploy.js
command : npx hardhat run deploy.js

```

# interface param doc

## start a game

```
start(uint256 _targetPrice, uint256 _amount, uint128 _endTime, bool isMax)
_targetPrice: the eth price * price decimal :ex 260000000000
_amount: the usdt amount 
_endTime: game end time
isMax:if msg.sender want price > 2600 ,the value is true,
```

## join a game

```
join(uint256 gameId)
gameId: the game list index
```

## end a game

```
end(uint256 gameId, uint80 roundId)
gameId: the game list index
roundId:time corresponding to the roundId must > endTime,and time corresponding to the last roundId must < endTime
```

# test contract 
```
game : https://rinkeby.etherscan.io/address/0x4A3cb5AfFEc4aF0603cd6B9Fae21eE32efe256E5
usdt:  https://rinkeby.etherscan.io/address/0x486D44b1Ca0DAa0B9741361297151f165D6a6852
```

# test private key 
```
a812381d35542a7cb75206c6682d91f1073512684df8a4d52c3be6e0bcc5c600
```
