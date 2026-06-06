// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title CoinFlip
/// @notice On-chain coinflip game. Double or nothing.
/// @dev Uses blockhash for pseudo-randomness — NOT safe for production.
contract CoinFlip {
    address public owner;
    uint256 public totalFlips;
    uint256 public totalWagered;
    uint256 public totalPaidOut;
    uint256 public houseEdge; // basis points (e.g., 250 = 2.5%)

    uint256 public constant MAX_BET = 0.1 ether;
    uint256 public constant MIN_BET = 0.001 ether;

    event Flipped(
        address indexed player,
        uint256 amount,
        bool won,
        uint256 payout
    );

    error BetTooLow();
    error BetTooHigh();
    error InsufficientBalance();
    error TransferFailed();

    constructor(uint256 _houseEdge) {
        owner = msg.sender;
        houseEdge = _houseEdge;
    }

    /// @notice Flip a coin. Send ETH with this call.
    function flip() external payable {
        if (msg.value < MIN_BET) revert BetTooLow();

        if (msg.value > MAX_BET) revert BetTooHigh();
        if (address(this).balance < msg.value) revert InsufficientBalance();

        totalFlips++;
        totalWagered += msg.value;

        // Pseudo-random: blockhash + sender + nonce
        uint256 randomness = uint256(
            keccak256(
                abi.encodePacked(
                    blockhash(block.number - 1),
                    msg.sender,
                    totalFlips,
                    block.timestamp
                )
            )
        );

        bool won = (randomness % 2) == 0;

        if (won) {
            // Payout = bet * 2 minus house edge
            uint256 payout = (msg.value * 2 * (10000 - houseEdge)) / 10000;
            totalPaidOut += payout;

            emit Flipped(msg.sender, msg.value, true, payout);

            (bool sent, ) = msg.sender.call{value: payout}("");
            if (!sent) revert TransferFailed();
        } else {
            emit Flipped(msg.sender, msg.value, false, 0);
        }
    }

    /// @notice Withdraw house profits. Only owner.
    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "not owner");
        (bool sent, ) = owner.call{value: amount}("");
        require(sent, "withdraw failed");
    }

    /// @notice Fund the contract so it can pay out wins.
    receive() external payable {}

    /// @notice Check contract balance.
    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}
