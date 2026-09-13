-- Create a View demonstrating External-level abstraction
-- books table has book_id, title, author, price, stock
-- customer-facing catalog should hide the stock column

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50),
    price DECIMAL(6,2),
    stock INT
);

CREATE VIEW customer_catalog AS
SELECT book_id, title, author, price
FROM books;


Q1: 1731. The Number of Employees Which Report to Each Employee
-- Link: https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/
-- Approach: Self-JOIN Employees to itself on reports_to = employee_id,
-- GROUP BY manager to count reportees and average their age

SELECT e1.employee_id, e1.name,COUNT(e2.employee_id) AS reports_count, ROUND(AVG(e2.age)) AS average_age
FROM Employees e1
JOIN Employees e2 ON e1.employee_id = e2.reports_to
GROUP BY e1.employee_id, e1.name
ORDER BY e1.employee_id;