// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./mintingToken.sol";

contract notaryPrinter is mintingToken {

    using Counters for Counters.Counter;
    Counters.Counter public _proofCounter;

    function stake(
        address _collectionAddress, uint _tokenId, uint _collateral, uint _rent, uint _durationOnMarket
        ) external
    {
        IERC721 stakingToken = IERC721(_collectionAddress);
        require(msg.sender==stakingToken.ownerOf(_tokenId));
        mintingToken._setProof(msg.sender, stakingToken.name(), stakingToken.symbol(), stakingToken.tokenURI(_tokenId), _collectionAddress, _tokenId, block.timestamp, _collateral, _rent, _durationOnMarket);
    }

    function listNFT(address _collectionAddress, uint _tokenId, uint _collateral, uint _rent, uint _durationOnMarket) external
    {
        IERC721 stakingToken = new IERC721(_collectionAddress);
        require(msg.sender==stakingToken.ownerOf());
        mintingToken._changeStatus(mintingToken.currentTokenID(), mintingToken.State.onMarket);
    }

    function delistNFT(address _collectionAddress, uint _tokenId) external
    {
        IERC721 stakingToken = new IERC721(_collectionAddress);
        require(msg.sender==stakingToken.ownerOf());
        mintingToken._changeStatus(mintingToken.currentTokenID(), mintingToken.State.offMarket);
    }

    function rentOutNFT(address _collectionAddress, uint _tokenId, uint _rent, uint _durationOnMarket) external
    {
        IERC721 stakingToken = new IERC721(_collectionAddress);
        require(msg.sender==stakingToken.ownerOf());
        mintingToken._changeStatus(mintingToken.currentTokenID(), mintingToken.State.rentedOut);
    }

    function unstake(address _collectionAddress, uint _tokenId) external
    {
        IERC721 stakingToken = new IERC721(_collectionAddress);
        require(msg.sender==stakingToken.ownerOf());
        stakingToken.safeTransferFrom(msg.sender, this, _tokenId);
        uint _tokenIdCounter = mintingToken.currentTokenID();
        mintingToken._burn(_tokenIdCounter);
        mintingToken._changeStatus(_tokenIdCounter, mintingToken.State.offMarket);
    }

    function acceptOffer(
        address _from, uint _tokenId, uint _collateral, uint _rent, uint _durationOnMarket
        ) external
    {
        require(msg.sender==_from);
        mintingToken._setProof(msg.sender, mintingToken.name(), mintingToken.symbol(), mintingToken.tokenURI(_tokenId), _from, _tokenId, block.timestamp, _collateral, _rent, _durationOnMarket);
    }
}
}