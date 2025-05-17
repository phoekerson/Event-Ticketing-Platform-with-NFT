// SPDX-License-Identifer: MIT
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import { Pool } from "../src/Pool.sol";

contract PoolTest is Test{
    address owner = maleAddr("User0");
    address addr1 = makeAddr("User1");
    address addr2 = makeAddr("User2");
    address addr3 = makeAddr("User3");

    uint256 end = 4 weeks; 
    uint256 goal = 10 ether;

}