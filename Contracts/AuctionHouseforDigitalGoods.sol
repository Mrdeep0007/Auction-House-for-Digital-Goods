// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionHouse {
    address public owner;
    address public highestBidder;
    uint256 public highestBid;
    bool public auctionEnded;

    mapping(address => uint256) public pendingReturns;

    event NewBid(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);
    event AuctionReset();

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    function placeBid() public payable {
        require(!auctionEnded, "Auction already ended");
        require(msg.value > highestBid, "Bid not high enough");

        if (highestBid != 0) {
            // Store refund for previous highest bidder
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit NewBid(msg.sender, msg.value);
    }

    function withdraw() public {
        uint256 amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");

        // Reset balance before transfer to prevent reentrancy
        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function endAuction() public onlyOwner {
        require(!auctionEnded, "Auction already ended");

        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);
        payable(owner).transfer(highestBid);
    }

    function getAuctionDetails() public view returns (
        address _owner,
        address _highestBidder,
        uint256 _highestBid,
        bool _auctionEnded
    ) {
        return (owner, highestBidder, highestBid, auctionEnded);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Optional: Reset auction to start over (clears only data, not funds)
    function resetAuction() public onlyOwner {
        require(auctionEnded, "Auction not yet ended");

        highestBidder = address(0);
        highestBid = 0;
        auctionEnded = false;

        emit AuctionReset();
    }
}

