<!-- ja-source-hash: fec876cd0f1511c4c94953861aa872a300cc36c6 -->
> Japanese version: /ja/doc/concepts/accounts-keys.html

# Accounts & Keys

## TL;DR
- Sender derivation path differs between `EthSigned` and `IcSynthetic`.
- `expected_nonce_by_address` assumes a 20-byte address.
- `IcSynthetic` does not take `from` in payload; sender is derived from caller context.

## What You Can Do
- Use sender recovered from Ethereum signed tx
- Use principal-derived sender (`IcSynthetic`)

## Constraint
- Treating bytes32-like values as 20-byte addresses is invalid.

## Difference Between `EthSigned` and `IcSynthetic`
- `EthSigned`
  - Recovers sender from signed raw tx
  - Includes chain id validation
- `IcSynthetic`
  - Wrapper injects `msg_caller()` and `canister_self()` and submits as `TxIn::IcSynthetic`
  - Payload has no `from`
  - Sender derivation failure yields `AddressDerivationFailed`-class errors

## Must-Know Points for `IcSynthetic`
- Input to `submit_ic_tx` is Candid `record` (`to/value/gas_limit/nonce/max_fee_per_gas/max_priority_fee_per_gas/data`)
- Canonical stored bytes use `to_flag(0/1)` representation
- Use `expected_nonce_by_address` for nonce
- Return value is `tx_id`, not `eth_tx_hash`
- Execution finality is decided from later block receipts, not submit return

## Safe Usage
1. Resolve the caller's 20-byte address
2. Fetch nonce via `expected_nonce_by_address`
3. Send `submit_ic_tx`
4. Track with `get_pending(tx_id)` / `get_receipt(tx_id)`

For canonical pending/mempool policy, see `../rpc/overview.md`.

## Pitfalls
- Submitting principal-encoded values directly as address
- Passing non-20-byte value to `expected_nonce_by_address`
- Treating `tx_id` as `eth_tx_hash`
- Treating submit success as execution success

## Sources
- `crates/ic-evm-wrapper/src/lib.rs` (`expected_nonce_by_address`)
- `crates/evm-core/src/tx_decode.rs` (`IcSynthetic` / `EthSigned`)
- `crates/evm-core/src/chain.rs` (`TxIn::IcSynthetic`)
- `README.md`
