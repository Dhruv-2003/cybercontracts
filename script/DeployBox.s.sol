// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.14;

import "forge-std/Script.sol";
import { DeploySetting } from "./libraries/DeploySetting.sol";
import { LibDeploy } from "./libraries/LibDeploy.sol";

contract DeployScript is Script, DeploySetting {
    function run() external {
        _setDeployParams();
        vm.startBroadcast();
        LibDeploy.deployBox(
            vm,
            deployParams.deployerContract,
            deployParams.link3Owner,
            true
        );
        vm.stopBroadcast();
    }
}
