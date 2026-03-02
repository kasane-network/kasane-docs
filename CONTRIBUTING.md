# Contributing

## Documentation structure
- Japanese source of truth: `books/ja/doc/**`
- English docs: `books/en/doc/**`
- Table of contents:
  - Japanese: `books/ja/SUMMARY.md`
  - English: `books/en/SUMMARY.md`

Do not edit the legacy top-level `doc/` directory. All docs changes must go to `books/ja` and `books/en`.

## Translation workflow (Japanese is source of truth)
1. Edit Japanese page in `books/ja/doc/**`.
2. Update corresponding English page in `books/en/doc/**`.
3. Recompute Japanese source hash and update the first line of the English page:
   `<!-- ja-source-hash: <hash> -->`

Example:
```bash
rel="compatibility/precompiles-system-contracts.md"
hash="$(git hash-object "books/ja/doc/$rel")"
sed -i '' "1s#^<!-- ja-source-hash: .* -->#<!-- ja-source-hash: ${hash} -->#" "books/en/doc/$rel"
```

4. Run validation:
```bash
scripts/docs/verify_i18n_sync.sh
```

## Build
```bash
scripts/docs/build_books.sh
```

## Pages URL policy
- Japanese: `/ja/...`
- English: `/en/...`
- Root `/`: redirect to `/en/`
