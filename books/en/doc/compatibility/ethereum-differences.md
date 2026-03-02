<!-- ja-source-hash: fdc3ebd3e8dcebb5ed0fc4987378787dddbb264b -->
> Japanese version: /ja/doc/compatibility/ethereum-differences.html

# Ethereum Differences

## TL;DR
- Compatibility target is Ethereum JSON-RPC plus EVM execution semantics (not full parity).
- Accepted tx types: Legacy / EIP-2930 / EIP-1559. EIP-4844 and EIP-7702 are currently rejected.
- Kasane does not add or override opcodes; it follows the active `revm` spec (currently PRAGUE).
- Some pending/mempool APIs are not implemented (`eth_pendingTransactions`, etc.).
- The canister Candid API provides per-transaction tracking via `get_pending(tx_id)`.
- The runtime assumes a single block producer (sequencer), not a reorg-driven model.

Note: the canonical pending/mempool policy is `../rpc/overview.md`.

## Scope

### Supported
- Submit, execute, and read receipts for Ethereum-signed transactions
- `eth_call` / `eth_estimateGas` (with restrictions)
- Read blocks/transactions/receipts/logs

### Restricted Areas
- 4844 blob tx / 7702 authorization tx are currently unsupported
- mempool, filter, and WebSocket subscriptions are partially supported or unsupported

## Transaction Compatibility
- Supported
  - Legacy (RLP)
  - EIP-2930 (`tx_type=1`)
  - EIP-1559 (`tx_type=2`)
- Currently rejected
  - EIP-4844 (`type=0x03`)
  - EIP-7702 (`type=0x04`)

## Opcode Differences
- Kasane does not introduce custom opcode behavior.
- Effective opcode set depends on `revm` spec selection; current default is `PRAGUE`.

## Fee Model Differences
- `base_fee` is persisted and updated by `compute_next_base_fee`.
- `effective_gas_price` is derived from `max_fee`, `max_priority_fee`, and `base_fee`.
- `eth_gasPrice` returns `max(base_fee + max(estimated_priority, min_priority), min_gas_price)`.

## Finality/Reorg Differences
- Assumes a single block producer (sequencer).
- Blocks after `auto-production` are treated as final.
- Some tags such as `latest/pending/safe/finalized` effectively map to head-level behavior.

## Common Errors
- `DecodeError::UnsupportedType` (4844/7702)
- `DecodeError::WrongChainId`
- `DecodeError::LegacyChainIdMissing`

## Pitfalls
- Assuming Ethereum L1 pending/finality behavior applies as-is
- Sending 4844/7702 tx assuming compatibility

## Sources
- `crates/evm-core/src/tx_decode.rs`
- `crates/evm-core/tests/phase1_eth_decode.rs`
- `crates/evm-core/src/base_fee.rs`
- `crates/evm-core/src/revm_exec.rs`
- `vendor/revm/crates/handler/src/mainnet_builder.rs`
- `vendor/revm/crates/primitives/src/hardfork.rs`
- `tools/rpc-gateway/README.md`
- `README.md`
