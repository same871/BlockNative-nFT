// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 deployerKey;
    }

    NetworkConfig public activeNetwork;
    uint256 public constant DEFAULT_ANVIL_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaConfig();
        } else {
            activeNetwork = getAnvilNetworkConfig();
        }
    }

    function getSepoliaConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({deployerKey: vm.envUint("PRIVATE_KEY")});
    }

    function getAnvilNetworkConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        return NetworkConfig({deployerKey: DEFAULT_ANVIL_KEY});
    }
}
