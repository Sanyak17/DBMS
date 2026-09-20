-- ============================================
-- Day 6 Practice — DDL, DML, SQL Command Types
-- ============================================

-- Q1: DDL practice — create, alter, and modify a table's structure

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    dept_id INT
);

ALTER TABLE employees ADD COLUMN email VARCHAR(100) UNIQUE;
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12,2);


-- Q2: DML practice — insert, update with condition, delete with condition

INSERT INTO employees (emp_id, name, salary, dept_id, email)
VALUES 
    (1, 'Sanya', 55000, 101, 'sanya@mail.com'),
    (2, 'Rahul', 48000, 102, 'rahul@mail.com');

UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 101;

DELETE FROM employees
WHERE emp_id = 2;


-- Q3: 1141. User Activity for the Past 30 Days I (LeetCode)
-- Link: https://leetcode.com/problems/user-activity-for-the-past-30-days-i/
-- Approach: WHERE filters date range first, then GROUP BY activity_date
-- to count distinct active users per day.

SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;