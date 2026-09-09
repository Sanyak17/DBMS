-- ============================================
-- Day 1 Practice — SQL Revision + LeetCode
-- ============================================

-- Q1: Select All (HackerRank)
-- Query all columns for every record in the CITY table.

SELECT * FROM CITY;


-- Q2: Select By ID (HackerRank)
-- Query all columns for a city with ID = 1661 in CITY table.

SELECT * FROM CITY WHERE ID = 1661;


-- Q3: Revising the Select Query I (HackerRank)
-- Query all columns for California cities in CITY with population > 100000.

SELECT *
FROM CITY
WHERE POPULATION > 100000
AND COUNTRYCODE = 'USA';


-- Q4: Revising the Select Query II (HackerRank)
-- Query the NAME field for American cities with population > 120000.

SELECT NAME
FROM CITY
WHERE POPULATION > 120000
AND COUNTRYCODE = 'USA';


-- Q5: Japanese Cities' Names (HackerRank)
-- Print names of all Japanese cities in CITY table.

SELECT NAME
FROM CITY
WHERE COUNTRYCODE = 'JPN';


-- Q6: Japanese Cities' Attributes (HackerRank)
-- Query all attributes of every Japanese city in CITY table.

SELECT *
FROM CITY
WHERE COUNTRYCODE = 'JPN';


-- Q7: 1581. Customer Who Visited but Did Not Make Any Transactions (LeetCode)
-- Link: https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/
-- Approach: LEFT JOIN Visits with Transactions, keep only rows where
-- no matching transaction exists (transaction_id IS NULL), then
-- count how many such visits each customer made.

SELECT v.customer_id, COUNT(v.visit_id) AS count_no_trans
FROM Visits v
LEFT JOIN Transactions t
ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;