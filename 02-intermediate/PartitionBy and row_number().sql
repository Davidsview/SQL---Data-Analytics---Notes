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

#The PARTITION BY Clause vs the GROUP BY Clause - Exercise - 
-- The partition By Clause is a lot more thorough for example:
-- We can use the group by clause and the MAX() syntax to generate the highest salary contract of an employee
-- The Partition By clause can also do it but it's just a lot more syntax faff
-- So what's the point? Tell'em David:
-- If we wanted to generate the third highest salary contract an employee has signed we wouldn't be able to use the group by function, the partition by would be the suitable choice.

SELECT 
a.emp_no,
a.salary AS max_salary 
FROM
(SELECT 
emp_no,
salary,
ROW_NUMBER() OVER w AS row_num
FROM 
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC)) a
WHERE a.row_num = 1; # Here we're substituting the GROUP BY clause with a WHERE clause,
-- whose condition will indicate that we want to only retrieve the first records of the partitions.
-- Technically, this can be specified by referring to the number one rank from the row number column.
-- In other words, we'll arrange the salary values from highest to lowest in our sub query
-- and then use a WHERE condition to retrieve the employee's salary ranked as number one.
#In another example where we were looking for the second highest - all we'd have to do is adjust the a.row_num to = 2
-- which will give us the second highest salary for each employee


#EXERCISE: Find out the lowest salary value each employee has ever signed a contract for.
-- To obtain the desired output, use a subquery containing a window function,
--  as well as a window specification introduced with the help of the WINDOW keyword.
SELECT 
a.emp_no,
a.salary AS min_salary 
FROM
(SELECT 
emp_no,
salary,
ROW_NUMBER() OVER w AS row_num
FROM 
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary ASC)) a #Ordering salaries by ascending, means the lowest salary will always be row number 1.
WHERE a.row_num = 1; #Very interesting how the slightest modification can change the entirety of the results.

#Another way of writing the above exercise - can be written interchangebly
SELECT
a.emp_no,
a.salary AS min_salary
FROM
(SELECT
emp_no,
salary,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num
FROM salaries) a
WHERE a.row_num = 1;

SELECT * 
FROM dept_manager;

SELECT
a.emp_no,
a.salary AS min_salary
FROM
(SELECT
dm.emp_no,
s.salary,
ROW_NUMBER() OVER (PARTITION BY dm.emp_no ORDER BY s.salary ASC) AS row_num
FROM salaries s
JOIN dept_manager dm
ON s.emp_no = dm.emp_no) a
WHERE a.row_num = 1; 
