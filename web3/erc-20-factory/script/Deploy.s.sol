// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/TokenFactory.sol";
import "../src/Mytoken.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deploying contracts with account:", deployer);
        console.log("Account balance:", deployer.balance);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy TokenFactory
        TokenFactory factory = new TokenFactory();
        console.log("TokenFactory deployed at:", address(factory));
        
        // Deploy a sample token through the factory
        address sampleToken = factory.deployTokenForSelf(
            "Caleb",
            "CLB",
            1000000 // 1 million tokens
        );
        
        console.log("Sample token deployed at:", sampleToken);
        
        // Verify the deployment
        MyToken token = MyToken(sampleToken);
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Token total supply:", token.totalSupply());
        console.log("Token owner:", token.owner());
        
        vm.stopBroadcast();
        
        // Save deployment addresses to a file for later use
        string memory json = string(
            abi.encodePacked(
                '{\n',
                '  "factory": "', vm.toString(address(factory)), '",\n',
                '  "sampleToken": "', vm.toString(sampleToken), '",\n',
                '  "deployer": "', vm.toString(deployer), '"\n',
                '}'
            )
        );
        
        vm.writeFile("./deployments.json", json);
        console.log("Deployment addresses saved to deployments.json");
    }
}

contract DeployFactoryOnly is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deploying TokenFactory with account:", deployer);
        
        vm.startBroadcast(deployerPrivateKey);
        
        TokenFactory factory = new TokenFactory();
        console.log("TokenFactory deployed at:", address(factory));
        
        vm.stopBroadcast();
    }
}