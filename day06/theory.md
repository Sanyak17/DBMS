# Day 6: DDL, DML, SQL Commands & Types (Deep Dive)

## Recap: The Five Categories

| Type | Full form | Purpose | Commands |
|---|---|---|---|
| DDL | Data Definition Language | Defines/alters structure | CREATE, ALTER, DROP, TRUNCATE, RENAME |
| DML | Data Manipulation Language | Modifies data | INSERT, UPDATE, DELETE |
| DQL | Data Query Language | Retrieves data | SELECT |
| DCL | Data Control Language | Access control | GRANT, REVOKE |
| TCL | Transaction Control Language | Transaction boundaries | COMMIT, ROLLBACK, SAVEPOINT |

Note: some classifications merge SELECT into DML instead of a separate DQL — know both framings.

## DDL (Data Definition Language)

DDL commands define/modify structure, never data. Important: DDL commands are auto-committed in most RDBMSs — can't ROLLBACK a CREATE/DROP TABLE (MySQL behaves this way; PostgreSQL allows DDL inside transactions).

### CREATE
```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INT
);
CREATE DATABASE company_db;
CREATE INDEX idx_name ON employees(name);
```

### ALTER
```sql
ALTER TABLE employees ADD COLUMN email VARCHAR(100);
ALTER TABLE employees DROP COLUMN email;
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12,2);
ALTER TABLE employees ADD CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);
```

### DROP
Removes an object completely — structure and data, permanently.
```sql
DROP TABLE employees;
DROP DATABASE company_db;
```

### TRUNCATE
Removes all rows, keeps structure. Faster than DELETE — deallocates data pages directly instead of logging row-by-row (full comparison on Day 9).
```sql
TRUNCATE TABLE employees;
```

### RENAME
```sql
ALTER TABLE employees RENAME TO staff;
```

## DML (Data Manipulation Language)

Works with actual data. Unlike DDL, DML can be rolled back if wrapped in a transaction before COMMIT.

### INSERT
```sql
INSERT INTO employees (emp_id, name, salary, dept_id)
VALUES (1, 'Sanya', 55000, 101);

INSERT INTO employees (emp_id, name, salary, dept_id)
VALUES (2, 'Rahul', 48000, 102), (3, 'Priya', 52000, 101);

INSERT INTO archived_employees
SELECT * FROM employees WHERE dept_id = 999;
```

### UPDATE
Always use WHERE — omitting it updates every row in the table.
```sql
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 101;
```

### DELETE
Can be rolled back within a transaction (unlike TRUNCATE).
```sql
DELETE FROM employees WHERE dept_id = 999;
```

## DQL — SELECT

```sql
SELECT column1, column2
FROM table_name
WHERE condition
GROUP BY column
HAVING group_condition
ORDER BY column
LIMIT n;
```

Logical order of execution (not the order written):
FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT

This is why a SELECT alias can't be used in WHERE — WHERE executes before SELECT logically.
```sql
-- FAILS:
SELECT salary * 1.1 AS new_salary FROM employees WHERE new_salary > 50000;

-- Correct:
SELECT salary * 1.1 AS new_salary FROM employees WHERE salary * 1.1 > 50000;
```

WHERE vs HAVING:
| WHERE | HAVING |
|---|---|
| Filters rows before grouping | Filters groups after grouping |
| Cannot use aggregate functions | Can use aggregate functions |
| Eg: WHERE salary > 40000 | Eg: HAVING AVG(salary) > 40000 |

```sql
SELECT dept_id, AVG(salary) AS avg_sal
FROM employees
WHERE salary > 30000
GROUP BY dept_id
HAVING AVG(salary) > 50000;
```

## DCL (Data Control Language)

```sql
GRANT SELECT, INSERT ON employees TO 'intern_user';
GRANT ALL PRIVILEGES ON company_db.* TO 'admin_user';
REVOKE INSERT ON employees FROM 'intern_user';
```

## TCL (Transaction Control Language)

### COMMIT
```sql
BEGIN TRANSACTION;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;
COMMIT;
```

### ROLLBACK
```sql
BEGIN TRANSACTION;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
ROLLBACK;
```

### SAVEPOINT
```sql
BEGIN TRANSACTION;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
SAVEPOINT after_debit;

UPDATE accounts SET balance = balance + 500 WHERE id = 2;
ROLLBACK TO after_debit;

COMMIT;
```

## DDL vs DML

| DDL | DML |
|---|---|
| Affects structure, not data | Affects data, not structure |
| Auto-committed (can't rollback in most RDBMSs) | Can be rolled back before COMMIT |
| Eg: CREATE, ALTER, DROP, TRUNCATE | Eg: INSERT, UPDATE, DELETE |
| Runs once, defines the schema | Runs repeatedly as data changes |