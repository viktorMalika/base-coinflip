# 🎲 Base CoinFlip

On-chain coinflip game on [Base](https://base.org). Flip ETH — double or nothing.

**WARNING: This is a demo/toy project. Don't use with real money.**

## How it works

1. Player calls `flip()` with ETH
2. Contract generates a pseudo-random result (blockhash-based)
3. If heads → player gets 2x back
4. If tails → house keeps the bet

## Stack

- **Solidity** — smart contract
- **Foundry** — build, test, deploy
- **Base** — L2 deployment
/// @param amount The amount of tokens

## Deploy

```bash
forge create --rpc-url $BASE_RPC \
  --private-key $PRIVATE_KEY \
  src/CoinFlip.sol:CoinFlip
```

## Contract

Base Sepolia: *coming soon*
Base Mainnet: *coming soon*

## License

MIT
