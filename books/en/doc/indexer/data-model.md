<!-- ja-source-hash: ff398ee97b4ed8f2db1fbfc47f3ee8da047dd727 -->
> Japanese version: /ja/doc/indexer/data-model.html

# Data Model

## TL;DR
- Indexer is Postgres-first.
- It stores entities such as `txs`, `receipts`, `token_transfers`, and `ops_metrics_samples`.

## Key Points
- `receipt_status` is stored on `txs`
- token transfers are extracted from receipt logs

## Sources
- `tools/indexer/README.md`
- `tools/indexer/src/db.ts`
