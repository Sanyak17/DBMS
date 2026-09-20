-- ============================================
-- Day 5 Practice — Indexing
-- ============================================

-- Q1: Create a composite index and demonstrate leftmost-prefix usage
-- students table: student_id, name, dept_id, email

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    email VARCHAR(100) UNIQUE
);

-- Composite index — helps queries filtering by dept_id alone,
-- or dept_id + name together, but NOT name alone
CREATE INDEX idx_dept_name ON students(dept_id, name);

-- Unique index on email (explicit, though UNIQUE constraint
-- already creates one — written for practice)
CREATE UNIQUE INDEX idx_email ON students(email);


-- Q2: 1907. Count Salary Categories (LeetCode)
-- Link: https://leetcode.com/problems/count-salary-categories/
-- Approach: Use CASE-style bucketing via UNION ALL to count accounts
-- falling into Low/Average/High income categories.

SELECT 'Low Salary' AS category,
       COUNT(*) AS accounts_count
FROM Accounts
WHERE income < 20000

UNION ALL

SELECT 'Average Salary' AS category,
       COUNT(*) AS accounts_count
FROM Accounts
WHERE income BETWEEN 20000 AND 50000

UNION ALL

SELECT 'High Salary' AS category,
       COUNT(*) AS accounts_count
FROM Accounts
WHERE income > 50000;