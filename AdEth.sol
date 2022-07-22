// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';

contract AdEth is Ownable {

//  @author Brody McFarland 2022
//  - This contract allows a user to pay x amount of eth for x amount of minutes of ad time.
//  - You can control the price for the ads within the require statements in the receiveAdPayment Function
//  - You can control the length of the ads by changing uint cooldownTime

    string currentURI;
    string currentAdName;
    uint _start;
    uint _end;
    uint cooldownTime = 3 minutes; //<-- @dev - Change Ad Length Here | 1440 mins = 1 Day | 
    uint runNumber = 0;

// @dev - Event to signal a image/video change with an event listener
    event AdStart(address _from, uint _runNumber, string _currentURI, string _currentAdName);

// @dev - Main Function - Stores the URI of the image/gif and the name provided for the Ad
    function receiveAdPayment(string memory _currentURI, string memory _currentAdName) payable public {
        currentURI = _currentURI;
        currentAdName = _currentAdName;
        require(msg.value >= 0.1 ether, "At Least 0.1 ETH Needed."); //<-- @dev - Eth price per ad can be changed here
        require(block.timestamp > _end, "There is currently an ad running. Please wait until the cooldown is finished.");
        start();
    }

// @dev - Timer logic & emitting Event
    function start() internal {
        _start = block.timestamp;
        _end = block.timestamp + cooldownTime;
        runNumber++;
        emit AdStart(msg.sender, runNumber, currentURI, currentAdName);
    }

// @dev - All the getter functions
    function getTimeLeft() public view returns(uint) {
        return (_end - block.timestamp);
    }

    function getURI() public view returns(string memory) {
        return currentURI;
    }

    function getAdName() public view returns(string memory) {
        return currentAdName;
    }


    function getRunNumber() public view returns (uint) {
        return runNumber;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

// @dev - Cashout for owner of contract Only
    function withdraw(uint _amount) external onlyOwner {
        payable(msg.sender).transfer(_amount);
    }
}