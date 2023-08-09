// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBlockNativeNFT} from "../script/DeployBlockNativeNFT.s.sol";

contract DeployBlockNativeTest is Test {
    DeployBlockNativeNFT deployer;

    function setUp() public {
        deployer = new DeployBlockNativeNFT();
    }

    function testRunFunction() public {
        deployer.run();
    }
}
