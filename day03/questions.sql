-- Q1: Model a 1:1 relationship — Person and Passport

CREATE TABLE person (
    person_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE passport (
    passport_id INT PRIMARY KEY,
    person_id INT UNIQUE NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person(person_id)
);


-- Q2: Model a Weak Entity — Dependents tied to Employees

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE dependents (
    emp_id INT,
    dependent_name VARCHAR(50),
    relationship VARCHAR(20),
    PRIMARY KEY (emp_id, dependent_name),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);


-- Q3: 619. Biggest Single Number (LeetCode)
-- Link: https://leetcode.com/problems/biggest-single-number/

SELECT MAX(num) AS num
FROM (
    SELECT num
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(num) = 1
) AS single_nums;