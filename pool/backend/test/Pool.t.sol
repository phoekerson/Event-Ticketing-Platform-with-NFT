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

    //contribute 
    function test_RevertWhen_EndIsReached() public {
        vm.warp(pool.end() + 3600);
        bytes4 selector = bytes4(keccak256
        ("CollectIsFinished()"));
        vm.expectRevert(abi.encodeWithSelector(selector));

        vm.prank(addr1);
        vm.deal(addr1, 1 ether);
        pool.contribute{value: 1 ether}();
    }

    function test_RevertWhen_NotEnoughFunds() public{
        bytes4 selector = bytes4(keccak256
        ("NotEnoughFunds()"));
        vm.expectRevert(abi.encodeWithSelector
        (selector));

        vm.prank(addr1);
        pool.contribute();
    }

    function test_ExpectEmit_SuccessfullContribute (uint96 _amount) public{
            vm.assume(_amount > 0);
            vm.expectEmit(true, false, false, true);
            emit Pool.Contribute(address(addr1), _amount);
            vm.prank(addr1);
            vm.deal(addr1, _amount);
            pool.contribute{value: _amount}();
    }

    

    function test_RevertWhen_NotTheOwner() public{
        bytes4 selector = bytes4(keccak256("OwnableUnauthorizedAccount(address)"));
        vm.expectRevert(abi.encodeWithSelector(selector, addr1));

        vm.prank(addr1);
        pool.withdraw();
    }

    function test_RevertWhen_EndIsNotReached() public{
        bytes4 selector = bytes4(keccak256
        ("CollectNotFinished()"));
        vm.expectRevert(abi.encodeWithSelector
        (selector));
        vm.prank(owner);
        pool.withdraw();

    }


}