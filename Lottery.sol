//SPDX-License-Identifier: GPL-3.0;

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address payable[] public players;  // creates a dynamic array to hold players; it is public and payable.
    address public manager;
    
    constructor(){
        manager = msg.sender;   // establishes the manager as the acct that deployed the contract.
    }
    
    receive() external payable{  // function runs automatically when it receives eth. Each contract can have only one of these! does NOT require the keyword 'function'!
        require(msg.value == 1000000000000000000);  // this is .01 ether; the entry fee
        players.push(payable(msg.sender));  // ensures incoming accts are payable!
    }
    
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);
        
        uint r = random();  // creates a random number using the above function
        address payable winner;  // creates the winner variable
        
        uint index = r % players.length;  // computes the index of the winner by dividing the random number by the number of entries.
        winner = players[index];  //  declares the winning index #
        
        winner.transfer(getBalance());  //  transfers the balance (minus gas) to the winning acct. 
        players = new address payable[](0); // resets the lottery by emptying the array;
        
    }
}




