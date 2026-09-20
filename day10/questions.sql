-- ============================================
-- Day 10 Practice — Scaling & Sharding (conceptual)
-- ============================================

-- Q1: Conceptual design (no query) — design a sharding strategy
-- for a "orders" table in an e-commerce system with 500 million rows.
-- Write your reasoning as a comment:
-- - Which sharding strategy would you pick (range/hash/geographic)?
-- - What key would you shard on, and why?
-- - What tradeoff would this introduce for reporting queries?

-- Example reasoning:
-- Shard by hash(customer_id) to distribute load evenly across servers,
-- avoiding hotspots from popular regions/time periods.
-- Tradeoff: a query like "total sales this month across all customers"
-- now needs to query every shard and aggregate results in the app layer,
-- instead of a single GROUP BY on one server.


-- Q2: 1204. Last Person to Fit in the Bus (LeetCode)
-- Link: https://leetcode.com/problems/last-person-to-fit-in-the-bus/
-- Approach: Running total of weight ordered by turn, using a window
-- function (SUM() OVER), then filter rows where running total <= 1000,
-- take the one with the max turn.

SELECT person_name
FROM (
    SELECT person_name,
           SUM(weight) OVER (ORDER BY turn) AS running_total
    FROM Queue
) AS weighted
WHERE running_total <= 1000
ORDER BY running_total DESC
LIMIT 1;