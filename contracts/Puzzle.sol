// SPDX-License-Identifier: The Unlicense
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";

contract Puzzle is Ownable, PullPayment {

	bytes32 private puzzleSolutionHash;
	uint private puzzlePrize;
	mapping (uint => bool) private solvedBlocksList;

	event PuzzleWinner(address prizeWinner, uint blockNumber, uint puzzlePrize);

	constructor(bytes32 _puzzleSolutionHash, uint _puzzlePrize) {
		puzzleSolutionHash = _puzzleSolutionHash;
		puzzlePrize = _puzzlePrize;
	}

	function submitSolution(bytes32 _puzzleHash) public payable {
		require(!solvedBlocksList[block.number],'Puzzles are already solved for actual block. Please wait for next block with your submission!');
		require(_puzzleHash==puzzleSolutionHash, 'Wrong answer!');
		_asyncTransfer(msg.sender, puzzlePrize);
		solvedBlocksList[block.number] = true;
		emit PuzzleWinner(msg.sender,block.number,puzzlePrize);
	}

	function setPuzzleSolutionHash(bytes32 _puzzleSolutionHash) public onlyOwner {
		puzzleSolutionHash = _puzzleSolutionHash;
	}

	function getPuzzleSolutionHash() public view returns(bytes32) {
		return puzzleSolutionHash;
	}

	function setPuzzlePrizePrize(uint _puzzlePrize) public  {
		puzzlePrize = _puzzlePrize;
	}

	function getPuzzlePrize() public view returns(uint) {
		return puzzlePrize;
	}

	function getContractBalance() public view returns(uint) {
		return address(this).balance;
	}
}
