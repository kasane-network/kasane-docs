<!-- ja-source-hash: 918aedfe2125581c451236937463b3fbfcb19150 -->
> Japanese version: /ja/doc/integration/signing-nonce-retries.html

# Signing, Nonce, Retries

## TL;DR
- Always fetch nonce before submit.
- Ensure chain id matches `4801360`.
- After submit success, determine final result by polling receipt.

## Recommended Flow
1. Resolve sender address
2. Fetch nonce with `eth_getTransactionCount` or `expected_nonce_by_address`
3. Set fees (consider base fee + priority)
4. Submit via `eth_sendRawTransaction`
5. Poll `eth_getTransactionReceipt`

## Pitfalls
- Hard-coding nonce
- Resending on receipt timeout and causing nonce conflicts

## Sources
- `README.md`
- `tools/rpc-gateway/README.md`
- `crates/ic-evm-wrapper/src/lib.rs`
