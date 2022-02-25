const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("demo", function () {
  it("success", async function () {

    const accounts = await ethers.getSigners();
    const USDT = await ethers.getContractFactory("USDT");
    // const dividendsPool = await DividendsPool.attach('0xF2652a4c2CC76AcA32c58496763D1BA55Af89e39');
    // console.info(dividendsPool.address)

    const usdt = await USDT.deploy('USDT','USDT');
    await usdt.deployed();
    await usdt.mint(accounts[0].address,'1000000000000000000000000000000')

    const Game = await ethers.getContractFactory('Game');
    const game = await Game.deploy();
    await game.deployed();
    await game.config('0x8A753747A1Fa494EC906cE90E9f37563A8AF630e',usdt.address);


    //init
    console.info((await usdt.balanceOf(accounts[0].address)).toString())
    await usdt.approve(game.address,'1000000000000000000000000000000');
    await game.start('200000000000',0,false);
    console.info((await usdt.balanceOf(accounts[0].address)).toString())

    await game.join(0);
    console.info((await usdt.balanceOf(accounts[0].address)).toString())


  });
});
