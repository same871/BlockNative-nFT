// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BlockNative} from "../src/BlockNative.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployBlockNativeNFT is Script {
    string[] private tokenURIs = [
        "ipfs://QmfGvc9JynDLxTY41XA6b8598XvcqEBuCDmmjF4W6pqXr2",
        "ipfs://Qmf3wUfzX8jXrK7DHBXS4ZdSVmeouJcyLtxpJJrNjCRVyB",
        "ipfs://QmdsMpGt2SzsS1zBfshXusXt4sEv27eVFT4WtEYpAF2ULk"
    ];

    function run() external returns (BlockNative, string[] memory) {
        HelperConfig helperConfig = new HelperConfig();
        uint256 deployerKey = helperConfig.activeNetwork();
        vm.startBroadcast(deployerKey);
        BlockNative bn = new BlockNative(tokenURIs);
        vm.stopBroadcast();
        return (bn, tokenURIs);
    }
}
