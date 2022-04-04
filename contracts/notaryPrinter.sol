// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./mintingToken.sol";

contract notaryPrinter is mintingToken, IERC721 {
    IERC721 public stakingToken;

    mapping(uint256 => proofStruct) _proofs; 
    using Counters for Counters.Counter;
    Counters.Counter public _proofCounter;

    function stake(address _collectionAddress, uint _tokenId) external
    {

    }

    function _depositSecurity(uint _deposit, uint _proofId) internal payable
    {
        require(msg.value=_deposit, "value too low");
        
    }

    function _rentOut(uint _proofId, uint _duration) internal
    {
        proofStruct proof = _proofs[_proofId];
        proof.state = State.rentedOut;
        proof.durationOnMarket = _duration;
        proof.rent = _duration * proof.collateral;
        proof.timestamp = now;
        _proofs[_proofId] = proof;
    }

    function withdraw(uint _tokenId) external 
    {
        stakingToken.transferFrom(address(this), msg.sender, _tokenId);
        emit NFTwithdrawn(_tokenId, msg.sender, _tokenId);
    }
    
}