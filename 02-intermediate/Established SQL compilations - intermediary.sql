#Now here's where things get a lot harder

#THE QUESTION: Assign employee no. 110022 as a manager to all employees FROM 10001 - 10020 (SUBSET A),
-- and employee no. 110039 as a manager to all employees from 10021 - 10040 (SUBSET B).
-- Such a simple task can end up looking like a big one - lets break it down block by block 
-- Because we'll be dealing with multiple selects - the UNION() function will be used.

SELECT 
    emp_no
FROM
    dept_manager
WHERE
    emp_no = 110022; #OUR FIRST INNER BLOCK IN THE SUBQUERY - SPECIFYING WHO we want from
    -- the managers table.
    
# Now, we will add this inner query to the select statement of an outer query.
-- REMEMBER subqueries can also be used in the SELECT function - not just the in the WHERE().
-- REMEMBER WHAT We want to show on our screens: the emp_no: < 10020, the dept_no, manager_ID:
-- proof that a new manager has been assigned: 110022. 
SELECT
e.emp_no AS Employee_ID,  MIN(de.dept_no) AS Department_Code, #We take the minimum value because more than one department could be associated with an employee and by using min, we will ensure we place only one value corresponding to an employee number.
(SELECT 
    emp_no
FROM
    dept_manager
WHERE
    emp_no = 110022) AS Manager_ID #NOW our 3 column titles will be Employee_ID, Department_Code and Manager_ID
FROM
employees e
JOIN
dept_emp de
ON e.emp_no = de.emp_no
WHERE
e.emp_no <= 10020 #what we are doing here is joining the employees in the Department Manager tables where no employee no. is greater than 10020.
GROUP BY e.emp_no
ORDER BY e.emp_no; #OUR FIRST SUBSET(A) COMPLETE

#NOW TO CREATE SUBSET B - Which won't be hard at all - all it is, is to copy and paste
-- and change a couple figures as well as put brackets around the entire subset A and assign
-- an alias called Subset A 

SELECT SUBSET_A.*
FROM  #Don't forget to put your OUTER SELECT() AND your FROM
(SELECT
e.emp_no AS Employee_ID,  MIN(de.dept_no) AS Department_Code, #We take the minimum value because more than one department could be associated with an employee and by using min, we will ensure we place only one value corresponding to an employee number.
(SELECT 
    emp_no
FROM
    dept_manager
WHERE
    emp_no = 110022) AS Manager_ID #NOW our 3 column titles will be Employee_ID, Department_Code and Manager_ID
FROM
employees e
JOIN
dept_emp de
ON e.emp_no = de.emp_no
WHERE
e.emp_no <= 10020 #what we are doing here is joining the employees in the Department Manager tables where no employee no. is greater than 10020.
GROUP BY e.emp_no
ORDER BY e.emp_no) AS SUBSET_A #You'll notice thaat if you should run it - it still remains the
-- same output - remember we just needed to assign a general name to this entire block of code
-- Let's slap the UNION in now - remember just copy and paste and rename

UNION SELECT SUBSET_B.*
FROM 						#ITS VERY EASY TO FORGET TO PUT 'FROM' AT TIMES LIKE THESE
(SELECT
e.emp_no AS Employee_ID,  MIN(de.dept_no) AS Department_Code, #We take the minimum value because more than one department could be associated with an employee and by using min, we will ensure we place only one value corresponding to an employee number.
(SELECT 
    emp_no
FROM
    dept_manager
WHERE
    emp_no = 110039) AS Manager_ID #Our manager_ID has now changed
FROM
employees e
JOIN
dept_emp de
ON e.emp_no = de.emp_no
WHERE
e.emp_no BETWEEN 10021 AND 10040 #We used the between operator here but we could've also just used the LIMIT operator and limited the change to 20 records but in all fairness - this gives clarity to whoever reads the code
GROUP BY e.emp_no
ORDER BY e.emp_no) AS SUBSET_B; -- JUST LIKE THAT - we now have 40 rows of data

SELECT * from departments;
#He's given us a new table to create for the next question:
-- Create the ‘emp_manager’ table, using the following code:

DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (

   emp_no INT(11) NOT NULL,

   dept_no CHAR(4) NULL,

   manager_no INT(11) NOT NULL

);

#Fill emp_manager with data about employees, the number of the department they are working in, and their managers.
#This next task was actually quite hard but tbh that's because we overthoguht it
-- The query skeleton he gave us to structure this task in: Insert INTO emp_manager SELECT
-- U.*
-- FROM
-- (A)
-- UNION (B) UNION (C) UNION (D) AS U;
-- A and B should be the same subsets used in the last lecture (SQL Subqueries Nested in SELECT and FROM). 
-- In other words, assign employee number 110022 as a manager to all employees from 10001 to 10020 (this must be subset A)
-- and employee number 110039 as a manager to all employees from 10021 to 10040 (this must be subset B).
-- Use the structure of subset A to create subset C, where you must assign employee number 110039 as a manager to employee 110022.
-- Following the same logic, create subset D. Here you must do the opposite - assign employee 110022 as a manager to employee 110039.
-- Your output must contain 42 rows.
#Originally when we tried this, we actually spiralled, idk why maybe at the time we was just mentally tired of everything. 
-- Now looking at how to do it, it's not that crazy to do.

Insert INTO emp_manager(emp_no, dept_no, manager_no)#By the end of all of this, each subset WILL retun these EXACT three columns.
SELECT  U.*
FROM
(  -- Subset A: employees 10001–10020 → manager 110022
SELECT SUBSET_AA.*
FROM  #Don't forget to put your OUTER SELECT() AND your FROM
(SELECT
e.emp_no AS Employee_ID,  MIN(de.dept_no) AS Department_Code, #We take the minimum value because more than one department could be associated with an employee and by using min, we will ensure we place only one value corresponding to an employee number.
(SELECT 
    emp_no
FROM
    dept_manager
WHERE
    emp_no = 110022) AS Manager_ID #NOW our 3 column titles will be Employee_ID, Department_Code and Manager_ID
FROM
employees e
JOIN
dept_emp de
ON e.emp_no = de.emp_no
WHERE
e.emp_no <= 10020 #what we are doing here is joining the employees in the Department Manager tables where no employee no. is greater than 10020.
GROUP BY e.emp_no
ORDER BY e.emp_no) AS SUBSET_AA

UNION
  -- Subset B: employees 10021–10040 → manager 110039
 SELECT SUBSET_BB.*
FROM 						#ITS VERY EASY TO FORGET TO PUT 'FROM' AT TIMES LIKE THESE
(SELECT
e.emp_no AS Employee_ID,  MIN(de.dept_no) AS Department_Code, #We take the minimum value because more than one department could be associated with an employee and by using min, we will ensure we place only one value corresponding to an employee number.
(SELECT 
    emp_no
FROM
    dept_manager
WHERE
    emp_no = 110039) AS Manager_ID #Our manager_ID has now changed
FROM
employees e
JOIN
dept_emp de
ON e.emp_no = de.emp_no
WHERE
e.emp_no BETWEEN 10021 AND 10040 #We used the between operator here but we could've also just used the LIMIT operator and limited the change to 20 records but in all fairness - this gives clarity to whoever reads the code
GROUP BY e.emp_no
ORDER BY e.emp_no) AS SUBSET_BB

UNION
-- Subset C: employee 110022 → manager 110039

SELECT SUBSET_C.*
FROM
(SELECT
e.emp_no AS Employee_ID,  MIN(de.dept_no) AS Department_Code, #We take the minimum value because more than one department could be associated with an employee and by using min, we will ensure we place only one value corresponding to an employee number.
(SELECT 
    emp_no
FROM
    dept_manager
WHERE
    emp_no = 110039) AS Manager_ID #Our manager_ID has now changed
FROM
employees e
JOIN
dept_emp de
ON e.emp_no = de.emp_no
WHERE
e.emp_no = 110022 #THIS IS THE ONLY DIFFERENCE BETWEEN THE OTHER TWO SUBSETS ABOVE - THIS IS ALL WE HAD TO CHANGE SURPRISINGLY LOOOOL
GROUP BY e.emp_no
ORDER BY e.emp_no) AS SUBSET_C

UNION 

SELECT SUBSET_D.*
FROM
(SELECT
e.emp_no, 
MIN(de.dept_no) AS Department_Code,
(SELECT
emp_no
FROM
    dept_manager
WHERE
    emp_no = 110022) AS Manager_ID
FROM
employees e
JOIN dept_emp de 
ON e.emp_no = de.emp_no
WHERE e.emp_no - 110039 #THIS IS THE ONLY DIFFERENCE BETWEEN THE OTHER TWO SUBSETS ABOVE - THIS IS ALL WE HAD TO CHANGE SURPRISINGLY LOOOOL
GROUP BY e.emp_no
ORDER BY e.emp_no) AS SUBSET_D
) AS U;

#AS GOOD AS ALL OF THIS IS - Like honestly well done, it's good to note that although our string of subqueries is now functional
-- We added redudant layers that we didn't need but what we wrote is very much LEGAL SQL
-- It's just not the simplest or most idiomatic way to do it.
-- Go to word to see what a more cleaner look would've looked like, we can't do it on here because that would further add duplicates of the same rows into our new table
-- HOWEVER IN hindsight how we've done it shows that its not our fault but we're just limited by our current teachings as the fix to the redundancy would've been understanding/implementing the use of foreign keys

SELECT *
FROM emp_manager;

SELECT 
    emp_no,
    title,
    (SELECT 
            ROUND(AVG(salary), 2)
        FROM
            salaries) AS avg_salary
FROM
    titles
    WHERE 
    title IN ('Staff', 'Engineer')
    ORDER BY avg_salary DESC; #This is wrong because this subquery calculates the same single average salary for all employees gathered
-- with no reference to emp_no
-- So every row now gets the same avg_salary value.
-- That’s not what the question wants. A subquery in the SELECT clause must be correlated to the outer query if it is meant to produce a different value per row.


# Select the employee number, job title, and the calculated average salary
SELECT
t.emp_no,                      # The employee number coming from the derived table 't'
t.title,                       # The job title (Staff or Engineer) for each employee

# Correlated subquery that calculates the average salary for THIS specific employee
(
SELECT 
ROUND(AVG(s.salary), 2)   # Calculate the average salary and round it to 2 decimal places
FROM 
salaries s                # Look at the salaries table
WHERE 
s.emp_no = t.emp_no)      # Match salary records to the current employee from the outer query - THIS IS WHAT WE ORIGINALLY MISSED
AS avg_salary                 # Name the calculated column 'avg_salary'

# Define the main dataset we are working with
FROM
(
# Subquery that selects only the employees and job titles we care about
SELECT 
emp_no,                      # Employee number from the titles table
title                        # Job title from the titles table
FROM  titles                       # Source table containing employee job titles
WHERE 
title IN ('Staff', 'Engineer') # Restrict results to Staff and Engineer roles only
) AS t                               # Alias the derived table so it can be referenced in the outer query
# Sort the final output by average salary from highest to lowest
ORDER BY 
avg_salary DESC;
#Key takeaway (worth writing down)
-- The subquery in the FROM clause defines which rows exist, while the correlated subquery in the SELECT clause defines a value calculated per row.

USE employees;
#The aim here is to create a routine that will produce the first 1,000 employees whenever we call it.


DELIMITER // #Refer back to our word notes to understand why we use dolar signs
CREATE PROCEDURE select_employees()
BEGIN

SELECT * 
FROM employees
LIMIT 1000;

END //
DELIMITER ; #SQL is a weirdo, it wont explicitly tell us our procedure is working like it does with everything else because it's a procedure

SELECT 1; # A way to confirm our procedure works
-- If this piece of code runs after creating a procedure, then our procedure has been established and our delimiter state is clean and we can now run it
# if instead it fails to run then we kknow the delimiter is stuck, if this was the case then we'd need to do either one:
-- 1)Disconnect → reconnect the MySQL session
-- 2) Close the SQL tab → reopen
-- 3) Open a new SQL tab and paste only your non-procedure query


CALL select_employees(); #it works.

#Why professionals separate scripts (important)
# In real environments:
-- procedures live in migration files
-- queries live in run files
-- you never mix them
-- That’s why our experience felt clunky — we were doing both in one place.



#QUESTION Create a procedure that will provide the average salary of all employees.
-- Then, call the procedure.

DELIMITER //
CREATE PROCEDURE avg_salary()
BEGIN 

SELECT
e.emp_no,
e.first_name, 
e.last_name,
(SELECT
ROUND(AVG(s.salary),2)
FROM salaries s
WHERE e.emp_no = s.emp_no) AS avgE_salary
FROM 
employees e;

END //
DELIMITER ;

#Another way of creating procedures in a MORE efficient way s to do it from the schemas tab, LOOK AT THAT just when you learn something, there ends up being an easier way to do it. 
 
 #This next skill we're going to learn is actually really interesting and is built on our new learned skill with procedures
 
 DELIMITER $$
# Temporarily changes the SQL statement delimiter from ';' to '$$' ('//' can also be used to achieve the same outcome.
# This is required so MySQL does not end the procedure definition
# when it encounters semicolons inside the procedure body.

USE employees $$
# Explicitly confirms that the procedure is created inside the employees database.

CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
# Creates a stored procedure named emp_salary.
# It accepts one INPUT parameter:
# p_emp_no (represents parameter) → the employee number supplied when the procedure is called.
#INTEGER indicates the type of data that is stored in p_emp_no

BEGIN
# Marks the beginning of the procedure’s executable block.

SELECT
    e.first_name,
    e.last_name,
    s.salary,
    s.from_date,
    s.to_date
# Specifies the data we want returned when the procedure is executed:
# employee name details and their salary history.

FROM
    employees e
# Uses the employees table and assigns it the alias 'e' for readability.

JOIN
    salaries s ON e.emp_no = s.emp_no
# Joins the salaries table to employees using emp_no,
# linking each employee to their salary records.

WHERE
    e.emp_no = p_emp_no;
# Filters the result to ONLY the employee whose emp_no
# matches the value passed into the procedure.

END$$
# Ends the procedure definition.
# '$$' is used instead of ';' because we changed the delimiter earlier.



DELIMITER ;
# Resets the delimiter back to the standard semicolon.
# This tells MySQL we are finished defining the procedure.

#QUESTION: Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual,
-- and returns their employee number.
DROP PROCEDURE IF EXISTS emp_info;

DELIMITER //
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(50), IN p_last_name VARCHAR(50), OUT pemp_no INT) #So Workbench will show an input box for the OUT parameter, which feels like it’s asking us
-- to type the OUTCOME — but it’s actually asking: "What variable should I store the output in?" I see it as just SQL mental reminder to return the employee number
BEGIN
SELECT
e.emp_no
INTO pemp_no FROM 
employees e
WHERE e.first_name = p_first_name AND
e.last_name = p_last_name
LIMIT 1; #We use the LIMIT 1 feature because we have some recurring names e.g. 'Georgi Facello' in our database and this procedure is only programmed to retrieve 1 row, so if it encounters multiple rows
-- with the same value it will get confused and return ERROR, so this just ensures that even if it encounters multiple rows, it should still return 1 row.
END//
DELIMITER ;

CALL emp_info('Georgi', 'Facello', @pemp_no);
SELECT @pemp_no;


#Lecturer's example:
DELIMITER $$
# Changes the statement delimiter so MySQL can correctly parse the function body,
# which contains semicolons.

CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER)
RETURNS DECIMAL(10,2)
# Creates a function named f_emp_avg_salary.
# It takes one input parameter (p_emp_no) p representing the parameters being an employee number.
# The function returns a DECIMAL value with 10 total digits and 2 decimal places,
# which is suitable for monetary values.

BEGIN

DECLARE v_avg_salary DECIMAL(10,2);
# Declares a local variable inside the function to store the calculated average salary. (NOTICE HOW THE DATA TYPE HAS TO MATCH THE RETURN VALUE ABOVE)
# This variable exists only during the function execution.

SELECT
    AVG(s.salary)
INTO
    v_avg_salary
# Calculates the average salary for the specified employee
# and stores the result in the local variable v_avg_salary.
FROM
    employees e
    JOIN salaries s ON e.emp_no = s.emp_no
# Joins the employees and salaries tables using emp_no
# to access salary records belonging to the employee.

WHERE
    e.emp_no = p_emp_no;
# Filters the data so only salary records for the input employee are considered.

RETURN v_avg_salary;
# Returns the value stored in v_avg_salary as the output of the function.

END$$
# Ends the function definition using the custom delimiter.

DELIMITER ;
# Resets the delimiter back to the default semicolon.

#QUESTION: Create a function called ‘emp_info2’ that takes for parameters the first and last name of an employee,
-- and returns the salary from the newest contract of that employee.
Drop Function IF EXISTS emp_info2 ;
DELIMITER //

CREATE FUNCTION emp_info2 (p_firstname VARCHAR(50), p_lastname VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC #THIS STOPS A WEIRD SQL ERROR CODE FROM OCCURRING: ERROR CODE 1418
BEGIN

DECLARE v_max_from_date DATE;

DECLARE v_salary DECIMAL(10,2); #IF we want more than one variable we have to declare it twice

 SELECT
MAX(from_date)
INTO v_max_from_date FROM
employees e
JOIN
salaries s ON e.emp_no = s.emp_no
WHERE
e.first_name = p_firstname
AND e.last_name = p_lastname;

#AND THIS IS HOW WE LEARN WE DONT NEED TO USE UNION IN CREATING A FUNCTION/PROCEDURE
SELECT
s.salary
INTO v_salary FROM
employees e
JOIN
salaries s ON e.emp_no = s.emp_no
WHERE
e.first_name = p_firstname
AND e.last_name = p_lastname
AND s.from_date = v_max_from_date;

RETURN v_salary;

END//

DELIMITER ;

SELECT EMP_INFO2('Aruna', 'Journel'); #You'll notice in the results we still only get the salary despite declaring bot from date and salary? 
-- This is because we stated before beginning to only return DECIMAL (10,2) - SO SQL WAS ALWAYS GOING TO RETURN ONE OUTPUT
-- and that output was going to be the variable with the corresponding data type as the RETURN: v_salary


