// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BlockNative is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    error BlockNative__ExpectedTokenUriLengthOfThree();
    error BlockNative__NonExistentToken();
    error BlockNative__AlreadyAMember();

    enum BlockNativeURI {
        MEMBER,
        SUPERCOOL_MEMBER,
        ELITE_MEMBER
    }

    struct BlockNativeStruct {
        uint256 tokenId;
        uint256 date;
    }

    event CreatedNFT(address indexed memmber, uint256 tokenId);

    Counters.Counter private _tokenIdCounter;
    string[] internal s_blockNativeTokenURI;
    uint256 private constant FIRST_MEMBERSHIP_PERIOD = 30 seconds;
    uint256 private constant SECOND_MEMBERSHIP_PERIOD = 60 seconds;

    mapping(address => BlockNativeStruct) private blockNativeMemberAddressToBlockNativeStruct;
    mapping(address => uint256) private blockNativeMemberToTokenId;
    address[] private blockNativeMembers;

    constructor(string[] memory blockNativeTokenURI) ERC721("BlockNative", "BTK") {
        if (blockNativeTokenURI.length != 3) {
            revert BlockNative__ExpectedTokenUriLengthOfThree();
        }
        s_blockNativeTokenURI = blockNativeTokenURI;
    }

    function requestNft() public {
        uint256 tokenId = _tokenIdCounter.current();
        if (balanceOf(msg.sender) == 1) {
            revert BlockNative__AlreadyAMember();
        }
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        blockNativeMembers.push(msg.sender);
        blockNativeMemberToTokenId[msg.sender] = tokenId;
        blockNativeMemberAddressToBlockNativeStruct[msg.sender] = BlockNativeStruct(tokenId, block.timestamp);
        emit CreatedNFT(msg.sender, tokenId);
        // _setTokenURI(tokenId, s_blockNativeTokenURI[0]);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        if (!_exists(tokenId)) {
            revert BlockNative__NonExistentToken();
        }
        BlockNativeURI tokenUriIndex = _getCurrentMembershipIndex();
        return s_blockNativeTokenURI[uint256(tokenUriIndex)];
    }

    // function supportsInterface(
    //     bytes4 interfaceId
    // ) public view override(ERC721, ERC721URIStorage) returns (bool) {
    //     return super.supportsInterface(interfaceId);
    // }

    function _getCurrentMembershipIndex() private view returns (BlockNativeURI) {
        BlockNativeStruct memory bc = blockNativeMemberAddressToBlockNativeStruct[msg.sender];
        BlockNativeURI currentUri;
        uint256 firstDuration = bc.date + FIRST_MEMBERSHIP_PERIOD;
        uint256 secondDuration = bc.date + SECOND_MEMBERSHIP_PERIOD;
        if (block.timestamp <= firstDuration) {
            currentUri = BlockNativeURI(0);
        } else if ((block.timestamp > firstDuration) && (block.timestamp < secondDuration)) {
            currentUri = BlockNativeURI(1);
        } else {
            currentUri = BlockNativeURI(2);
        }
        return currentUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    // use getBalanceOf() instead of getIsAMember();

    function getIsAMember() public view returns (bool isMember) {
        isMember = balanceOf(msg.sender) == 1;
    }

    function getBlockNativeMemberAddress(uint256 index) public view returns (address member) {
        member = blockNativeMembers[index];
    }

    function getsBlockNativeStruct() public view returns (uint256 id, uint256 date) {
        BlockNativeStruct memory memberStruct = blockNativeMemberAddressToBlockNativeStruct[msg.sender];
        id = memberStruct.tokenId;
        date = memberStruct.date;
    }

    function getTokenIdForMember() public view returns (uint256 tokenid) {
        tokenid = blockNativeMemberToTokenId[msg.sender];
    }
}
