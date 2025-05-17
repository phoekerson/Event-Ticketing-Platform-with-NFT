// SPDX-License-Identifer: MIT
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import { Pool } from "../src/Pool.sol";

contract PoolTest is Test{
    address owner = makeAddr("User0");
    address addr1 = makeAddr("User1");
    address addr2 = makeAddr("User2");
    address addr3 = makeAddr("User3");

    uint256 duration = 4 weeks; 
    uint256 goal = 10 ether;

    Pool pool;

    function setUp() public{
        vm.prank(owner);
        pool = new Pool(duration, goal);
    }

    function test_ContractDeployedSuccessfully()
    public {
        address _owner = pool.owner();
        assertEq(owner, _owner);
        uint256 _end = pool.end();
        assertEq(block.timestamp + duration, _end);
        uint256 _goal = pool.goal();
        assertEq(goal, _goal);
    }
}