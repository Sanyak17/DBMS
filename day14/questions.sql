-- ============================================
-- Day 14 Practice — Aggregation & Window Functions
-- ============================================

-- Q1: 176. Second Highest Salary
-- Link: https://leetcode.com/problems/second-highest-salary/
-- Approach: DISTINCT + ORDER BY + LIMIT/OFFSET, wrapped to return
-- NULL instead of erroring if no second-highest salary exists.

SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;


-- Q2: 177. Nth Highest Salary
-- Link: https://leetcode.com/problems/nth-highest-salary/
-- Approach: Same idea as Q1, generalized using a function parameter N,
-- with OFFSET calculated as N - 1.

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  SET N = N - 1;
  RETURN (
      SELECT DISTINCT salary
      FROM Employee
      ORDER BY salary DESC
      LIMIT 1 OFFSET N
  );
END;


-- Q3: 178. Rank Scores
-- Link: https://leetcode.com/problems/rank-scores/
-- Approach: DENSE_RANK() window function ordered by score DESC,
-- so tied scores get the same rank with no gaps afterward.

SELECT score,
       DENSE_RANK() OVER (ORDER BY score DESC) AS 'rank'
FROM Scores;


-- Q4: 185. Department Top Three Salaries
-- Link: https://leetcode.com/problems/department-top-three-salaries/
-- Approach: DENSE_RANK() partitioned by department, ordered by salary DESC,
-- then filter to keep only rank <= 3.

SELECT d.name AS Department, e.name AS Employee, e.salary AS Salary
FROM (
    SELECT id, name, salary, departmentId,
           DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS rnk
    FROM Employee
) e
JOIN Department d ON e.departmentId = d.id
WHERE e.rnk <= 3;