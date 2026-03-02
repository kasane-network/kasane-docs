<!-- ja-source-hash: 6784ae714b595d76ad801037a481d1b9c8186731 -->
> Japanese version: /ja/doc/contracts/solidity-vyper-compatibility.html

# Solidity/Vyper Compatibility

## TL;DR
- As core EVM execution path, you can use `eth_call` / `eth_estimateGas` / `eth_sendRawTransaction`.
- For compatibility details, treat Gateway implementation and compatibility matrix as source of truth.

## Main Methods Available
- `eth_call`
- `eth_estimateGas`
- `eth_sendRawTransaction`

## References
- `tools/rpc-gateway/README.md`
- `crates/evm-core/src/tx_decode.rs`
