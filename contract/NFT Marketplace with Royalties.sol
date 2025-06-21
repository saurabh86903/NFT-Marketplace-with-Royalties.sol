// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title NFT Marketplace with Royalties
 * @dev A decentralized marketplace for trading NFTs with automatic royalty distribution
 */
contract Project is ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;
    
    // Marketplace fee (2.5%)
    uint256 public constant MARKETPLACE_FEE = 250; // 2.5% in basis points
    uint256 public constant BASIS_POINTS = 10000;
    
    // Counter for listing IDs
    Counters.Counter private _listingIds;
    
    // Royalty info structure
    struct RoyaltyInfo {
        address recipient;
        uint256 percentage; // in basis points (e.g., 500 = 5%)
    }
    
    // Listing structure
    struct Listing {
        uint256 listingId;
        address nftContract;
        uint256 tokenId;
        address seller;
        uint256 price;
        bool active;
    }
    
    // Mappings
    mapping(uint256 => Listing) public listings;
    mapping(address => mapping(uint256 => RoyaltyInfo)) public royalties;
    mapping(address => uint256) public earnings;
    
    // Events
    event NFTListed(
        uint256 indexed listingId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        uint256 price
    );
    
    event NFTSold(
        uint256 indexed listingId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address buyer,
        uint256 price
    );
    
    event RoyaltySet(
        address indexed nftContract,
        uint256 indexed tokenId,
        address recipient,
        uint256 percentage
    );
    
    event ListingCancelled(uint256 indexed listingId);
    
    constructor() Ownable(msg.sender) {}
    
    /**
     * @dev Core Function 1: List an NFT for sale
     * @param _nftContract Address of the NFT contract
     * @param _tokenId Token ID of the NFT
     * @param _price Price in wei
     */
    function listNFT(
        address _nftContract,
        uint256 _tokenId,
        uint256 _price
    ) external nonReentrant {
        require(_price > 0, "Price must be greater than 0");
        require(
            IERC721(_nftContract).ownerOf(_tokenId) == msg.sender,
            "You don't own this NFT"
        );
        require(
            IERC721(_nftContract).isApprovedForAll(msg.sender, address(this)) ||
            IERC721(_nftContract).getApproved(_tokenId) == address(this),
            "Marketplace not approved to transfer NFT"
        );
        
        _listingIds.increment();
        uint256 listingId = _listingIds.current();
        
        listings[listingId] = Listing({
            listingId: listingId,
            nftContract: _nftContract,
            tokenId: _tokenId,
            seller: msg.sender,
            price: _price,
            active: true
        });
        
        emit NFTListed(listingId, _nftContract, _tokenId, msg.sender, _price);
    }
    
    /**
     * @dev Core Function 2: Buy an NFT from the marketplace
     * @param _listingId ID of the listing to purchase
     */
    function buyNFT(uint256 _listingId) external payable nonReentrant {
        Listing storage listing = listings[_listingId];
        
        require(listing.active, "Listing is not active");
        require(msg.value >= listing.price, "Insufficient payment");
        require(msg.sender != listing.seller, "Cannot buy your own NFT");
        
        // Mark listing as inactive
        listing.active = false;
        
        // Calculate fees and royalties
        uint256 totalPrice = listing.price;
        uint256 marketplaceFee = (totalPrice * MARKETPLACE_FEE) / BASIS_POINTS;
        uint256 royaltyAmount = 0;
        
        // Check if royalty is set for this NFT
        RoyaltyInfo memory royaltyInfo = royalties[listing.nftContract][listing.tokenId];
        if (royaltyInfo.recipient != address(0) && royaltyInfo.percentage > 0) {
            royaltyAmount = (totalPrice * royaltyInfo.percentage) / BASIS_POINTS;
            earnings[royaltyInfo.recipient] += royaltyAmount;
        }
        
        // Calculate seller earnings
        uint256 sellerEarnings = totalPrice - marketplaceFee - royaltyAmount;
        earnings[listing.seller] += sellerEarnings;
        earnings[owner()] += marketplaceFee;
        
        // Transfer NFT to buyer
        IERC721(listing.nftContract).safeTransferFrom(
            listing.seller,
            msg.sender,
            listing.tokenId
        );
        
        // Refund excess payment
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
        
        emit NFTSold(
            _listingId,
            listing.nftContract,
            listing.tokenId,
            listing.seller,
            msg.sender,
            totalPrice
        );
    }
    
    /**
     * @dev Core Function 3: Set royalty information for an NFT
     * @param _nftContract Address of the NFT contract
     * @param _tokenId Token ID of the NFT
     * @param _recipient Address to receive royalties
     * @param _percentage Royalty percentage in basis points (e.g., 500 = 5%)
     */
    function setRoyalty(
        address _nftContract,
        uint256 _tokenId,
        address _recipient,
        uint256 _percentage
    ) external {
        require(
            IERC721(_nftContract).ownerOf(_tokenId) == msg.sender,
            "Only NFT owner can set royalty"
        );
        require(_recipient != address(0), "Invalid recipient address");
        require(_percentage <= 1000, "Royalty percentage too high (max 10%)");
        
        royalties[_nftContract][_tokenId] = RoyaltyInfo({
            recipient: _recipient,
            percentage: _percentage
        });
        
        emit RoyaltySet(_nftContract, _tokenId, _recipient, _percentage);
    }
    
    /**
     * @dev Cancel an active listing
     * @param _listingId ID of the listing to cancel
     */
    function cancelListing(uint256 _listingId) external {
        Listing storage listing = listings[_listingId];
        
        require(listing.active, "Listing is not active");
        require(
            listing.seller == msg.sender || msg.sender == owner(),
            "Only seller or owner can cancel listing"
        );
        
        listing.active = false;
        
        emit ListingCancelled(_listingId);
    }
    
    /**
     * @dev Withdraw accumulated earnings
     */
    function withdrawEarnings() external nonReentrant {
        uint256 amount = earnings[msg.sender];
        require(amount > 0, "No earnings to withdraw");
        
        earnings[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
    
    /**
     * @dev Get listing details
     * @param _listingId ID of the listing
     * @return Listing struct
     */
    function getListing(uint256 _listingId) external view returns (Listing memory) {
        return listings[_listingId];
    }
    
    /**
     * @dev Get royalty information for an NFT
     * @param _nftContract Address of the NFT contract
     * @param _tokenId Token ID of the NFT
     * @return RoyaltyInfo struct
     */
    function getRoyaltyInfo(address _nftContract, uint256 _tokenId) 
        external 
        view 
        returns (RoyaltyInfo memory) 
    {
        return royalties[_nftContract][_tokenId];
    }
    
    /**
     * @dev Get current listing count
     * @return Current number of listings created
     */
    function getCurrentListingId() external view returns (uint256) {
        return _listingIds.current();
    }
    
    /**
     * @dev Get user earnings
     * @param _user Address of the user
     * @return Amount of earnings available for withdrawal
     */
    function getUserEarnings(address _user) external view returns (uint256) {
        return earnings[_user];
    }
}
