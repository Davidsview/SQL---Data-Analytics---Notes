SELECT *
FROM departments;

SELECT * FROM employees
WHERE #Use of where statements (conditional)
	gender = 'F' AND (first_name = 'Kellie' OR first_name = 'Aruna'); 
#In situations where we're using the AND and OR statements in the same ordeal, remember to put brackets around the conditions pertaining to the OR statement due to how SQL reads the AND statement first. This is because without the brackets, we would've also gotten male names who are also called aruna or kellie and not just females


SELECT * FROM employees
WHERE
first_name IN ('Cathie', 'Mark', 'Nathan'); #We use the In operator when our list of retrieval is greater than 2.
#the IN operator allows SQL to return the names written in parentheses
#This route is also more efficient than the one above
#IF we were to use the NOT IN operator - every name other than Cathie, Mark and Nathan would be displayed

SELECT * FROM employees
WHERE first_name NOT IN ('John', 'Mark', 'Jacob');

#Sometimes we're looking for a specific patern in a column e.g. "First 3 letters of names beginning with 'Mar' - "Mar%" we'd therefore use % as this is a substitute for a sequence of characters, so the output would look like Marvs, Martin, Malvitto
#In other times we know the first 3 letters of the pattern we're looking for but we can't remember the last character, thats where underscore comes in - it helps match a single character e.g. "Mar_", our output would  look like Marv, Marn, Marl.
#For the remainder of notes, find it on word.

SELECT * FROM employees
WHERE hire_date LIKE ('%2000%'); #This gives us the names of employees employed from the year 2000, notice how theres a % at the beginning and the end used to isolate that particulate year

SELECT * FROM employees
WHERE emp_no LIKE ('1000_'); #Retrieve a list with all employees whose employee number is written with 5 characters, and starts with “1000”. 


#The question: Use the LIKE operator with the _ character to retrieve all records from the employees table for employees born in the 1950s.
SELECT * FROM employees
WHERE birth_date LIKE ('%195_%');

#The Question: Select all the information from the “salaries” table regarding contracts from 66,000 to 70,000 dollars per year.
SELECT * from salaries
WHERE salary BETWEEN '66000' AND '70000';

#The Question: Retrieve a list with all individuals whose employee number is not between ‘10004’ and ‘10012’.
SELECT * FROM employees
WHERE emp_no NOT BETWEEN '1004' AND '10012';

#The Question: Select the names of all departments with numbers between ‘d003’ and ‘d006’.
SELECT * FROM departments
WHERE dept_no BETWEEN 'd003' AND 'd006';

#The Question: Use the NOT BETWEEN ... AND ... operator to retrieve all records of employees from the employees table whose employee number is either less than or equal to 10002 or greater than or equal to 10009.
SELECT * FROM employees
WHERE emp_no NOT BETWEEN '10003' AND '10008'; #THIS ONE ORIGINALLY STUMPED ME - REMEMBER IT - It's crazy coz in hindsight it actually wasn't that hard.

#Select the names of all departments whose department number value is not null.
SELECT dept_name FROM departments
WHERE dept_no IS NOT NULL;

#The Question: Retrieve a list with data about all female employees who were hired in the year 2000 or after.
SELECT * FROM employees
WHERE 
gender = 'F' AND hire_date LIKE ('2000%');
#OR we could've done it like this:
SELECT * FROM employees
WHERE
hire_date >= '2000-01-01' AND gender = 'F';

SELECT * FROM salaries
WHERE salary > '150000';

#The Question: Use a comparison operator to retrieve all records from the employees table for female employees hired after 1985.
SELECT * FROM employees
WHERE hire_date > '1986-01-01' AND gender = 'F'; #See how we put 1986 and not 1985 - thats where they keep tripping us up, but we figured it out on our own this time

SELECT DISTINCT hire_date FROM employees;

#The question: How many annual contracts with a value higher than or equal to $100,000 have been registered in the salaries table?
SELECT count(salary) FROM salaries
WHERE salary >= '100000';
#another way to have gotten the answer:
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= 100000;

#How many managers do we have in the “employees” database?
SELECT count(*) FROM dept_manager;

#The Question: Select all data from the “employees” table, ordering it by “hire date” in descending order.
SELECT * FROM employees
ORDER BY hire_date DESC;

#This was a tricky one but we sure showed them: Write a query that obtains an output whose first column must contain annual salaries higher than 80,000 dollars. The second column, renamed to “emps_with_same_salary”, must show the number of employee contracts signed with this salary.
SELECT salary, COUNT(emp_no) AS emps_with_same_salary
FROM salaries
WHERE salary > 80000
GROUP BY salary
order by salary;

#QUESTION: Select all employees whose average salary is higher than $120,000 per annum. 
#Hint: You should obtain 101 records.
SELECT emp_no, AVG(salary) AS avg_salary
FROM salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY avg_salary ASC;

#Comparing our results with that of the lecturers - THEY DONT WORK - this was given to us - I think he was trying to prove a dumb point or something idk.
SELECT *, AVG(salary)
FROM salaries
WHERE
salary > 120000
GROUP BY emp_no 
ORDER BY emp_no;

SELECT
*, AVG(salary)
FROM
salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;

#QUESTION: Select the employee numbers of all individuals who have signed more than 1 contract after the 1st of January 2000.
-- I came back after learning more about SQL and trid something I recently learned teehee - proud of you Bolu. We used the LEFT JOIN function to add the first name of the employees, so we also know the names of the corresponding emp_no
SELECT e.first_name, e.last_name, d.emp_no, COUNT(d.from_date) AS repeated_con
FROM dept_emp d
LEFT JOIN employees e
ON d.emp_no = e.emp_no  #this is what we used to justify joining the dept_emp table and the employees table
WHERE d.from_date > '2000-01-01'
GROUP BY d.emp_no
HAVING COUNT(d.from_date) > 1
ORDER BY e.first_name ASC;

#QUESTION: Select the first 100 rows from the ‘dept_emp’ table. 
SELECT * FROM dept_emp
LIMIT 100;

#QUESTION: Ordered by employee number (emp_no) in descending order, retrieve the first five rows of output from the department-employees table (dept_emp).
SELECT *  
FROM dept_emp
ORDER BY emp_no DESC
LIMIT 5;

#How many departments are there in the “employees” database? Use the ‘dept_emp’ table to answer the question.
SELECT COUNT(DISTINCT dept_no) #Notice how we used DISTINCT? because if we didn't we would've got a value of like 30000 or some nonsense like that but we know that's only because there were repeated departments
FROM dept_emp;

SELECT SUM(salary) 
FROM salaries
WHERE from_date > '1997-01-01';

select MAX(emp_no) from salaries;

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

#Lecturers ORDERS: Go forward to the solution and execute the query;
--  What do you think is the meaning of the minus sign before subset A in the last row (ORDER BY -a.emp_no DESC)?
-- Explanation of what is happening here with more clear commentary is on our word doc
SELECT * FROM
(SELECT
e.emp_no,
e.first_name,
e.last_name,
NULL AS dept_no,
NULL AS from_date
FROM
employees e
WHERE
last_name = 'Denis' 
UNION SELECT
NULL AS emp_no,
NULL AS first_name,
NULL AS last_name,
dm.dept_no,
dm.from_date
FROM
dept_manager dm) 
AS a ORDER BY -a.emp_no DESC;


#QUESTION: Use UNION to combine data from two subsets in the employees_10 database. The first subset should contain the employee number (emp_no), 
-- first name (first_name), and last name (last_name) of all employees whose family name is 'Bamford'.
-- The second subset should contain the department number (dept_no) and start date (from_date) of all managers, as recorded in the
-- departments manager table (dept_manager). Ensure to provide null values in all empty columns for each subset.
SELECT * FROM 
(SELECT 
e.emp_no,
e.first_name,
e.last_name,
NULL AS dept_no,
NULL AS from_date
FROM employees e
WHERE e.last_name = 'Bamford'
UNION SELECT 
NULL AS emp_no,
NULL AS first_name,
NULL AS last_name,
dm.dept_no,
dm.from_date
FROM dept_manager dm)
AS question; #Subqueries must be assigned aliases - hmm who knew. If I hadn't asigned it as 'question we wouldn't have been able to run it.

#ORIGINAL QUESTION: Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.
SELECT dm.dept_no
FROM
dept_manager dm
WHERE dm.emp_no IN (SELECT
e.emp_no
FROM employees e
WHERE e.hire_date BETWEEN '1990-01-01' AND '1995-01-01')
;

#I then took it a step-further, because the sequence above doesn't give first or last names so it's not as useful as it could be, so what did we do?
-- WE put a sub-query in another sub-query!!!! 
SELECT e.emp_no AS Managers_emp_no, e.first_name, e.last_name #This will give us the end result of the question
FROM 
employees e
WHERE e.emp_no IN (SELECT
dm.emp_no 						#This joins the employees table with the department managers table
FROM dept_manager dm
WHERE dm.emp_no IN (SELECT
e.emp_no 					#THIS TIME AROUND HOWEVER - THIS JOINS THE department mangers table WITH the employees table
FROM employees e
WHERE e.hire_date BETWEEN '1990-01-01' AND '1995-01-01')); #This employee sub-query sets the conditions we want - managers hired between those dates
-- it then returns it back to the department manager sub-query which was used to only gather managers
-- AND THEN finally we return it back once again to the employees table which was used to depict more useful information
-- - the outer query will always be the one that is shown in the results, thats why we done it
#I'm so bloody smart
#icl though - I think JOINS would've been alot easier but heyho. He later said it is easier in some situations later on in the vid - explanation in word.




#QUESTION: USING THE EXISTS function
SELECT e.* FROM 
employees e
WHERE EXISTS
(SELECT *
FROM titles t
WHERE e.emp_no = t.emp_no
AND t.title = "Assistant Engineer")
;

#END OF TRIAL SQL COMPILATIONS - WELL DONE 4


