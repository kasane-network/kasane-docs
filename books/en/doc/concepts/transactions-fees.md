<!-- ja-source-hash: d70133c0af32ac0334b3e64e9ef855eeb39cda41 -->
> Japanese version: /ja/doc/concepts/transactions-fees.html

# Transactions & Fees

## TL;DR
- Supported tx types: Legacy/2930/1559. 4844/7702 are unsupported.
- Fee model is base fee + priority fee (with constraints).

## Fee Model
- `compute_next_base_fee` updates next block base fee
- `compute_effective_gas_price` computes effective price

## Pitfalls
- Sending tx with mismatched chain id
- Violating priority/max fee consistency constraints

## Sources
- `crates/evm-core/src/tx_decode.rs`
- `crates/evm-core/src/base_fee.rs`
- `crates/evm-core/src/revm_exec.rs`
