//SPDX-License-Identifier: Unlicense

// Challenge 1: be able to allow the address to be changed in constructor. now, it can be only withdrawn 
// to the owner, the address that deployed the contract. and owner can never be changed. find a way to maybe create
// a function that allows to owner can be updated BUT only by specific people. only the person who deployed the contract can change it
//to another address.

//Challenge 2: Create a Send 1 Large Coffee for 0.003 ETH function. Make sure you add a proper button and get rid of creating too many memo's.
//Challenge 3 (copilot's advice): Create a function that allows you to send a custom amount of ETH to the owner. Make sure you add a proper button and get rid of creating too many memo's.


pragma solidity ^0.8.0;

// Example deployed to Goerli: 0xeF4aFC945cFb5113A859Ef1A956C3932be3742a6 by npx run hardhat scripts/deploy.js --network goerli

contract BuyMeACoffee {
    // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );
    
    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }
    
    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address payable owner;

    // List of all memos received from coffee purchases.
    Memo[] memos;

    constructor() {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        owner = payable(msg.sender);
    }

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Must accept more than 0 ETH for a coffee.
        require(msg.value > 0, "can't buy coffee for free!");

        // Add the memo to storage!
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(owner.send(address(this).balance));
    }
}
