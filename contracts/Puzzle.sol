// SPDX-License-Identifier: The Unlicense
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";

// This is just a simple example of a puzzle contract. It holds puzzle asnwer verification logic and prize distribution system.
// Contract utilize Openzeppelin libraries called Ownable and PullPayment. Ownable adds few owner-related modifiers and function, 
// so we can define function available for owner only in easy and secure way. 
// PullPayment allows to send prize to winner, so there is no danger of spent prize (for example by another submitSolution call) before withdrawal

// Few rules about the game:
// - There is 1 winner available per blochckain block. Contract keeps and update mapping of solved blocks, also there is PuzzleWinner event for potential log purposes.
// - Answer is always provided as a hash, via submitSolution function. It's public, so anyone can interact with it
// - Winner is a first address who provide proper answer hash for particular block
// - Winning address will get reward prize defined in contract. It's some ETH in this case
// - Prize is distribured by contract itself. If there is not enough ETH held by contract, player will not be able to submit his answer, even if this is proper one.
// - Prize can be modified and contract can be "refilled" with ETH by owner only. It is possible to change contract's owner. 

// Puzzle solution hash should be provided during contract deploy as constructor parameter. This can be modified via setPuzzleSolutionHash function.
// contract itself does not care puzzle answer structure, image or element size - it holds solution hash and compares it with incoming answer hash,
// so any kind of puzzles can be utilized by this contract - we can provide hashed image assembly performed by user, or proper array of puzzle elements, or anything we like.

// contract utilize Openzeppelin libraries called Ownable and PullPayment. Ownable adds few owner-related modifiers and function, 
// so we can define function available for owner only in easy and secure way. 
// PullPayment allows to send prize to winner, so there is no danger of spent prize (for example by another submitSolution call) before withdrawal
// There are couple of get/set functions available to configure contract variables like solution hash or prize value. Also we can use those to check or deposit ETH held by contract.

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
