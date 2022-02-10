const main =async () => {
  const Tasks = await hre.ethers.getContractFactory("TaskFactory");
  const tasks = await Tasks.deploy();

  await tasks.deployed();

  console.log(`Deployed tasks contract to ${tasks.address}`);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

runMain();