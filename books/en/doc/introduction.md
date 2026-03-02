<!-- ja-source-hash: 5ce0603c094beed98e9d2948f7728f13f3226b52 -->
> Japanese version: /ja/doc/introduction.html

# What is Kasane

## TL;DR
Kasane is a project that provides EVM execution on ICP canisters.  
It exposes two public access paths: the canister Candid API and a Gateway JSON-RPC endpoint.  
Its JSON-RPC is not full Ethereum compatibility; it is a restricted compatibility layer for development workflows.  
The compatibility target is Ethereum JSON-RPC plus EVM execution semantics, while OP/Superchain compatibility is out of scope.

## What You Can Do
- Use Ethereum-style JSON-RPC for basic reads and transaction submission
- Call EVM functionality directly through canister query/update methods
- Pull `export_blocks` in an indexer and persist data to Postgres

## Key Constraints (Current Implementation)
- Ethereum JSON-RPC compatibility is partial (see compatibility pages for unsupported methods)
- Node operation workflows are out of scope for this book

## Compatibility Positioning
- Explicit target: restricted Ethereum JSON-RPC compatibility
- Non-goal: OP Stack / Superchain compatibility
- Important: success of `eth_sendRawTransaction` means submit success only; execution success must be checked with receipt `status=0x1`

## Intended Readers
- EVM dApp developers
- Smart contract developers
- Backend integration developers
- Indexer developers

## Sources
- `README.md` (operational summary and compatibility policy)
- `tools/rpc-gateway/README.md` (Gateway compatibility matrix)
- `crates/ic-evm-wrapper/evm_canister.did` (public interface)

## Source of Truth for Compatibility
- Canonical JSON-RPC policy: `./rpc/overview.md`
- Detailed method differences: `./compatibility/json-rpc-deviations.md`
