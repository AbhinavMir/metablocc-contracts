// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

interface mintingTokenInterface
{
    enum State { onMarket, offMarket, rentedOut, toBurn}

    struct NFTattributes{
        address _userAddress;
        bytes32 _collectionName;
        bytes32 _symbol;
        bytes32 _tokenURI;
        address _collectionAddress;
        uint _tokenId;
        uint _timestamp;
        uint _collateral;
        uint _rent;
        uint _durationOnMarket;
        State state;}

    event ProofMinted(address indexed _to, uint256 indexed _tokenId, bytes32 indexed _hashOriginal);
    event ProofBurned(uint256 indexed _tokenId);
    event ProofValidated(uint256 indexed _tokenId, bool _valid);
    event ProofAdded(uint256 indexed _tokenId, address indexed _staker, address  _collectionAddress);
    event ProofOwnerChanged(uint256 indexed _tokenId, address indexed _newOwner);
    event NFTstaked(uint256 indexed _tokenId, address indexed _to, uint256 _amount);
    event NFTwithdrawn(uint256 indexed _tokenId, address indexed _to, uint256 _amount);
    event StatusChanged(uint256 indexed _tokenId, State _newState);
}

contract mintingToken is ERC721, ERC721URIStorage, Ownable, mintingTokenInterface {

    constructor() ERC721("pNFT", "PFNT") 
    {}

    mapping(uint=>NFTattributes) _NFTproofs; // token ID to Struct

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _proofCounter;

    function safeMint(address to) internal onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _setProof(
        address _userAddress, bytes32 _collectionName, bytes32 _symbol, bytes32 _tokenURI, uint _rent, uint _duration, uint _collateral, uint _tokenId, address _staker, address _collectionAddress) internal {
        safeMint(_userAddress);
        NFTattributes memory proof = NFTattributes
                                        (_userAddress,
                                        _collectionName,
                                        _symbol,
                                        _tokenURI,
                                        _collectionAddress,
                                        _tokenId,
                                        block.timestamp,
                                        _collateral,
                                        _rent,
                                        _duration,
                                        State.onMarket);

        uint _proofCounterCurrent = _proofCounter.current();
        _NFTproofs[_proofCounterCurrent] = proof;
        _proofCounter.increment();
        emit ProofAdded(_tokenId, _staker, _collectionAddress);
    }

    function proofStatus(uint _tokenId) public view returns(State)
    {
        require(_tokenId<=_proofCounter.current());


        return _NFTproofs[_tokenId].state;
    }

    function getProofMetaData(uint _tokenId) public view returns(address, bytes32, bytes32, bytes32)
    {
        return (_NFTproofs[_tokenId]._userAddress,
                _NFTproofs[_tokenId]._collectionName,
                _NFTproofs[_tokenId]._symbol,
                _NFTproofs[_tokenId]._tokenURI);
    }
        
        
    function getProofDetails(uint _tokenId) external view returns(address, uint, uint, uint, uint, uint, State)
    {
        return (
                _NFTproofs[_tokenId]._collectionAddress,
                _NFTproofs[_tokenId]._tokenId,
                _NFTproofs[_tokenId]._timestamp,
                _NFTproofs[_tokenId]._collateral,
                _NFTproofs[_tokenId]._rent,
                _NFTproofs[_tokenId]._durationOnMarket,
                _NFTproofs[_tokenId].state);
    }

    function _changeStatus(uint _tokenId, State _newState) internal onlyOwner {
        require(_tokenId<=_proofCounter.current());
        _NFTproofs[_tokenId].state = _newState;
        emit StatusChanged(_tokenId, _newState);
    }

    function transferOwnershipOfToken(uint _tokenId, address _newOwner) internal onlyOwner {
        require(_tokenId<=_proofCounter.current());

        _NFTproofs[_tokenId]._userAddress = _newOwner;
        emit ProofOwnerChanged(_tokenId, _newOwner);
    }
}
