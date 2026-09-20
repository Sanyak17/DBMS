# Day 14: Mixed Practice — Aggregation & Window Functions

## Quick Recall Before Practicing

Window functions differ from GROUP BY: GROUP BY collapses rows into one row per group; window functions keep every row, but attach a calculated value (rank, running total, etc.) computed "over" a defined window of rows.

Common window functions:
- ROW_NUMBER() — unique sequential number per row within a partition
- RANK() — rank with gaps after ties (1, 2, 2, 4)
- DENSE_RANK() — rank without gaps after ties (1, 2, 2, 3)
- SUM()/AVG() OVER (...) — running totals/averages without collapsing rows

Syntax pattern:
```sql
SELECT col, RANK() OVER (PARTITION BY group_col ORDER BY sort_col DESC) AS rnk
FROM table_name;
```
PARTITION BY resets the calculation per group (like a GROUP BY, but without collapsing rows). ORDER BY defines the order the ranking/running total is calculated in.