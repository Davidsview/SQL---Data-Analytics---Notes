SELECT emp_no,
salary,
LAG(salary) OVER w AS previous_salary, #LAG selects the row before
LEAD(salary) OVER w AS next_salary, #LEAD selects the row after 
salary - LAG(salary) OVER w AS diff_salary_in_current_previous,
LEAD(salary) OVER w - salary AS diff_salary_in_current_next
FROM salaries
WHERE emp_no = 10001 #because we've already specified in the where clause we don't need a PARTITION BY in the WINDOWS function below
WINDOW w AS (ORDER BY salary);


#EXERCISE - Write a query that can extract the following information from the "employees" database: the salary values (in ascending order)
-- of the contracts signed by all employees numbered between 10500 and 10600 inclusive  column showing the previous salary from the given ordered list.
-- a column showing the subsequent salary from the given ordered list.
-- a column displaying the difference between the current salary of a certain employee and their previous salary.
-- a column displaying the difference between the next salary of a certain employee and their current salary
-- Limit the output to salary values higher than $80,000 only.
SELECT
emp_no,
salary,
LAG(salary) OVER w AS previous_salary,
LEAD(salary) OVER w AS next_salary,
salary - LAG(salary) OVER w AS diff_salary_current_previous,
LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM
salaries
WHERE salary > 80000 AND emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY emp_no ORDER BY salary);

#EXERCISE The MySQL LAG() and LEAD() value window functions can have a second argument, designating how many rows/steps back
-- (for LAG()) or forth (for LEAD()) we'd like to refer to with respect to a given record.
-- create a query whose result set contains data arranged by the salary values associated to each employee number (in ascending order). Let the output contain the following six columns:
-- the employee number, previous and next salary
-- the salary value of an employee's contract (i.e. which we’ll consider as the employee's current salary)
-- the employee's contract salary value preceding their previous salary
-- the employee's contract salary value subsequent to their next salary
-- Restrict the output to the first 1000 records you can obtain.

SELECT
emp_no,
salary,
LAG(salary) OVER w AS previous_salary,
LAG(salary, 2) OVER w AS 1_before_previous_salary,
LEAD(salary) OVER w AS next_salary,
LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;

#USE of aggregate functions in Windows Functions

#EXERCISE - Create a query that upon execution returns a result set containing the employee numbers, contract salary values,
-- start, and end dates of the first ever contracts that each employee signed for the company.

SELECT 
s1.emp_no, s.salary, s.from_date, s.to_date
FROM
salaries s
JOIN
(SELECT
emp_no, MIN(from_date) AS from_date #This selects the earliest salary contract start date for each employee
FROM salaries
GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no #Join earliest contract dates back to the salaries table using emp_no
WHERE s.from_date = s1.from_date; #Returns only the salary row that matches the earliest contract per employee
