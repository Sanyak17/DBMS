# Day 7: Normalization, Denormalization, Functional Dependency

## What is Normalization?
Normalization organizes data to reduce redundancy and eliminate anomalies (insertion, update, deletion), by breaking large tables into smaller related tables based on functional dependencies.

## The Three Anomalies

Unnormalized example: (student_id, student_name, course_id, course_name, instructor)

1. Insertion Anomaly: Can't add a new course unless a student is enrolled in it.
2. Update Anomaly: Changing an instructor requires updating every row where that course appears — miss one, data becomes inconsistent.
3. Deletion Anomaly: Deleting the last student in a course can accidentally erase all record that the course/instructor ever existed.

## Types of Normalization

### 1NF — First Normal Form
Rule: every column holds atomic values, no repeating groups/multi-valued columns.

Violation: phone_numbers = "9876543210, 9123456780" in one cell.
Fix: separate rows, one phone number each, in its own table.
```sql
CREATE TABLE student_phones (
    student_id INT,
    phone_number VARCHAR(15),
    PRIMARY KEY (student_id, phone_number),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
```

### 2NF — Second Normal Form
Rule: 1NF + no partial dependency (only relevant with composite PK) — every non-key attribute depends on the WHOLE key.

Violation: enrollments(student_id, course_id, student_name, grade), PK (student_id, course_id). student_name depends only on student_id — partial dependency.

Fix:
```sql
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50)
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
```

### 3NF — Third Normal Form
Rule: 2NF + no transitive dependency — non-key attributes must depend directly on the key, not through another non-key attribute.

Violation: students(student_id, name, dept_id, dept_head). student_id -> dept_id -> dept_head is transitive.

Fix:
```sql
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_head VARCHAR(50)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
```

### BCNF — Boyce-Codd Normal Form
Rule: for every FD X -> Y, X must be a super key. Handles edge cases with overlapping candidate keys that 3NF misses.

Example: course_instructor(student_id, course_id, instructor). If instructor -> course_id (each instructor teaches only one course) but instructor isn't a super key, this violates BCNF. Fix: split into separate tables.

3NF vs BCNF:
| 3NF | BCNF |
|---|---|
| Allows some redundancy in rare overlapping-key edge cases | Stricter — eliminates all such redundancy |
| Non-key attributes depend on key non-transitively | Every determinant must be a super key |
| Easier to achieve, sufficient for most schemas | Sometimes sacrifices dependency preservation |

### 4NF and 5NF (brief)
4NF: eliminates multi-valued dependencies — independent multi-valued facts shouldn't sit in one table (eg: hobbies and languages combined creates meaningless combinations).

5NF: eliminates join dependencies — ensures a table can be decomposed and reconstructed via joins without redundancy/loss.

## Normal Forms Summary

| Normal Form | Rule | Fixes |
|---|---|---|
| 1NF | Atomic values, unique rows | Repeating groups / multi-valued columns |
| 2NF | 1NF + no partial dependency | Non-key attrs depending on part of composite key |
| 3NF | 2NF + no transitive dependency | Non-key attrs depending on other non-key attrs |
| BCNF | Every determinant is a super key | Overlapping candidate key edge cases |
| 4NF | No multi-valued dependency | Independent multi-valued facts combined |
| 5NF | No join dependency | Redundancy from join/decomposition |

## Denormalization
Deliberate, controlled reintroduction of redundancy to improve read performance, at the cost of write complexity/storage.

Real-world eg: orders table stores customer_name directly (denormalized) instead of requiring a JOIN with customers every read, since order history is read far more often than customer names change.
```sql
-- Normalized (JOIN every read)
SELECT o.order_id, c.name, o.amount
FROM orders o JOIN customers c ON o.customer_id = c.customer_id;

-- Denormalized (no JOIN needed)
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(50),
    amount DECIMAL(10,2)
);
```

Normalization vs Denormalization:
| Normalization | Denormalization |
|---|---|
| Reduces redundancy | Deliberately introduces redundancy |
| Improves write consistency | Improves read performance |
| More JOINs needed | Fewer JOINs needed |
| Used in OLTP systems | Used in OLAP/reporting systems |