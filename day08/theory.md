# Day 8: JOINs, Inner vs Outer Join, Nested Queries

## What is a JOIN?
A JOIN combines rows from two or more tables based on a related column, letting you retrieve data spread across normalized tables as a single result set. Normalization splits data across tables to avoid redundancy — JOINs reconstruct combined views at query time.

## Types of JOINs

### INNER JOIN
Returns only rows with matching values in both tables.
```sql
SELECT s.name, e.course_id
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id;
```
Eg: only shows students actually enrolled in a course.

### LEFT JOIN (LEFT OUTER JOIN)
All rows from the left table, plus matches from the right (NULL if none).
```sql
SELECT s.name, e.course_id
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id;
```
Eg: shows every student, even unenrolled ones (course_id = NULL).

### RIGHT JOIN (RIGHT OUTER JOIN)
All rows from the right table, plus matches from the left. Mirror of LEFT JOIN. Rarely used directly — most flip table order and use LEFT JOIN instead.

### FULL OUTER JOIN
All rows from both tables, matched where possible, NULL elsewhere.
MySQL doesn't support it directly — emulated via UNION of LEFT and RIGHT JOIN:
```sql
SELECT s.name, e.course_id FROM students s LEFT JOIN enrollments e ON s.student_id = e.student_id
UNION
SELECT s.name, e.course_id FROM students s RIGHT JOIN enrollments e ON s.student_id = e.student_id;
```

### SELF JOIN
A table joined with itself, using two aliases.
```sql
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.emp_id;
```
Eg: finding each employee's manager within the same table.

### CROSS JOIN
Cartesian product — every row from A combined with every row from B, no condition.
```sql
SELECT s.name, c.course_name
FROM students s
CROSS JOIN courses c;
```
Eg: 10 students x 5 courses = 50 rows, every possible combination.

## Inner vs Outer Join

| Inner Join | Outer Join |
|---|---|
| Only matching rows from both tables | Includes unmatched rows too (NULL padded) |
| Smaller/equal result set | Result set can be equal or larger |
| Eg: only enrolled students | Eg: all students, enrolled or not |

"Outer Join" covers LEFT, RIGHT, FULL — all preserve unmatched rows from at least one side.

## JOINs Summary

| JOIN Type | Returns |
|---|---|
| INNER JOIN | Only matching rows in both tables |
| LEFT JOIN | All left rows + matches from right |
| RIGHT JOIN | All right rows + matches from left |
| FULL OUTER JOIN | All rows from both, matched where possible |
| SELF JOIN | Table joined with itself |
| CROSS JOIN | Cartesian product |

## Nested Queries (Subqueries)

A query written inside another query, used to filter or compute a value from the inner query's result.

### Single-row subquery
Returns exactly one value.
```sql
SELECT name FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

### Multi-row subquery
Returns multiple values, used with IN, ANY, ALL.
```sql
SELECT name FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = 'Bangalore');
```

### Correlated subquery
References a column from the outer query, re-executes once per outer row.
```sql
SELECT name, salary FROM employees e1
WHERE salary > (
    SELECT AVG(salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id
);
```
Eg: employees earning more than their own department's average.

Regular vs Correlated:
| Regular Subquery | Correlated Subquery |
|---|---|
| Executes once, independently | Executes once per outer row |
| No reference to outer columns | References outer query's columns |
| Generally faster | Can be slower on large tables |

### Subquery in FROM clause (derived table)
```sql
SELECT dept_id, avg_sal FROM (
    SELECT dept_id, AVG(salary) AS avg_sal FROM employees GROUP BY dept_id
) AS dept_averages
WHERE avg_sal > 50000;
```

### EXISTS subquery
Checks whether the subquery returns any rows at all.
```sql
SELECT name FROM students s
WHERE EXISTS (
    SELECT 1 FROM enrollments e WHERE e.student_id = s.student_id
);
```
Eg: find students with at least one enrollment — EXISTS stops at first match, often faster than IN for large results.

## JOIN vs Subquery
No universal answer — depends on optimizer and data size.
- JOINs preferred when you need columns from both tables in the result.
- Subqueries (EXISTS/IN) often clearer when only filtering, not needing the other table's columns in output.
- Modern optimizers often rewrite subqueries into joins internally — performance difference is often negligible for well-indexed queries.