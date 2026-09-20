-- ============================================
-- Day 9 Practice — TRUNCATE vs DELETE, Mixed SQL
-- ============================================

-- Q1: Demonstrate DELETE (conditional, rollback-safe) vs TRUNCATE (full, fast)

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    dept_id INT
);

INSERT INTO employees (name, dept_id) VALUES
('Sanya', 101), ('Rahul', 102), ('Priya', 101);

-- Conditional delete - can be rolled back within a transaction
DELETE FROM employees WHERE dept_id = 102;

-- Full clear - fast, resets AUTO_INCREMENT, cannot be rolled back
TRUNCATE TABLE employees;


-- Q2: 1667. Fix Names in a Table (LeetCode)
-- Link: https://leetcode.com/problems/fix-names-in-a-table/
-- Approach: UPPER first letter + LOWER rest, using CONCAT with
-- UPPER(LEFT(name,1)) and LOWER(SUBSTRING(name,2)).

SELECT user_id,
       CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id;


-- Q3: 1484. Group Sold Products By The Date (LeetCode)
-- Link: https://leetcode.com/problems/group-sold-products-by-the-date/
-- Approach: GROUP BY sell_date, COUNT DISTINCT products for num_sold,
-- GROUP_CONCAT with DISTINCT + ORDER BY for the comma-separated product list.

SELECT sell_date,
       COUNT(DISTINCT product) AS num_sold,
       GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;