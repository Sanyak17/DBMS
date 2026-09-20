-- ============================================
-- Day 13 Practice — Mixed JOINs & Subqueries
-- ============================================

-- Q1: 1050. Actors and Directors Who Cooperated At Least Three Times
-- Link: https://leetcode.com/problems/actors-and-directors-who-cooperated-at-least-three-times/
-- Approach: GROUP BY actor_id, director_id pair, HAVING COUNT >= 3.

SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;


-- Q2: 1075. Project Employees I
-- Link: https://leetcode.com/problems/project-employees-i/
-- Approach: JOIN Project with Employee on employee_id,
-- GROUP BY project_id, compute AVG(experience_years) rounded to 2 places.

SELECT p.project_id, ROUND(AVG(e.experience_years), 2) AS average_years
FROM Project p
JOIN Employee e ON p.employee_id = e.employee_id
GROUP BY p.project_id;


-- Q3: 1084. Sales Analysis III
-- Link: https://leetcode.com/problems/sales-analysis-iii/
-- Approach: JOIN Sales with Product, GROUP BY product_id,
-- use HAVING with MIN/MAX on sale_date to ensure ALL sales
-- fall strictly within the Spring 2019 range.

SELECT p.product_id, p.product_name
FROM Product p
JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
HAVING MIN(s.sale_date) >= '2019-01-01' AND MAX(s.sale_date) <= '2019-03-31';


-- Q4: 1179. Reformat Department Table
-- Link: https://leetcode.com/problems/reformat-department-table/
-- Approach: Pivot rows into columns using conditional SUM per month.

SELECT id,
       SUM(CASE WHEN month = 'Jan' THEN revenue END) AS Jan_Revenue,
       SUM(CASE WHEN month = 'Feb' THEN revenue END) AS Feb_Revenue,
       SUM(CASE WHEN month = 'Mar' THEN revenue END) AS Mar_Revenue,
       SUM(CASE WHEN month = 'Apr' THEN revenue END) AS Apr_Revenue,
       SUM(CASE WHEN month = 'May' THEN revenue END) AS May_Revenue,
       SUM(CASE WHEN month = 'Jun' THEN revenue END) AS Jun_Revenue,
       SUM(CASE WHEN month = 'Jul' THEN revenue END) AS Jul_Revenue,
       SUM(CASE WHEN month = 'Aug' THEN revenue END) AS Aug_Revenue,
       SUM(CASE WHEN month = 'Sep' THEN revenue END) AS Sep_Revenue,
       SUM(CASE WHEN month = 'Oct' THEN revenue END) AS Oct_Revenue,
       SUM(CASE WHEN month = 'Nov' THEN revenue END) AS Nov_Revenue,
       SUM(CASE WHEN month = 'Dec' THEN revenue END) AS Dec_Revenue
FROM Department
GROUP BY id;