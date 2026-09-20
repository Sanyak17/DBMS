-- ============================================
-- Day 7 Practice — Normalization
-- ============================================

-- Q1: Normalize an unnormalized table to 3NF
-- Unnormalized: students(student_id, name, dept_id, dept_head, course_id, grade)

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_head VARCHAR(50)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);


-- Q2: 1873. Calculate Special Bonus (LeetCode)
-- Link: https://leetcode.com/problems/calculate-special-bonus/
-- Approach: CASE WHEN - 100% of salary if employee_id is odd AND
-- name doesn't start with 'M', else 0.

SELECT employee_id,
       CASE 
           WHEN employee_id % 2 = 1 AND name NOT LIKE 'M%' THEN salary
           ELSE 0
       END AS bonus
FROM Employees
ORDER BY employee_id;