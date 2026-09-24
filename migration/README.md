# Legacy ERP Data Migration

This directory contains reference implementation code for preparing legacy ERP
exports for migration to ERPNext.

## Migration Flow

Legacy ERP
→ CSV export
→ staging
→ data profiling
→ cleaning
→ field mapping
→ transformation
→ validation
→ ERPNext import
→ reconciliation

## Data Cleaning

`clean_legacy_data.py` performs baseline preprocessing including:

- column-name normalization
- whitespace normalization
- removal of empty records
- duplicate removal
- missing-value normalization

Example:

```bash
pip install pandas

python migration/scripts/clean_legacy_data.py \
  legacy-customers.csv \
  cleaned-customers.csv
