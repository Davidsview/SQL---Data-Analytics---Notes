#The objective is to duplicate the departments table and then practice modifying the duplicated table using INSERT and DELETE statements.
# If a table called departments_dup already exists, delete it so we can start fresh.
DROP TABLE IF EXISTS departments_dup; 

# Create a new empty table called departments_dup.
CREATE TABLE departments_dup
# It has two columns: dept_no (4-character code) and dept_name (text up to 40 characters).
(dept_no CHAR(4) NULL,
dept_name VARCHAR(40) NULL);

# Copy ALL rows from the existing departments table into departments_dup.
INSERT INTO departments_dup
(dept_no, dept_name)
SELECT * FROM departments;
# The SELECT * returns dept_no and dept_name, which match the two listed columns we just created.

# Insert a new row where we only supply the dept_name value.
INSERT INTO departments_dup(dept_name)
VALUES ('Public Relations');
# But since dept_no is not included in this INSERT statement, the database will
# automatically set dept_no to NULL for this new record.

# Remove the row from departments_dup where the department number is 'd002'.
DELETE FROM departments_dup
WHERE dept_no = 'd002'
LIMIT 1000;

INSERT INTO departments_dup(dept_no)
VALUES ('d010'), ('d011');
# Insert two new rows containing only dept_no values.
# dept_name will be NULL for both rows because only dept_no was provided.

SELECT * from departments_dup;


#Create and fill in the ‘dept_manager_dup’ table, using the following code:
DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
emp_no int(11) NOT NULL,  #NOT NULL = this column must always have a value. emp_no int(11) NOT NULL MEANS: Every manager must have an employee number.
dept_no char(4) NULL, #NULL = this column is allowed to be empty. It's optional. This row can exist without a department number.
from_date date NOT NULL,
to_date date NULL);

 INSERT INTO dept_manager_dup
select * from dept_manager;
INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES
(999904, '2017-01-01'),
(999905, '2017-01-01'),
(999906, '2017-01-01'),
(999907, '2017-01-01');
DELETE FROM dept_manager_dup
WHERE dept_no = 'd001'
LIMIT 1000; #We set the limit parameters, the lecturer didn't tell us to do this. it was because we countered an error code:1175

SELECT * FROM dept_manager_dup
ORDER BY dept_no;

#BIG BOY QUESTION: Extract a list containing information about all managers’ employee number,
-- first and last name, department number, and hire date. 
SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date 
FROM
    employees e #'employees' is given the alias 'e' to make references shorter and clearer so in the SELECT 'e.emp_no' comes from the employees table and 'dm.dept_no' comes from dept_manager
        INNER JOIN
    dept_manager dm #'dept_manager' is given the alias 'dm' for the same reason - THIS METHOD ELIMINATES THE USE OF 'AS' function. we do this when joining tables
    ON e.emp_no = dm.emp_no; #The ON clause specifies how the two tables relate:
                           -- both tables contain a column called emp_no, which is the primary link between them.
                           -- This means each manager must exist in the employees table,
                           -- and the JOIN returns only the rows where emp_no appears in BOTH tables.
                           
#QUESTION: Retrieve all employee numbers (emp_no) and contract start dates (from_date) from the department employees table (dept_emp).
-- Add a third column, displaying the name of the department they have signed for (dept_name from the departments table).						
SELECT 
dp.emp_no, dp.from_date, dpn.dept_name
FROM
dept_emp dp
INNER JOIN 
departments dpn
ON dp.dept_no = dpn.dept_no;


#QUESTION: Join the 'employees' and the 'dept_manager' tables to return a subset of all the employees whose last name is Markovitch.
-- See if the output contains a manager with that name.  
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date 
FROM employees e
LEFT JOIN dept_manager dm #Without using LEFT JOIN we wont be able to see  all the employees that don't also fit the category (being a manager)
-- remeber we just wanted to see who was a manager - thats why we used LEFT JOIN - it wasn't a 50/50 split of information gathering - more 80/20
-- lEFT JOIN was the difference between getting 1 row returned and a 180 more rows returned.
ON e.emp_no = dm.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY dm.dept_no DESC, e.emp_no; #BY order by managers first, we get to see the managers who has the Markovitch,
-- and then we get to see all the other employees wo aren't managers but still have the name Markovitch

#QUESTION: Use the old type of join syntax to obtain the result.
-- Extract a list containing information about all managers’
-- employee number, first and last name, department number, and hire date.
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date 
FROM employees e, dept_manager dm
WHERE e.emp_no = dm.emp_no; #This time we used the old JOIN syntax - WHERE to achieve the same thing
-- It's important to note that although WHERE can achieve the same results, it doesnt have features such as LEFT/RIGHT join


#To make sure you can take some of the remaining lectures of the course without unnecessary interruption,
-- we strongly advise you to execute the following query now. The GROUP BY clause will be used in several queries by the end of the course.
-- Different versions of the SQL language and MySQL, in particular, can set different limits on how the GROUP BY clause can be applied.
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

SELECT *  FROM titles;

#Select the first and last name, the hire date,
-- and the job title of all employees whose first name is “Margareta”
-- and have the last name “Markovitch”.
SELECT e.emp_no, t.title, e.first_name, e.last_name, e.hire_date
FROM employees e
LEFT JOIN titles t
ON e.emp_no = t.emp_no
WHERE e.first_name = "Margareta"
	AND e.last_name = "Markovitch";

#QUESTION: Use a CROSS JOIN to return a list with all possible combinations
-- between managers from the dept_manager table and department number 9.
SELECT e.first_name, e.last_name, dm.*, d.* 
FROM dept_manager dm
CROSS JOIN departments d
JOIN employees e 
ON dm.emp_no = e.emp_no
WHERE d.dept_no = 'd009';

SELECT * FROM departments;

#QUESTION: Return a list with the first 10 employees with all the departments they can be assigned to.
-- Hint: Don’t use LIMIT; use a WHERE clause.
SELECT e.emp_no, d.*
FROM employees e
CROSS JOIN departments d 
WHERE d.dept_no IS NOT NULL;
#WHY this is wrong: You never restricted employees to the first 10
-- Your query returns ALL employees, not the first 10.
-- The WHERE clause filters departments, not employees
-- dept_no will never be NULL, It is the primary key, we basically filtered nothing
#The question It assumes you already know:
-- emp_no starts at 10001
-- the next 9 are 10002 → 10010
-- so the first 10 employees are identified by: e.emp_no < 10011
-- The correct answer:
SELECT e.*, d.*
FROM employees e
CROSS JOIN departments d
WHERE e.emp_no < 10011
ORDER BY e.emp_no, d.dept_name;

SELECT * FROM employees;


#This was a really messy way of doing it but nontheless it was done
-- Select all managers’ first and last name, hire date, job title, start date, and department name.
SELECT dpm.dept_no,
 e.first_name,
 e.last_name,
 e.hire_date,
 t.title,
 t.from_date,
 d.dept_name
 FROM dept_manager dpm 
JOIN titles t
ON dpm.emp_no = t.emp_no
JOIN employees e
 ON dpm.emp_no = e.emp_no
 JOIN departments d
 ON dpm.dept_no = d.dept_no
 WHERE t.title = "Manager";
 
 #Another way of doing it - fair play to him I guess
 SELECT
e.first_name,
e.last_name,
e.hire_date,
t.title,
m.from_date,
d.dept_name
FROM
employees e
JOIN
dept_manager m ON e.emp_no = m.emp_no
JOIN
departments d ON m.dept_no = d.dept_no
    JOIN
titles t ON e.emp_no = t.emp_no
AND m.from_date = t.from_date
ORDER BY e.emp_no;



SELECT 
e.first_name,
e.last_name,
e.hire_date,
t.title,
m.from_date,
d.dept_name
FROM employees e 
JOIN 
dept_emp m ON e.emp_no = m.emp_no
JOIN 
departments d ON m.dept_no = d.dept_no
JOIN
titles t ON e.emp_no = t.emp_no
WHERE t.title = 'Senior Engineer';

#How many male and how many female managers do we have in the ‘employees’ database?
SELECT 
COUNT(d.dept_no) AS Managers, e.gender
FROM employees e
JOIN
dept_manager d
ON e.emp_no = d.emp_no
GROUP BY gender;

#Calculate the average salary (salary), as recorded in the salaries table, for each job title (title) as listed in the titles table,
-- considering all contracts ever signed. Name the second column avg_salary and make sure to round the average salary to the nearest cent.
-- Only include records where the average salary is less than $75,000. Sort the results from highest to lowest average salary.
SELECT t.title, ROUND(AVG(s.salary),2) AS avg_salary
FROM salaries s
JOIN 
titles t ON s.emp_no = t.emp_no
GROUP BY t.title
HAVING avg_salary < 75000
ORDER BY avg_salary DESC;
