// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.14;

contract DeploySetting {
    struct DeployParameters {
        address link3Owner; // sets nft descriptor
        address link3Signer; // signs for profile registration
        address link3Treasury; // collect registration fees
        address engineAuthOwner; // sets role auth role and cap
        address engineGov; // engine gov to create namespace
        address engineTreasury; // collect protocol fees
        address deployerContract; // used to deploy contracts
    }

    DeployParameters internal deployParams;

    function _setDeployParams() internal {
        // Anvil accounts
        // (0) 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 (10000 ETH)
        // (1) 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 (10000 ETH)
        // (2) 0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc (10000 ETH)

        // Testnet accounts
        // deployer: 0x927f355117721e0E8A7b5eA20002b65B8a551890
        // engine treasury: 0x1890a1625d837A809b0e77EdE1a999a161df085d
        // link3 treasury + signer: 0xaB24749c622AF8FC567CA2b4d3EC53019F83dB8F
        if (block.chainid == 31337) {
            // use the same address that runs the deployment script
            deployParams.link3Owner = address(
                0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            );
            deployParams.link3Signer = address(
                0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            );
            deployParams.link3Treasury = address(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8 // use different wallet to pass balance delta check
            );
            deployParams.engineAuthOwner = address(
                0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            );
            deployParams.engineGov = address(
                0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            );
            deployParams.engineTreasury = address(
                0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC // use different wallet to pass balance delta check (gas paying)
            );
            deployParams.deployerContract = address(0);
        } else if (block.chainid == 5) {
            deployParams.link3Owner = address(
                0x927f355117721e0E8A7b5eA20002b65B8a551890
            );
            deployParams.link3Signer = address(
                0xaB24749c622AF8FC567CA2b4d3EC53019F83dB8F
            );
            deployParams.link3Treasury = address(
                0xaB24749c622AF8FC567CA2b4d3EC53019F83dB8F
            );
            deployParams.engineAuthOwner = address(
                0x927f355117721e0E8A7b5eA20002b65B8a551890
            );
            deployParams.engineGov = address(
                0x927f355117721e0E8A7b5eA20002b65B8a551890
            );
            deployParams.engineTreasury = address(
                0x1890a1625d837A809b0e77EdE1a999a161df085d
            );
            deployParams.deployerContract = address(0);
        } else if (block.chainid == 4) {
            deployParams.link3Owner = address(
                0x927f355117721e0E8A7b5eA20002b65B8a551890
            );
            deployParams.link3Signer = address(
                0xaB24749c622AF8FC567CA2b4d3EC53019F83dB8F
            );
            deployParams.link3Treasury = address(
                0xaB24749c622AF8FC567CA2b4d3EC53019F83dB8F
            );
            deployParams.engineAuthOwner = address(
                0x927f355117721e0E8A7b5eA20002b65B8a551890
            );
            deployParams.engineGov = address(
                0x927f355117721e0E8A7b5eA20002b65B8a551890
            );
            deployParams.engineTreasury = address(
                0x1890a1625d837A809b0e77EdE1a999a161df085d
            );
            deployParams.deployerContract = address(
                0xe19061D4Dd38ac3B67eeC28E90bdFB68065DbF7c
            );
        }
    }
}
