-- ============================================
-- Day 15 Practice — Final Mixed Review
-- ============================================

-- Q1: 1050 revisited combined with new pattern -
-- 626. Exchange Seats (LeetCode)
-- Link: https://leetcode.com/problems/exchange-seats/
-- Approach: CASE WHEN to swap adjacent odd-even id pairs, handling
-- the edge case of an odd total count (last row with no pair stays put).

SELECT
    CASE
        WHEN id % 2 = 1 AND id = (SELECT MAX(id) FROM Seat) THEN id
        WHEN id % 2 = 1 THEN id + 1
        ELSE id - 1
    END AS id,
    student
FROM Seat
ORDER BY id;


-- Q2: 1517. Find Users With Valid E-Mails
-- Link: https://leetcode.com/problems/find-users-with-valid-e-mails/
-- Approach: REGEXP to validate email format - starts with a letter,
-- followed by alphanumeric/underscore/dot/dash, then '@leetcode.com'.

SELECT *
FROM Users
WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9_.-]*@leetcode\\.com$';


-- Q3: 1454. Active Users
-- Link: https://leetcode.com/problems/active-users/
-- Approach: Self-JOIN Logins to itself within a 5-day window per user,
-- COUNT DISTINCT login dates, keep users with 5+ consecutive-ish days.
-- (Full correct solution uses DATEDIFF-based self join - simplified here
--  as a mixed-review illustrative query.)

SELECT DISTINCT l1.id, l1.name
FROM Accounts l1
JOIN Logins l2
ON l1.id = l2.id
AND DATEDIFF(l2.login_date, l1.id) BETWEEN 0 AND 4;