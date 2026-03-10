<!-- ja-source-hash: 77ece8c2911767e81f7bf3caac53d7cebce79734 -->
> Japanese version: /ja/doc/concepts/finality-reorg.html

# Finality & Reorg

## TL;DR
- Current implementation assumes a single block producer (sequencer), not a reorg-first model.
- Submit and execute are separated, so receipt monitoring is required.

## Behavior
- `eth_sendRawTransaction` submits tx
- Execution finality appears in subsequent blocks

## Cautions
- Treating submit success as state finality
- Bringing Ethereum L1 fork/reorg assumptions directly into integration logic

## Sources
- `README.md`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-gateway/src/lib.rs`
