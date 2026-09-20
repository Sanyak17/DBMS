# Day 13: Mixed Practice — Joins & Subqueries

No new theory today — this day consolidates Days 8 (JOINs) and earlier subquery concepts through varied practice. The goal is pattern recognition: given a problem statement, quickly identify whether it needs a JOIN, a subquery, or both.

## Quick Recall Before Practicing

- Need columns from two tables together -> JOIN
- Need to filter based on a condition in another table, but don't need its columns -> subquery (EXISTS/IN)
- Need to compare a row against an aggregate (like department average) -> correlated subquery
- Need "records with no match" -> LEFT JOIN + IS NULL, or NOT EXISTS
- Need self-referencing data (manager-employee, before-after) -> SELF JOIN

## Approach Checklist (use this before writing any query)
1. Identify which tables are involved
2. Identify the join condition (or filter condition, if subquery)
3. Identify if aggregation is needed (COUNT, SUM, AVG) — if yes, think GROUP BY + HAVING
4. Identify if NULLs need special handling (LEFT JOIN scenarios)
5. Write the query, then mentally trace it against 2-3 sample rows