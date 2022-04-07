// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract tenantUser
{
    event offerSent(address indexed _to, uint _tokenId, uint _collateral, uint _rent, uint _durationOnMarket);
    event offerCancelled(_to, _tokenId, _collateral, _rent, _durationOnMarket);(address indexed _to, uint _tokenId, uint _collateral, uint _rent, uint _durationOnMarket);
    
    function sendOffer(
        address _to, uint _tokenId, uint _collateral, uint _rent, uint _durationOnMarket
        ) external
    {
        emit offerSent(_to, _tokenId, _collateral, _rent, _durationOnMarket);
    } 

    function cancelOffer(
         address _to, uint _tokenId, uint _collateral, uint _rent, uint _durationOnMarket
        ) external
    {
        emit offerCancelled(_to, _tokenId, _collateral, _rent, _durationOnMarket);
    } 

    function buy(uint _tokenId) // Allows tenant to buy proof
    {
        // require() pNFT valid
        // require() msg.value > rent
        // mint() user a pNFT
        // _setProof() per user and NFT
        // set NFT to off market
    }
}