#!/usr/bin/env python3

"""
Legacy ERP -> ERPNext migration preprocessing.

Cleans synthetic CSV exports before transformation and import into ERPNext.

Usage:
    python clean_legacy_data.py input.csv output.csv
"""

import argparse
import re
from pathlib import Path

import pandas as pd


def normalize_column_name(column: str) -> str:
    """Convert legacy column names to predictable snake_case."""
    column = column.strip().lower()
    column = re.sub(r"[^a-z0-9]+", "_", column)
    return column.strip("_")


def clean_text(value):
    """Trim text and normalize whitespace."""
    if pd.isna(value):
        return value

    if isinstance(value, str):
        return re.sub(r"\s+", " ", value).strip()

    return value


def clean_dataframe(df: pd.DataFrame) -> pd.DataFrame:
    """Apply baseline migration-data quality rules."""

    # Normalize field names.
    df.columns = [normalize_column_name(column) for column in df.columns]

    # Remove completely empty rows and columns.
    df = df.dropna(axis=0, how="all")
    df = df.dropna(axis=1, how="all")

    # Remove duplicate records.
    df = df.drop_duplicates()

    # Normalize string values.
    for column in df.select_dtypes(include=["object", "string"]).columns:
        df[column] = df[column].map(clean_text)

    # Convert common representations of missing data to null.
    missing_values = {
        "": pd.NA,
        "N/A": pd.NA,
        "n/a": pd.NA,
        "NA": pd.NA,
        "null": pd.NA,
        "NULL": pd.NA,
        "None": pd.NA
    }

    df = df.replace(missing_values)

    return df


def main():
    parser = argparse.ArgumentParser(
        description="Clean legacy ERP CSV data for ERPNext migration."
    )

    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)

    args = parser.parse_args()

    if not args.input.exists():
        raise FileNotFoundError(f"Input file not found: {args.input}")

    df = pd.read_csv(args.input)

    original_rows = len(df)

    cleaned_df = clean_dataframe(df)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    cleaned_df.to_csv(args.output, index=False)

    print("Legacy ERP data cleaning complete")
    print(f"Input rows:  {original_rows}")
    print(f"Output rows: {len(cleaned_df)}")
    print(f"Output file: {args.output}")


if __name__ == "__main__":
    main()
