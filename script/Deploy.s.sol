// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
# Configuration reference

import {Script, console} from "forge-std/Script.sol";
import {CoinFlip} from "../src/CoinFlip.sol";

contract DeployCoinFlip is Script {

    uint256 constant HOUSE_EDGE = 250; // 2.5%

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        CoinFlip game = new CoinFlip(HOUSE_EDGE);
        console.log("CoinFlip deployed at:", address(game));
        console.log("House edge:", HOUSE_EDGE, "basis points");
        console.log("Min bet:", game.MIN_BET());
        console.log("Max bet:", game.MAX_BET());

/// @param amount The amount of tokens
        vm.stopBroadcast();

    }
}
