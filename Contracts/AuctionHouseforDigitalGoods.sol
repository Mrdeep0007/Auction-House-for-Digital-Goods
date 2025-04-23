
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionHouse {
    address public owner;
    address public highestBidder;
    uint256 public highestBid;
    bool public auctionEnded;

    constructor() {
        owner = msg.sender;
    }

    function placeBid() public payable {
        require(!auctionEnded, "Auction already ended");
        require(msg.value > highestBid, "Bid not high enough");

        if (highestBid != 0) {
            payable(highestBidder).transfer(highestBid); // Refund previous highest bidder
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function endAuction() public {
        require(msg.sender == owner, "Only owner can end the auction");
        require(!auctionEnded, "Auction already ended");

        auctionEnded = true;
        payable(owner).transfer(highestBid);
    }
}
