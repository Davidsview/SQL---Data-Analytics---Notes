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
UNION 
SELECT
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
