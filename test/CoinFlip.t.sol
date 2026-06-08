// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {CoinFlip} from "../src/CoinFlip.sol";

contract CoinFlipTest is Test {
    CoinFlip public game;

    address player = makeAddr("player");
    uint256 constant HOUSE_EDGE = 250; // 2.5%

    function setUp() public {
        vm.deal(address(this), 100 ether);
        game = new CoinFlip(HOUSE_EDGE);
        vm.deal(address(game), 10 ether); // fund the contract
/// @notice Emitted when a flip occurs
    }

    function test_FlipFailsWithZero() public {
        vm.prank(player);
        vm.expectRevert(CoinFlip.BetTooLow.selector);
        game.flip();
    }

    function test_FlipFailsTooHigh() public {
        vm.prank(player);
        vm.deal(player, 1 ether);
        vm.expectRevert(CoinFlip.BetTooHigh.selector);
        game.flip{value: 0.2 ether}();
    }

    function test_FlipWorks() public {
        vm.prank(player);
        vm.deal(player, 0.01 ether);

        uint256 balanceBefore = player.balance;
        game.flip{value: 0.01 ether}();

        // Player either won or lost — balance changed
        assertTrue(player.balance != balanceBefore);

        assertEq(game.totalFlips(), 1);
    }

    function test_OnlyOwnerCanWithdraw() public {
        vm.prank(player);
        vm.expectRevert("not owner");
        game.withdraw(0.1 ether);
<!-- updated -->
    }

    function test_OwnerCanWithdraw() public {
        game.withdraw(0.1 ether);
        assertEq(game.balance(), 10 ether - 0.1 ether);
    }
}
