TRANSACTIONS PRACTICE:
CREATE TABLE Account (
    account_id INT PRIMARY KEY,
    holder_name VARCHAR(50),
    balance DECIMAL(10,2)
);

INSERT INTO Account
VALUES
(1, 'Santa', 10000),
(2, 'Rahul', 5000);

-- transfer 1000 from acc 1 to 2
START TRANSACTION;

UPDATE Account
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE Account
SET balance = balance + 1000
WHERE account_id = 2;

COMMIT;
-- check
SELECT *
FROM Account;


-- rollback
START TRANSACTION;

UPDATE Account
SET balance = balance - 1000
WHERE account_id = 1;

UPDATE Account
SET balance = balance + 1000
WHERE account_id = 2;

ROLLBACK;

-- savepoint
START TRANSACTION;

UPDATE Account
SET balance = balance - 1000
WHERE account_id = 1;

SAVEPOINT after_debit;

UPDATE Account
SET balance = balance + 1000
WHERE account_id = 2;

-- ============================================
-- Day 2 Practice — LeetCode SQL Set
-- ============================================

-- Q1: 175. Combine Two Tables
-- Link: https://leetcode.com/problems/combine-two-tables/
-- Approach: LEFT JOIN Person with Address on personId,
-- so people without an address still appear, with NULL city/state.

SELECT firstName, lastName, city, state
FROM Person
LEFT JOIN Address
ON Person.personId = Address.personId;


-- Q2: 181. Employees Earning More Than Their Managers
-- Link: https://leetcode.com/problems/employees-earning-more-than-their-managers/
-- Approach: Self-JOIN Employee to itself, matching e1.managerId = e2.id,
-- then filter where the employee's salary exceeds their manager's.

SELECT e1.name AS Employee
FROM Employee e1
JOIN Employee e2 ON e1.managerId = e2.id
WHERE e1.salary > e2.salary;


-- Q3: 182. Duplicate Emails
-- Link: https://leetcode.com/problems/duplicate-emails/
-- Approach: GROUP BY email, keep only emails with COUNT > 1.

SELECT email AS Email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;


-- Q4: 196. Delete Duplicate Emails
-- Link: https://leetcode.com/problems/delete-duplicate-emails/
-- Approach: Self-JOIN Person to itself on matching email,
-- delete the row with the larger id, keeping the smallest id per email.

DELETE p1
FROM Person p1
JOIN Person p2
ON p1.email = p2.email AND p1.id > p2.id;

