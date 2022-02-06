require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.0",
  networks: {
    ropsten: {
      url: "https://ropsten.infura.io/v3/b9f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8",
      accounts:['0x0f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f8f']
    }
  }
};
