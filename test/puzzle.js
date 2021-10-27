const Puzzle = artifacts.require("Puzzle");

contract('Puzzle', (accounts) => {
  it('should deploy the contract with given arguments', async () => {
    const puzzleInstance = await Puzzle.deployed('f12c9f181bb63b482b49ab375bead1d9cbd0bf7d802b9dd6fe9981f1d9b02e25',100);
    const balance = await puzzleInstance.getBalance.call(accounts[0]);
  });
});
