-- ============================================
-- Day 12 Practice — Conflict Serializability
-- ============================================

-- Q1: Conceptual (no query) — check if the following schedule is
-- conflict serializable using the precedence graph method.
--
-- Schedule S:
-- T1: Read(A)
-- T2: Read(A), Write(A)
-- T1: Write(A)
--
-- Step 1: Identify conflicts
--   T2's Read(A) happens before T1's Write(A) -> T2 -> T1 (RW conflict)
--   T2's Write(A) happens before T1's Write(A) -> T2 -> T1 (WW conflict)
--
-- Step 2: Build precedence graph
--   Only edge: T2 -> T1
--
-- Step 3: Check for cycles
--   No cycle exists (single directed edge)
--
-- Conclusion: This schedule IS conflict serializable.
-- Equivalent serial order: T2, T1


-- Q2: 1667 revisited conceptually is skipped - moving to a fresh LC problem.
-- 1934. Confirmation Rate (LeetCode)
-- Link: https://leetcode.com/problems/confirmation-rate/
-- Approach: LEFT JOIN Signups with Confirmations, use AVG with a CASE
-- (or AVG of a boolean-like 1/0 column) to compute confirmed ratio,
-- defaulting to 0 when a user has no confirmation requests at all.

SELECT s.user_id,
       ROUND(
           AVG(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END),
           2
       ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id;