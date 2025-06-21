# NFT Marketplace with Royalties

## Project Description

The NFT Marketplace with Royalties is a decentralized smart contract platform built on Ethereum that enables users to buy, sell, and trade Non-Fungible Tokens (NFTs) while ensuring creators receive ongoing royalties from secondary sales. This marketplace provides a secure, transparent, and efficient way to trade digital assets while protecting creator rights and maintaining fair compensation structures.

The platform implements a comprehensive trading system with built-in royalty mechanisms, marketplace fees, and secure fund management. Users can list their NFTs for sale, set royalty percentages for ongoing revenue, and participate in a trustless marketplace environment powered by smart contracts.

## Project Vision

Our vision is to create a fair and sustainable NFT ecosystem that empowers creators, collectors, and traders by:

- **Empowering Creators**: Ensuring artists and creators receive ongoing compensation through automated royalty distributions on every secondary sale
- **Building Trust**: Providing a transparent, decentralized platform where all transactions are recorded on the blockchain
- **Promoting Accessibility**: Creating an easy-to-use marketplace that welcomes both newcomers and experienced NFT enthusiasts
- **Fostering Innovation**: Supporting the growth of the digital art and collectibles space through robust infrastructure
- **Ensuring Sustainability**: Establishing a long-term viable model that benefits all participants in the NFT ecosystem

## Key Features

### Core Marketplace Functions
- **NFT Listing**: Users can list their NFTs for sale with custom pricing
- **Secure Purchasing**: Buyers can purchase NFTs with automatic ownership transfer
- **Royalty Management**: Creators can set and manage royalty percentages for their NFTs

### Advanced Features
- **Automatic Royalty Distribution**: Smart contract automatically calculates and distributes royalties to creators on secondary sales
- **Marketplace Fee Structure**: Transparent 2.5% marketplace fee to maintain platform operations
- **Earnings Management**: Users can track and withdraw their accumulated earnings from sales and royalties
- **Listing Management**: Sellers can cancel active listings when needed
- **Access Control**: Secure ownership verification and approval mechanisms

### Security Features
- **Reentrancy Protection**: Implementation of OpenZeppelin's ReentrancyGuard for secure transactions
- **Ownership Verification**: Strict validation of NFT ownership before listing or royalty setting
- **Approval Checks**: Verification of marketplace approval before NFT transfers
- **Safe Transfers**: Use of safe transfer methods to prevent stuck NFTs

### User Experience
- **Real-time Events**: Comprehensive event emission for tracking marketplace activities
- **Transparent Pricing**: Clear breakdown of fees, royalties, and seller earnings
- **Flexible Royalties**: Creators can set royalty percentages up to 10%
- **Easy Withdrawals**: Simple function for users to withdraw their accumulated earnings

## Future Scope

### Phase 1: Enhanced Features
- **Auction System**: Implementation of time-based auctions with automatic bidding
- **Offer System**: Allow buyers to make offers below listing price
- **Bulk Operations**: Enable listing and purchasing multiple NFTs in single transactions
- **Advanced Search**: Implement filtering and sorting capabilities for listings

### Phase 2: Platform Expansion
- **Multi-chain Support**: Expand to other blockchains like Polygon, Binance Smart Chain
- **Mobile Application**: Develop mobile apps for iOS and Android
- **Integration APIs**: Provide APIs for third-party applications and wallets
- **Advanced Analytics**: Implement comprehensive analytics dashboard for users

### Phase 3: DeFi Integration
- **NFT Lending**: Allow users to use NFTs as collateral for loans
- **Fractional Ownership**: Enable fractional NFT ownership through tokenization
- **Yield Farming**: Implement staking mechanisms for marketplace governance tokens
- **Insurance Protocol**: Develop insurance options for high-value NFT transactions

### Phase 4: Governance & Community
- **DAO Implementation**: Transition to decentralized governance model
- **Community Voting**: Allow users to vote on platform upgrades and fee structures
- **Creator Programs**: Establish programs to support and promote emerging artists
- **Educational Resources**: Develop comprehensive guides and tutorials for NFT trading

### Phase 5: Advanced Technologies
- **AI-Powered Recommendations**: Implement machine learning for personalized NFT suggestions
- **Virtual Reality Gallery**: Create VR spaces for showcasing NFT collections
- **Cross-platform Interoperability**: Enable seamless NFT transfers across different marketplaces
- **Carbon Neutral Operations**: Implement eco-friendly solutions and carbon offset programs

## Technical Specifications

- **Solidity Version**: ^0.8.19
- **Dependencies**: OpenZeppelin Contracts (ERC721, ReentrancyGuard, Ownable, Counters)
- **Network Compatibility**: Ethereum mainnet and testnets
- **Gas Optimization**: Efficient contract design to minimize transaction costs
- **Security Audits**: Planned security audits before mainnet deployment

## Getting Started

1. Clone the repository
2. Install dependencies: `npm install`
3. Compile contracts: `npx hardhat compile`
4. Deploy to testnet: `npx hardhat deploy --network testnet`
5. Verify contracts: `npx hardhat verify --network testnet`

## Contributing

We welcome contributions from the community! Please read our contributing guidelines and submit pull requests for any improvements or bug fixes.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

contract address : 0x05A316cc3639781874aFDCC1c14cc216a93A2277


![image](https://github.com/user-attachments/assets/13ac0c29-0646-4f27-9965-045a2f383344)
