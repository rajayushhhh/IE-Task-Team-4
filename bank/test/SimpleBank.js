const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SimpleBank", function () {
  let SimpleBank, bank, owner, user1, user2;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    SimpleBank = await ethers.getContractFactory("SimpleBank");
    bank = await SimpleBank.deploy();
    await bank.waitForDeployment();
  });

  it("should allow users to deposit Ether", async function () {
    await bank.connect(user1).deposit({ value: ethers.parseEther("1.0") });
    const balance = await bank.balances(user1.address);
    expect(balance).to.equal(ethers.parseEther("1.0"));
  });

  it("should allow users to withdraw Ether", async function () {
    await bank.connect(user1).deposit({ value: ethers.parseEther("1.0") });
    await bank.connect(user1).withdraw(ethers.parseEther("0.5"));
    const balance = await bank.balances(user1.address);
    expect(balance).to.equal(ethers.parseEther("0.5"));
  });

  it("should not allow withdrawing more than balance", async function () {
    await expect(bank.connect(user1).withdraw(ethers.parseEther("1.0"))).to.be.revertedWith("Insufficient balance");
  });

  it("should only allow owner to view total contract balance", async function () {
    await bank.connect(user1).deposit({ value: ethers.parseEther("2.0") });
    await expect(bank.connect(user1).getContractBalance()).to.be.revertedWith("Only owner can perform this action");
    const total = await bank.connect(owner).getContractBalance();
    expect(total).to.equal(ethers.parseEther("2.0"));
  });
});
