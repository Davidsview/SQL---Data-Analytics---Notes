#Exercise #1: 
-- Write a query that upon execution, assigns a row number to all managers we have information
-- for in the "employees" database (regardless of their department). 
-- Let the numbering disregard the department the managers have worked in.
-- Also let it start from the value of 1. Assign that value to the manager with the lowest employee number.
SELECT 
emp_no,
row_number() OVER (ORDER BY min(emp_no)) AS row_num
from dept_manager
GROUP BY emp_no;

#Another way of doing it - this way we elimininate the need to use GROUP BY
-- remember we can't use aggregate functions in select without using group by 
SELECT 
emp_no,
dept_no,
row_number() OVER (ORDER BY emp_no ASC) AS row_num2
FROM dept_manager;


#Exercise 2: Write a query that upon execution, assigns a sequential number for each employee number 
-- registered in the "employees" table. Partition the data by the employee's first name
-- and order it by their last name in ascending order (for each partition).
SELECT 
emp_no,
first_name,
last_name,
row_number() OVER (PARTITION BY first_name ORDER BY last_name ASC) as exercise2
from employees;


SELECT
emp_no,
dept_no,
row_number() OVER (ORDER BY emp_no DESC) AS row_num
FROM
dept_manager;

SELECT
emp_no,
first_name,
last_name,
row_number() OVER (PARTITION BY last_name ORDER BY emp_no ASC) AS row_num
FROM
employees;

#Obtain a result set containing the salary values each manager has signed a contract for.
-- To obtain the data, refer to the "employees" database.
#Use window functions to add the following two columns to the final output:
-- - a column containing the row number of each row from the obtained dataset, starting from 1.
-- - a column containing the sequential row numbers associated to the rows for each manager,
-- where their highest salary has been given a number equal to the number of rows in the given partition,
-- and their lowest - the number 1.
SELECT
dm.emp_no,
s.salary,
row_number() OVER (ORDER BY dm.emp_no) AS global_row_num,
row_number() OVER (PARTITION BY dm.emp_no ORDER BY s.salary ASC) AS manager_salary_rank #For each manager independently, rank their salaries from lowest to highest.
FROM dept_manager dm
JOIN salaries s ON dm.emp_no = s.emp_no
ORDER BY global_row_num, s.salary ASC
;

#Instead of just seeing salaries, we now understand:
-- The sequence of salaries per manager
-- The relative position of each salary
-- The dataset order in a structured way
-- And this is what window functions unlock.

#We could then use this data to 
-- Identify lowest and highest salary of each manager easily
-- Compare their first contract vs latest contract
-- Measure growth across contracts
-- Detect anomalies

SELECT 
dm.emp_no,
s.salary,
row_number() OVER (PARTITION BY dm.emp_no ORDER BY s.salary ASC) AS s_ASC,
row_number() OVER (PARTITION BY dm.emp_no ORDER BY s.salary DESC) AS s_DESC
FROM dept_manager dm
JOIN salaries s
ON dm.emp_no = s.emp_no;

SELECT 
row_number() OVER () AS row_num1,
t.emp_no,
t.title,
s.salary,
row_number() OVER (PARTITION BY s.salary ORDER BY t.emp_no DESC) AS row_num2
FROM titles t
JOIN salaries s
ON t.emp_no = s.emp_no
LIMIT 100;

SELECT 
row_number() OVER () AS row_num1,
t.emp_no,
t.title,
s.salary,
row_number() OVER (PARTITION BY t.emp_no ORDER BY s.salary DESC) AS row_num2
FROM titles t
JOIN salaries s
ON t.emp_no = s.emp_no
WHERE t.emp_no < 10007 AND t.title = "Staff"
ORDER BY s.salary, row_num1 ASC;


SELECT 
t.emp_no,
t.title,
s.salary,
row_number() OVER () AS row_num1,
row_number() OVER (PARTITION BY t.emp_no ORDER BY s.salary ASC) AS row_num2
FROM titles t
JOIN 
salaries s 
ON t.emp_no = s.emp_no
WHERE t.emp_no < 10007 and t.title = "Staff"
ORDER BY t.emp_no, s.salary, row_num1 ASC;


#Write a query that provides row numbers for all workers from the "employees" table,
-- partitioning the data by their first names and ordering each partition by their employee number in ascending order.
SELECT
emp_no,
first_name,
ROW_NUMBER() OVER w AS row_num #another way of writing a windows syntax - this is the execution of a windows clause
FROM
employees
WINDOW w AS (PARTITION BY first_name ORDER BY emp_no); #w is the aliases
