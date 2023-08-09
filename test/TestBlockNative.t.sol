// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBlockNativeNFT} from "../script/DeployBlockNativeNFT.s.sol";
import {BlockNative} from "../src/BlockNative.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract TestBlockNative is StdCheats, Test {
    // Events
    event CreatedNFT(address indexed memmber, uint256 tokenId);

    BlockNative private bnNft;
    DeployBlockNativeNFT private deployBnNft;

    address public USER = makeAddr("USER");
    uint256 private constant STARTING_USER_BALANCE = 10 ether;
    string[] private tokenURIs;

    function setUp() external {
        deployBnNft = new DeployBlockNativeNFT();
        (bnNft, tokenURIs) = deployBnNft.run();
        if (block.chainid == 31337) {
            vm.deal(USER, STARTING_USER_BALANCE);
        }
        // giving our user some money!!!!
        vm.deal(USER, STARTING_USER_BALANCE);
    }
    // constructor test

    string[] private tokenUris = ["ipfs://QmfGvc9JynDLxTY41XA6b8598XvcqEBuCDmmjF4W6pqXr2"];

    function testRevertsIfTokenUriLengthIsNotEqualToThree() public {
        vm.expectRevert(BlockNative.BlockNative__ExpectedTokenUriLengthOfThree.selector);
        new BlockNative(tokenUris);
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "BlockNative";
        string memory actualName = bnNft.name();
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    modifier nftRequest() {
        vm.prank(USER);
        bnNft.requestNft();
        _;
    }

    function testRevertsIfMinterIsAlreadyAMember() public nftRequest {
        vm.prank(USER);
        vm.expectRevert(BlockNative.BlockNative__AlreadyAMember.selector);
        bnNft.requestNft();
    }

    function testTokenCounterBeginsAtZero() public {
        vm.prank(USER);
        uint256 realResult = bnNft.getTokenCounter();
        assertEq(realResult, 0);
    }

    function testTokenCounterIncrementsWhenNftIsMinted() public nftRequest {
        vm.prank(USER);
        uint256 currentTokenId = bnNft.getTokenCounter();
        assertEq(currentTokenId, 1);
    }

    function testIsMemberReturnsTrueIfNftMinted() public nftRequest {
        bool expectedAnswer = true;
        vm.prank(USER);
        bool realAnswer = bnNft.getIsAMember();
        assertEq(realAnswer, expectedAnswer);
    }

    function testUpdatesBlockNativeMemberArrayWhenNftMinted() public nftRequest {
        address expectedAddress = bnNft.getBlockNativeMemberAddress(0);
        assertEq(USER, expectedAddress);
    }

    function testEventIsEmittedWhenNftIsMinted() public {
        vm.prank(USER);
        vm.expectEmit(true, false, false, true, address(bnNft));
        emit CreatedNFT(USER, 0);
        bnNft.requestNft();
    }

    function testUpdatesTheBlockNativeStruct() public nftRequest {
        vm.prank(USER);
        (uint256 tokenId,) = bnNft.getsBlockNativeStruct();
        assertEq(tokenId, 0);
    }

    function testRevertsIfEnteredAnInvalidTokenId() public nftRequest {
        uint256 invalidTokenId = 1;
        vm.expectRevert(BlockNative.BlockNative__NonExistentToken.selector);
        bnNft.tokenURI(invalidTokenId);
    }

    function testTokenUriReturnsURI() public nftRequest {
        string memory expectedTokenUri = tokenURIs[0];
        vm.prank(USER);
        uint256 tokenid = bnNft.getTokenIdForMember();
        string memory actualTokenUri = bnNft.tokenURI(tokenid);

        assertEq(actualTokenUri, expectedTokenUri);
    }

    function testChangesTokenURIAfterThirtySeconds() public nftRequest {
        string memory expectedTokenUri = tokenURIs[1];
        vm.prank(USER);
        vm.warp(block.timestamp + 31 seconds);
        uint256 tokenid = bnNft.getTokenIdForMember();
        string memory actualTokenUri = bnNft.tokenURI(tokenid);

        assertEq(actualTokenUri, expectedTokenUri);
    }

    function testChangesTokenURIAfterSixtySeconds() public nftRequest {
        string memory expectedTokenUri = tokenURIs[2];
        vm.prank(USER);
        vm.warp(block.timestamp + 61 seconds);
        uint256 tokenid = bnNft.getTokenIdForMember();
        string memory actualTokenUri = bnNft.tokenURI(tokenid);

        assertEq(actualTokenUri, expectedTokenUri);
    }

    function testBalanceOfUser() public nftRequest {
        vm.prank(USER);
        uint256 balance = bnNft.balanceOf(USER);
        assert(balance == 1);
    }

    function testBalanceOfNonMinterIsZero() public {
        vm.prank(USER);
        uint256 balance = bnNft.balanceOf(USER);
        assert(balance == 0);
    }
}
