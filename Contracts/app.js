// app.js

let web3;
let auctionContract;
let userAccount;

// Your deployed contract address and ABI
const contractAddress = "0x8FE72375a95BeF1b2c506Bb7df70c0d7BBb58408";
const contractABI = [
  // Only important fragments (short version)
  {
    "inputs": [],
    "name": "getAuctionDetails",
    "outputs": [
      { "internalType": "address", "name": "_owner", "type": "address" },
      { "internalType": "address", "name": "_highestBidder", "type": "address" },
      { "internalType": "uint256", "name": "_highestBid", "type": "uint256" },
      { "internalType": "uint256", "name": "_minimumBid", "type": "uint256" },
      { "internalType": "bool", "name": "_auctionEnded", "type": "bool" },
      { "internalType": "bool", "name": "_auctionPaused", "type": "bool" }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "placeBid",
    "outputs": [],
    "stateMutability": "payable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "withdraw",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "endAuction",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "pauseAuction",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "resumeAuction",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      { "internalType": "uint256", "name": "_newMinimumBid", "type": "uint256" }
    ],
    "name": "resetAuction",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];

async function connectWallet() {
  if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    await window.ethereum.request({ method: "eth_requestAccounts" });

    const accounts = await web3.eth.getAccounts();
    userAccount = accounts[0];

    auctionContract = new web3.eth.Contract(contractABI, contractAddress);

    console.log("Connected account:", userAccount);
    loadAuctionDetails();
  } else {
    alert("Please install MetaMask!");
  }
}

async function loadAuctionDetails() {
  const details = await auctionContract.methods.getAuctionDetails().call();

  document.getElementById("owner").innerText = details._owner;
  document.getElementById("highestBidder").innerText = details._highestBidder;
  document.getElementById("highestBid").innerText = web3.utils.fromWei(details._highestBid, "ether") + " ETH";
  document.getElementById("minimumBid").innerText = web3.utils.fromWei(details._minimumBid, "ether") + " ETH";
  document.getElementById("auctionEnded").innerText = details._auctionEnded ? "Yes" : "No";
  document.getElementById("auctionPaused").innerText = details._auctionPaused ? "Yes" : "No";
}

async function placeBid() {
  const bidAmount = document.getElementById("bidAmount").value;
  await auctionContract.methods.placeBid().send({
    from: userAccount,
    value: web3.utils.toWei(bidAmount, "ether")
  });
  loadAuctionDetails();
}

async function withdraw() {
  await auctionContract.methods.withdraw().send({ from: userAccount });
}

async function endAuction() {
  await auctionContract.methods.endAuction().send({ from: userAccount });
  loadAuctionDetails();
}

async function pauseAuction() {
  await auctionContract.methods.pauseAuction().send({ from: userAccount });
  loadAuctionDetails();
}

async function resumeAuction() {
  await auctionContract.methods.resumeAuction().send({ from: userAccount });
  loadAuctionDetails();
}

async function resetAuction() {
  const newMinBid = document.getElementById("newMinBid").value;
  await auctionContract.methods.resetAuction(web3.utils.toWei(newMinBid, "ether")).send({ from: userAccount });
  loadAuctionDetails();
}
