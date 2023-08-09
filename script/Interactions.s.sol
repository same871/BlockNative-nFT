// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
// import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {BlockNative} from "../src/BlockNative.sol";

contract RequestBlockNativeNFT is Script {
    address private blockNativeAddress =
        0x5FbDB2315678afecb367f032d93F642f64180aa3;

    function run() external {
        requestBlockNativeNFT(blockNativeAddress);
    }

    function requestBlockNativeNFT(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        BlockNative(mostRecentlyDeployed).requestNft();
        vm.stopBroadcast();

        console.log("Requested an NFT");
    }
}

contract BNTokenURI is Script {
    address private blockNativeAddress =
        0x5FbDB2315678afecb367f032d93F642f64180aa3;
    uint256 private tokenId;

    function run() external {
        tokenId = 0;
        blockNativeTokenUri(tokenId, blockNativeAddress);
    }

    function blockNativeTokenUri(
        uint256 tokenid,
        address mostRecentlyDeployed
    ) public {
        vm.startBroadcast();
        string memory tokenUri = BlockNative(mostRecentlyDeployed).tokenURI(
            tokenid
        );
        vm.stopBroadcast();
        console.log("Token URI: ", tokenUri);
    }
}
