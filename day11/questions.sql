-- ============================================
-- Day 11 Practice — Concurrency Control, Locks
-- ============================================

-- Q1: Conceptual (no query) — demonstrate 2PL phases for a transaction
-- transferring money from Account A to Account B.
-- Write out the lock acquisition/release sequence as a comment.

-- Growing Phase:
--   Acquire X-lock on Account A
--   Acquire X-lock on Account B
-- (all acquisitions happen before any release)
-- Shrinking Phase:
--   Release X-lock on Account A
--   Release X-lock on Account B
-- (once release begins, no new locks can be acquired)


-- Q2: Simulated locking behavior using SQL transaction statements
-- (illustrative - actual lock behavior depends on isolation level/engine)

BEGIN TRANSACTION;
SELECT balance FROM accounts WHERE account_id = 1 FOR UPDATE;  -- acquires X-lock
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;
COMMIT;  -- locks released here under Strict 2PL


-- Q3: 1978. Employees Whose Manager Left the Company (LeetCode)
-- Link: https://leetcode.com/problems/employees-whose-manager-left-the-company/
-- Approach: LEFT JOIN Employees to itself on manager_id, filter where
-- manager_id is not null but the manager's own id doesn't exist in the table,
-- and salary < 30000.

SELECT e1.employee_id
FROM Employees e1
WHERE e1.manager_id IS NOT NULL
AND e1.manager_id NOT IN (SELECT employee_id FROM Employees)
AND e1.salary < 30000
ORDER BY e1.employee_id;