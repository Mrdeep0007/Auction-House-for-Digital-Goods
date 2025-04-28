// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionHouse {
    address public owner;
    address public highestBidder;
    uint256 public highestBid;
    bool public auctionEnded;
    uint256 public minimumBid;
    bool public auctionPaused;

    mapping(address => uint256) public pendingReturns;

    event NewBid(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);
    event AuctionReset();
    event AuctionCancelled();
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event AuctionPaused();
    event AuctionResumed();

    constructor(uint256 _minimumBid) {
        owner = msg.sender;
        minimumBid = _minimumBid;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier whenNotPaused() {
        require(!auctionPaused, "Auction is paused");
        _;
    }

    function placeBid() public payable whenNotPaused {
        require(!auctionEnded, "Auction already ended");
        require(msg.value > highestBid, "Bid not high enough");
        require(msg.value >= minimumBid, "Bid below minimum");

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit NewBid(msg.sender, msg.value);
    }

    function withdraw() public {
        uint256 amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");

        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function endAuction() public onlyOwner {
        require(!auctionEnded, "Auction already ended");

        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);
        payable(owner).transfer(highestBid);
    }

    function cancelAuction() public onlyOwner {
        require(!auctionEnded, "Auction already ended");

        auctionEnded = true;
        auctionPaused = true;

        // Refund current highest bidder
        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }

        emit AuctionCancelled();
    }

    function resetAuction(uint256 _newMinimumBid) public onlyOwner {
        require(auctionEnded, "Auction not yet ended");

        highestBidder = address(0);
        highestBid = 0;
        auctionEnded = false;
        minimumBid = _newMinimumBid;
        auctionPaused = false;

        emit AuctionReset();
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function pauseAuction() public onlyOwner {
        require(!auctionPaused, "Auction already paused");
        auctionPaused = true;
        emit AuctionPaused();
    }

    function resumeAuction() public onlyOwner {
        require(auctionPaused, "Auction not paused");
        auctionPaused = false;
        emit AuctionResumed();
    }

    function emergencyWithdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getAuctionDetails() public view returns (
        address _owner,
        address _highestBidder,
        uint256 _highestBid,
        uint256 _minimumBid,
        bool _auctionEnded,
        bool _auctionPaused
    ) {
        return (owner, highestBidder, highestBid, minimumBid, auctionEnded, auctionPaused);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}


