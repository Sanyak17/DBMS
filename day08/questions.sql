-- ============================================
-- Day 8 Practice — JOINs, Nested Queries
-- ============================================

-- Q1: Demonstrate INNER JOIN, LEFT JOIN, and a correlated subquery

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dept_id INT
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- INNER JOIN — only enrolled students
SELECT s.name, e.course_id
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id;

-- LEFT JOIN — all students, including unenrolled (NULL course_id)
SELECT s.name, e.course_id
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id;

-- Correlated subquery — students in dept_id 101 with more than
-- average enrollments in their own department (illustrative)
SELECT s1.name
FROM students s1
WHERE (SELECT COUNT(*) FROM enrollments e WHERE e.student_id = s1.student_id) >
      (SELECT AVG(cnt) FROM (
          SELECT COUNT(*) AS cnt FROM enrollments GROUP BY student_id
      ) AS sub);


-- Q2: 197. Rising Temperature (LeetCode)
-- Link: https://leetcode.com/problems/rising-temperature/
-- Approach: SELF JOIN Weather to itself, matching each row to the
-- row exactly one day before it (via DATEDIFF), filter where today's
-- temperature is higher than yesterday's.

SELECT w1.id
FROM Weather w1
JOIN Weather w2
ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE w1.temperature > w2.temperature;


-- Q3: 570. Managers with at Least 5 Direct Reports (LeetCode)
-- Link: https://leetcode.com/problems/managers-with-at-least-5-direct-reports/
-- Approach: subquery in FROM - GROUP BY managerId, HAVING COUNT >= 5,
-- then JOIN back to Employee to get the manager's name.

SELECT name
FROM Employee
WHERE id IN (
    SELECT managerId
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) >= 5
);