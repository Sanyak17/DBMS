# Day 9: TRUNCATE vs DELETE, General SQL Practice

## TRUNCATE vs DELETE

Both remove data, but work fundamentally differently.

### DELETE
- A DML command
- Removes rows one at a time, logging each deletion individually — allows WHERE clause for conditional deletion
- Can be rolled back if inside a transaction (before COMMIT)
- Triggers (like AFTER DELETE) do fire for each row
- Slower on large tables, since every row deletion is logged

```sql
DELETE FROM employees WHERE dept_id = 999;
DELETE FROM employees;  -- deletes all rows, but still logs each one
```

### TRUNCATE
- A DDL command
- Removes all rows at once by deallocating data pages directly — no WHERE clause allowed
- Cannot be rolled back in most RDBMSs (MySQL auto-commits DDL); PostgreSQL allows it within a transaction
- Triggers generally do NOT fire
- Much faster than DELETE for clearing an entire table
- Resets auto-increment counters in most databases (DELETE does not)

```sql
TRUNCATE TABLE employees;
```

### TRUNCATE vs DELETE — Consolidated Table

| Aspect | DELETE | TRUNCATE |
|---|---|---|
| Command type | DML | DDL |
| WHERE clause | Allowed | Not allowed |
| Rollback | Yes, within a transaction | Usually no (auto-committed) |
| Speed | Slower (row-by-row logging) | Faster (deallocates pages directly) |
| Triggers | Fire per row | Generally don't fire |
| Auto-increment reset | No | Yes (in most RDBMSs) |
| Table structure | Preserved | Preserved |

### DROP — the common follow-up
DROP TABLE removes the table structure itself, not just data — the table no longer exists afterward. TRUNCATE empties the table but keeps structure intact for future inserts.

## General SQL Command Practice (mixed revision)

Combined query demonstrating multiple concepts together:
```sql
SELECT d.dept_name, COUNT(e.emp_id) AS emp_count, AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) > 2
ORDER BY avg_salary DESC;
```
Demonstrates: LEFT JOIN (include departments even with 0 employees), GROUP BY, aggregate functions, HAVING (post-group filter), ORDER BY — all together in one query.