const { expect } = require("chai");
const { ethers } = require("hardhat");

  describe('Create new Task', async () => {
    let Task, task, parent, add1, add2;

    before(async () => {
      Task = await ethers.getContractFactory("TaskFactory");
      task = await Task.deploy();
      [parent, add1, add2, _] = await ethers.getSigners();
    });

    it('task created by parent', async() => {
      const result = await task._createTask("Task 1", false, false);
      console.log('res1',result, add1.address, parent.address);

    }) 

    it('assign child', async() => {
      const result = await task._addChild(0, parent.address);
      console.log('res2',result);
    })
  })



