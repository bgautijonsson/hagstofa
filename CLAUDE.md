# hagstofa -- CLAUDE.md

R package for downloading data from Statistics Iceland (Hagstofa) via the px API.

## Commands

```r
devtools::load_all()      # Load for interactive testing
devtools::document()      # Regenerate NAMESPACE + man/
devtools::check()         # R CMD check
```

## Exported functions (3)

| Function           | Purpose                                           |
| ------------------ | ------------------------------------------------- |
| `hg_data(url)`     | Create a lazy hagstofa object from a px API URL   |
| `collect(x)`       | S3 method to download data from a hagstofa object |
| `hg_list_tables()` | Interactive gt table of all available datasets    |

## Architecture

- `R/list_tables.R` -- `hg_list_tables()` and `hg_data()` (creates S3 class `.hagstofa`)
- `R/utils.R` -- `collect.hagstofa()`, `download_data()`, `download_large_data()` (splits queries >5000 rows)
- `man/` -- auto-generated roxygen2 docs
- No tests directory yet

## Dependencies

**Imports:** dplyr, gt, pxweb, readr

## Key design

- Uses lazy evaluation: `hg_data()` returns a `.hagstofa` S3 object, `collect()` triggers the download
- Large datasets (>5000 rows) are automatically split into smaller queries and reassembled
- All data comes from `px.hagstofa.is` API

## Development status

- Version: 0.0.1
- Tests: none
- CI: GitHub Actions R-CMD-check
- GitHub: bgautijonsson/hagstofa
- Used by external users
