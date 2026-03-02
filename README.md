# Kasane Docs (mdBook)

This repository manages and publishes Kasane developer documentation with `mdBook`.

## Production Docs URL
- Root: https://kasane-network.github.io/kasane-docs/
- English: https://kasane-network.github.io/kasane-docs/en/
- Japanese: https://kasane-network.github.io/kasane-docs/ja/

## Repository Structure
- Japanese (source of truth): `books/ja/doc/**`
- English: `books/en/doc/**`
- Table of contents:
  - `books/ja/SUMMARY.md`
  - `books/en/SUMMARY.md`

## Local Build
```bash
scripts/docs/build_books.sh
```

Build outputs:
- `build/ja`
- `build/en`

## Local Preview (optional)
```bash
mdbook serve books/ja
mdbook serve books/en
```

## i18n Sync Check
```bash
scripts/docs/verify_i18n_sync.sh
```

Each English page must start with the matching Japanese source hash:
```md
<!-- ja-source-hash: <hash> -->
```

## Published URL Policy
- Japanese: `/ja/...`
- English: `/en/...`
- Root `/`: redirects to `/en/`

## CI / Pages
- Pages deploy workflow: `.github/workflows/pages-mdbook.yml`
- i18n sync check workflow: `.github/workflows/docs-i18n-check.yml`

## Notes
- Build artifacts are ignored by Git (`build/`, `public/` in `.gitignore`).
- See `CONTRIBUTING.md` for editing and translation workflow details.
