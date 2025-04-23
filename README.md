# 🛡 Decentralized VPN Payments

## 📖 Project Description
Decentralized VPN Payments is a blockchain-based solution designed to facilitate secure, trustless payments for VPN services. By utilizing smart contracts, it removes the need for third-party intermediaries, ensuring that users' identities and transactions remain private and transparent.

Users can pay a fixed fee to gain access to VPN services, and service providers can securely withdraw their earnings.

---

## 🎯 Project Vision
The vision of this project is to build a decentralized ecosystem for VPN services where:
- No centralized authority can block or restrict payments.
- Users maintain full privacy and anonymity.
- Trust is enforced through code, not intermediaries.

This aligns with the broader Web3 vision of a free, private, and decentralized internet.

---

## ✨ Key Features
- *Smart Contract-Based Payments*: Ensures that payments are handled securely and transparently on the Ethereum blockchain.
- *Access Control*: Users are granted VPN access after successful on-chain payment.
- *Owner Withdrawals*: Only the VPN provider (contract owner) can withdraw collected funds.
- *Immutable Logs*: Events like payments and access grants are recorded on-chain.

---

## 🚀 Future Scope
- *Subscription Plans*: Allow recurring payments and long-term subscriptions using ERC20 tokens.
- *Multi-Network Support*: Integrate with cheaper and faster networks like Polygon or Optimism.
- *NFT Access Passes*: Provide users with tradable access tokens as NFTs for exclusive VPN plans.
- *Analytics Dashboard*: Build a frontend to show usage, payments, and contract status in real-time.
- *Oracles Integration*: Use decentralized oracles to verify VPN uptime and handle service refunds.

---

## 🧑‍💻 Tech Stack
- *Solidity*: For writing the smart contract logic.
- *Ethereum (or compatible EVM chain)*: For deploying the contract.
- (Optional for frontend)
  - *React.js / Next.js*
  - *Web3.js / Ethers.js*

---

## 🧪 How to Use
1. Deploy the smart contract with your desired VPN price (in wei).
2. Users call `payForVPN()` to pay and gain access.
3. You (the owner) can call `withdraw()` to collect payments.

---

## 🔐 Contract Details
**Deployed Address**: `0x8FE72375a95BeF1b2c506Bb7df70c0d7BBb58408`

![image](https://github.com/user-attachments/assets/4d2e9b71-0dbc-4348-8af2-901eef788952)

