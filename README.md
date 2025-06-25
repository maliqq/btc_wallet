# Simplest BTC Wallet

A minimal Bitcoin wallet for the Bitcoin Signet network, supporting P2WPKH addresses, balance checking, and sending transactions with customizable fees.

---

## Features

- Generate and store a Bitcoin keypair (P2WPKH/bech32)
- Check wallet balance using the [mempool.space](https://mempool.space/signet/) API
- Send Bitcoin with fee control (proportional to transaction size)
- Simple CLI via [Thor](https://github.com/erikhuda/thor)
- Docker support for easy setup

---

## Prerequisites

- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)
- Ruby (if running outside Docker)

### Environment Variables

You can modify these in your environment or `.env` file:

```
BTC_WALLET_KEY_FILE=./priv/maliqq.key
MEMPOOL_API_BASE_ADDR=https://mempool.space/signet/api/
```

---

## Getting Started

### 1. Start the Shell

Open a shell in the app container:

```sh
docker compose run --rm app bash
```

### 2. Create a BTC Keypair

Generate a new P2WPKH (bech32) keypair:

```sh
bin/thor btc:create
```

This will save your private key to the path specified by `BTC_WALLET_KEY_FILE`.

### 3. Check Wallet Balance

Check your wallet's balance on the Signet network:

```sh
bin/thor btc:balance
```

### 4. Send Bitcoin

Send a specified amount (in satoshis) to a given address. You can optionally specify a fee (in sats):

```sh
bin/thor btc:send tb1... --amount <amount in sats> [--fee <fee in sats>]
```

If `--fee` is not specified, the wallet will estimate a proportional fee based on transaction size and a default fee rate.

---

## Notes

- This wallet is intended for educational and testing purposes on the Bitcoin Signet network.
- **Do not use with mainnet funds.**
- Make sure to back up your private key file securely.

---