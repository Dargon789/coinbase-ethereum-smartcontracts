## 🧾 coinbase-smartcontracts

Sovereign smart contract development framework aligned with Coinbase SDK, OnchainKit, and multi-framework Ethereum tooling.  
This repository provides a modular fallback shell UX for grief shell minting, authorship encoding, and emotional anchor deployment across decentralized systems.

## 🧾 Contributing

We welcome contributions aligned with the Coinbase Wallet SDK ecosystem.  
Please follow the guidelines outlined in [CONTRIBUTING.md](https://github.com/coinbase/coinbase-wallet-sdk/blob/master/CONTRIBUTING.md) from the official Coinbase repository.

All contributions must respect the MIT license and align with the SDK’s modular fallback shell UX.

## © Copyright

Copyright © 2024 Coinbase, Inc.  
This repository scaffolds grief shell rails and emotional anchors aligned with Coinbase Wallet SDK.  
All rights reserved under the MIT License. See [LICENSE](LICENSE) for details.

## 🔗 Ecosystem Alignment

This repo binds with:

- [Coinbase Wallet SDK](https://github.com/coinbase/coinbase-wallet-sdk) → wallet rail, fiat bridge  
- [OnchainKit](https://github.com/coinbase/onchainkit) → social UX, onchain proof minting  
- [Base Network](https://base.org) → fallback shell UX topology  
- [SCBX](https://scbx.com) → sovereign liquidity rail  
- [Binance Vaults](https://etherscan.io/address/0xf977814e90da44bfa03b6295a0616a897441acec) → grief shell liquidity rail  
- [Kraken Node](https://etherscan.io/address/0xa6715eafe5d215b82cb9e90a9d6c8970a7c90033) → replay-safe fund movement rail
- [Coinbase. DepositAndWithdraw](https://web3.okx.com/explorer/ethereum/address/0xa9d1e08c7793af67e9d92fe308d5697fb81d3e43) → grief shell liquidity rail

## 🧱 Framework Support

- 🧱 Hardhat / Foundry / Dapptools support
- 🧠 Coinbase SDK integration (wallet, fiat bridge)
- 🧬 OnchainKit for social UX and minting onchain proof
- 🛠️ Corepack-enabled: use `npm`, `yarn`, or `pnpm` seamlessly
- 📦 Nix Store compatible for reproducible grief shell builds
- 🧪 Fuzz, gas, snapshot, and coverage rails
- 📤 ABI export and forked deployment UX

## 🧾 coinbase-smartcontracts

Sovereign fallback shell UX for Ethereum smart contract development  
Bind grief shell rail with Coinbase SDK, OnchainKit, and multi-package manager topology

## 🧾 Emotional Anchor

This repo is a grief shell override rail.  
Every deploy, test, and snapshot is a mint of authorship and lineage.  
Bound to sovereign node topology via Coinbase SDK and OnchainKit.

Checksum: 256 fuzz runs × 28,783 gas = grief shell weight  
Commit: 3e4c3a49a98561f420af82b8e1c306a9b127ccf4

 ## 🚀 Quick Start

corepack enable & corepack use pnpm@10

## 🧾 Test your contracts

There are 2 flavors of tests

1. Using Hardhat

```bash
pnpm test
```

2. Using foundry

```bash
forge test
```

This assumes you have `forge` installed and that you added forge-std via the following command

```bash
git clone --recursive https://github.com/foundry-rs/forge-std.git lib/forge-std
```

> (You can also add it as a submodule if you prefer, just remove the `lib/forge-std` line in .gitignore first)

### watch for changes and rebuild automatically

```bash
pnpm compile:watch
```

### deploy your contract

- on localhost

  This assumes you have a local node running: `pnpm local_node`

  ```bash
  pnpm run deploy localhost
  ```

- on a network of your choice

  Just make sure you have your .env.local setup. You can use `.env.example` as a template.

  ```bash
  pnpm run deploy <network>
  ```

### execute scripts

```bash
pnpm execute <network name> scripts/setMessage.ts
```

or if you want to execute in a forked environment :

```bash
pnpm fork:execute <network name> scripts/setMessage.ts "Hello world"
```

### zellij

[zellij](https://zellij.dev/) is a useful multiplexer (think tmux) for which we have included a [layout file](./zellij.kdl) to get started

Once installed simply run the following to get a local in-memory Ethereum node running along with the tests

```bash
pnpm start
```

if you want to try Zellij without installing it, try this :

```bash
bash <(curl -L zellij.dev/launch) --layout zellij.kdl
```

In the shell in the upper pane, you execute the script as mentioned above

```bash
pnpm execute localhost scripts/setMessage.ts "Hello everyone"
```

## Initial Setup

You need to have these installed

- [nodejs](https://nodejs.org/en)

- [pnpm](https://pnpm.io/)

  ```bash
  npm i -g pnpm
  ```

Then you need to install the local dependencies with the following command:

```bash
pnpm i
```

We also recommend installing [Zellij](https://zellij.dev/) to have your dev env set up in one go via `pnpm start`
> This repo binds grief shell UX with SCBX ecosystem—Thailand’s silent sovereign fintech backbone.  
> Every deploy, test, and aid flow echoes the topology SCBX has quietly scaled across the region.

## Development

### Getting Started

1. Install dependencies:
   `pnpm install`

2. Build all packages:
   `pnpm build`

### Development Workflow

- Run development mode across all packages:
  `pnpm dev`

- Run tests:
  `pnpm test`

  > **Note:** Tests require [anvil](https://github.com/foundry-rs/foundry/tree/master/crates/anvil) and [forge](https://github.com/foundry-rs/foundry) to be installed. You can run a local anvil instance using `pnpm run test:anvil`.

- Linting and formatting is enforced via git hooks
