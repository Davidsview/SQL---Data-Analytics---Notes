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
