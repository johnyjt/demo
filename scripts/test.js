// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const {ethers} = require("hardhat");

async function main() {
    const accounts = await ethers.getSigners();
    const USDT = await ethers.getContractFactory("USDT");
    // const dividendsPool = await DividendsPool.attach('0xF2652a4c2CC76AcA32c58496763D1BA55Af89e39');
    // console.info(dividendsPool.address)

    const usdt = await USDT.attach('0x486D44b1Ca0DAa0B9741361297151f165D6a6852');

    const Game = await ethers.getContractFactory('Game');
    const game = await Game.attach('0x4A3cb5AfFEc4aF0603cd6B9Fae21eE32efe256E5');
    // await game.config('0x8A753747A1Fa494EC906cE90E9f37563A8AF630e',usdt.address);


    //init
    // console.info((await usdt.balanceOf(accounts[0].address)).toString())
    // await usdt.approve(game.address,'1000000000000000000000000000000');
    // await game.start('200000000000','1000000000000000000','0',false);
    // console.info((await usdt.balanceOf(accounts[0].address)).toString())

    // await game.join(0);
    // console.info((await usdt.balanceOf(accounts[0].address)).toString())
    console.info((await game.getGame(0)).toString())
    https://github.com/johnyjt/demo

    await game.end(0,'55340232221128657464');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
