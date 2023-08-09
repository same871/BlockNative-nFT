// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {RequestBlockNativeNFT, BNTokenURI} from "../script/Interactions.s.sol";
import {DeployBlockNativeNFT} from "../script/DeployBlockNativeNFT.s.sol";
import {BlockNative} from "../src/BlockNative.sol";

contract InteractionsTest is Test {
    RequestBlockNativeNFT requestNft;
    BNTokenURI tokenURI;
    DeployBlockNativeNFT deployer;
    BlockNative blocky;

    function setUp() public {
        requestNft = new RequestBlockNativeNFT();
        tokenURI = new BNTokenURI();
        deployer = new DeployBlockNativeNFT();
        (blocky,) = deployer.run();
    }

    function testRequestNftFromInteractions() public {
        requestNft.requestBlockNativeNFT(address(blocky));
    }

    modifier requestBNNft() {
        requestNft.requestBlockNativeNFT(address(blocky));
        _;
    }

    function testTokenUriFromInteractions() public requestBNNft {
        tokenURI.blockNativeTokenUri(0, address(blocky));
    }
}
