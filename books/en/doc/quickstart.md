<!-- ja-source-hash: 289d5bfb1ca2ad51a4e0157d3f56db1988918bd5 -->
> Japanese version: /ja/doc/quickstart.html

# Quickstart (Gateway + Candid)

## TL;DR
- Default network is public testnet (`chain_id=4801360`, RPC: `https://rpc-testnet.kasane.network`).
- There are two paths: Path A (Gateway JSON-RPC) / Path B (direct canister Candid).
- Do not use submit response as final success signal; use `eth_getTransactionReceipt.status`.
- `tx_id` and `eth_tx_hash` are different identifiers.
- For deploy/call, standardize on signed raw-tx submission flow.

## What You Can / Cannot Do

### You Can
- Verify connectivity (chain id / block number)
- Send native transfers (submit signed raw tx)
- Monitor receipt (success/failure)
- Read state via query methods (balance/code/storage/call/estimate)

### You Cannot (Current)
- Use Ethereum-standard pending/mempool workflows (`eth_pendingTransactions`, etc.)
- Note: with direct canister calls, per-transaction tracking is possible via `get_pending(tx_id)`
- Use WebSocket subscriptions (`eth_subscribe`)
- Use full-compatible `eth_getLogs` (filter constraints apply)

For compatibility details, see `./rpc/overview.md` and `./compatibility/json-rpc-deviations.md`.

---
## Prerequisites
- Public RPC: `https://rpc-testnet.kasane.network`
- chain id: `4801360`
- canister id (current testnet value): `4c52m-aiaaa-aaaam-agwwa-cai`
- `dfx` (if using canister query/update path)
- Signed raw tx if sending through Gateway

---

## Path A: Gateway JSON-RPC

### 1) Connectivity Check
```bash
RPC_URL="https://rpc-testnet.kasane.network"

curl -s -X POST "$RPC_URL" -H 'content-type: application/json' \
  --data '{"jsonrpc":"2.0","id":1,"method":"eth_chainId","params":[]}'

curl -s -X POST "$RPC_URL" -H 'content-type: application/json' \
  --data '{"jsonrpc":"2.0","id":2,"method":"eth_blockNumber","params":[]}'
```

Expected:
- `eth_chainId` returns `0x4944d0` (decimal `4801360`)
- `eth_blockNumber` returns a `0x...` value

### 2) Transfer (Signed Raw Tx)
```bash
RAW_TX="0x<signed_raw_tx_hex>"

curl -s -X POST "$RPC_URL" -H 'content-type: application/json' \
  --data "{\"jsonrpc\":\"2.0\",\"id\":3,\"method\":\"eth_sendRawTransaction\",\"params\":[\"$RAW_TX\"]}"
```

Expected:
- `result` returns `0x...` tx hash (Gateway resolves `tx_id` to `eth_tx_hash`)

### 3) Receipt Monitoring (Success Determination)
```bash
TX_HASH="0x<tx_hash_from_send>"

curl -s -X POST "$RPC_URL" -H 'content-type: application/json' \
  --data "{\"jsonrpc\":\"2.0\",\"id\":4,\"method\":\"eth_getTransactionReceipt\",\"params\":[\"$TX_HASH\"]}"
```

Interpretation:
- `status == 0x1`: execution succeeded
- `status == 0x0`: execution failed (submit can succeed while execution fails)
- `result == null`: not yet mined/included

### Typical Errors
- `-32602 invalid params`: invalid argument format
- `-32001 resource not found`: pruned boundary or missing target
- `-32000 state unavailable`: migration/corrupt state, etc.

### Pitfalls
- Treating `eth_sendRawTransaction` success as completion
- Confusing `tx_id` with `eth_tx_hash`

---

## Path B: Direct canister Candid call

### 1) Connectivity Check (query)
```bash
CANISTER_ID="4c52m-aiaaa-aaaam-agwwa-cai"
NETWORK="ic"

dfx canister call --network "$NETWORK" --query "$CANISTER_ID" rpc_eth_chain_id '( )'
dfx canister call --network "$NETWORK" --query "$CANISTER_ID" rpc_eth_block_number '( )'
```

### 2) `submit_ic_tx` (IcSynthetic)
`submit_ic_tx` accepts a Candid `record` with:
- `to: opt vec nat8` (`Some` must be 20 bytes, `None` means create)
- `value: nat`
- `gas_limit: nat64`
- `nonce: nat64`
- `max_fee_per_gas: nat`
- `max_priority_fee_per_gas: nat`
- `data: vec nat8`

In `IcSynthetic`, payload does not include `from`.  
The wrapper injects `msg_caller()` and `canister_self()` and passes it to core as `TxIn::IcSynthetic` to derive sender.

```bash
# Example: to=0x...01 / value=0 / gas_limit=500000 / data=""
# Note: set fee at or above current minimum acceptance conditions (min_gas_price/min_priority_fee).
TO_BYTES="$(python - <<'PY'
to = bytes.fromhex('0000000000000000000000000000000000000001')
print('; '.join(str(b) for b in to))
PY
)"

dfx canister call --network "$NETWORK" "$CANISTER_ID" submit_ic_tx "(record {
  to = opt vec { $TO_BYTES };
  value = 0 : nat;
  gas_limit = 500000 : nat64;
  nonce = 0 : nat64;
  max_fee_per_gas = 500000000000 : nat;
  max_priority_fee_per_gas = 250000000000 : nat;
  data = vec { };
})"
```

### 2.0) `submit_ic_tx` Send Procedure
Fixing this order reduces operational mistakes.

1. Verify chain/network before sending  
   - Ensure `rpc_eth_chain_id` is `4801360`
2. Check sender nonce  
   - Call `expected_nonce_by_address(20 bytes)` and get current nonce
3. Decide fee/gas  
   - Refer to `rpc_eth_gas_price` / `rpc_eth_max_priority_fee_per_gas`; set values at or above minimum
4. Send `submit_ic_tx(record)` once  
   - Store returned `tx_id`
5. Track execution result  
   - Check status with `get_pending(tx_id)`
   - Once `get_receipt(tx_id)` is available, determine success/failure by `status`

Notes:
- `submit_ic_tx` success means "accepted". Determine execution success from `receipt.status`.
- `tx_id` is an internal key and different from `eth_tx_hash`.

### 2.1) `submit_ic_tx` Validation Flow (Important)
- pre-submit guard
  - reject anonymous (`auth.anonymous_forbidden`)
  - reject writes during migration/cycle state (`ops.write.*`)
- decode/validation
  - payload size/format
  - sender derivation failure: `arg.principal_to_evm_derivation_failed`
  - invalid fee condition: `submit.invalid_fee`
  - nonce mismatch: `submit.nonce_too_low` / `submit.nonce_gap` / `submit.nonce_conflict`
- on success, returns `tx_id`; mining is asynchronous (`auto-production`)

### 3) Nonce Retrieval
```bash
ADDR_BLOB='"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"'
dfx canister call --network "$NETWORK" --query "$CANISTER_ID" expected_nonce_by_address "(blob $ADDR_BLOB)"
```

Notes:
- `expected_nonce_by_address` accepts only 20-byte addresses
- 32-byte input (for example mistaken bytes32-encoded principal) returns an explicit error

### 4) Raw tx submission (EthSigned)
Use existing helper `eth_raw_tx` to create raw tx bytes:
```bash
CHAIN_ID=4801360
PRIVKEY="<YOUR_PRIVKEY_HEX>"
RAW_TX_BYTES=$(cargo run -q -p ic-evm-core --features local-signer-bin --bin eth_raw_tx -- \
  --mode raw \
  --privkey "$PRIVKEY" \
  --to "0000000000000000000000000000000000000001" \
  --value "0" \
  --gas-price "500000000000" \
  --gas-limit "21000" \
  --nonce "0" \
  --chain-id "$CHAIN_ID")

dfx canister call --network "$NETWORK" "$CANISTER_ID" rpc_eth_send_raw_transaction "(vec { $RAW_TX_BYTES })"
```

### 5) `tx_id` Tracking (IcSynthetic)
`submit_ic_tx` returns internal key `tx_id`, not `eth_tx_hash`.  
Track with:
- `get_pending(tx_id)` (`Queued/Included/Dropped/Unknown`)
- `get_receipt(tx_id)` (execution result)

### 6) `eth_sendRawTransaction` Return Caveat (Gateway)
- Normally returns `eth_tx_hash`.
- But if internal `tx_id -> eth_tx_hash` resolution fails, returns `-32000` (`submit succeeded but eth hash is unavailable`).

### Pitfalls
- Calling query methods as update and failing
- Violating 20-byte address requirement (`expected_nonce_by_address`)
- Treating `submit_ic_tx` `tx_id` as `eth_tx_hash`
- Treating `submit_ic_tx` success as execution success

---

## Deploy & Call (Operational Procedure)

### Prerequisites
- Bytecode has been built (`data` field set to deploy bytecode)
- Signing environment is ready (private key / matching chain id)
- Nonce and fee are pre-fetched and configured

### Execution Flow
1. Estimate deploy tx gas using `eth_estimateGas`.
2. Build deploy raw tx and submit via `eth_sendRawTransaction`.
3. Track returned `eth_tx_hash` with `eth_getTransactionReceipt`.
4. Confirm deployed address appears in `receipt.contractAddress`.

---

## Sources
- `README.md`
- `tools/rpc-gateway/README.md`
- `docs/api/rpc_eth_send_raw_transaction_payload.md`
- `crates/evm-core/src/test_bin/eth_raw_tx.rs`
- `crates/ic-evm-wrapper/evm_canister.did`
- `tools/rpc-gateway/src/handlers.ts`
- `crates/ic-evm-wrapper/src/lib.rs` (`submit_ic_tx`, `expected_nonce_by_address`)
- `crates/evm-core/src/chain.rs` (`TxIn::IcSynthetic`, submit validation)
