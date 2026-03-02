<!-- ja-source-hash: e9f52515d285bc1b61f4737323f47d4bbd4acf01 -->
> Japanese version: /ja/doc/indexer/resync-pagination-missing-data.html

# Resync, Pagination, Missing Data

## TL;DR
- Cursor format is fixed JSON of `block_number/segment/byte_offset`.
- On `Err.Pruned`, continue by correcting cursor position.

## Pitfalls
- Pruning progresses while indexer is down and causes history gaps
- Segment limit mismatch prevents recovery

## Sources
- `tools/indexer/README.md`
- `docs/specs/indexer-v1.md`
- `tools/indexer/src/config.ts`
