
#Exercise 1 - obtain a result set containing the employee number, first name, and last name
-- of all employees with a number higher than 109990. Create a fourth column in the query,
-- indicating whether this employee is also a manager, according to the data provided in the dept_manager table, or a regular employee. 
SELECT 
e.emp_no,
e.first_name,
e.last_name,
CASE
WHEN dm.emp_no IS NOT NULL THEN 'Manager'
ELSE 'Employee'
END AS is_manager
FROM 
employees e
LEFT JOIN
dept_manager dm ON dm.emp_no = e.emp_no
WHERE e.emp_no > '109990';

#Exercise 2 - Extract a dataset containing the following information about the managers:
-- employee number, first name, and last name. Add two columns at the end –
-- one showing the difference between the maximum and minimum salary of that employee,
-- and another one saying whether this salary raise was higher than $30,000 or NOT.
SELECT 
dm.emp_no,
e.first_name,
e.last_name,
MAX(s.salary) - MIN(s.salary) AS salary_difference,
CASE
WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN "Salary raise higher than 30000"
ELSE "Salary raise was NOT higher than 30,000"
END AS raise_inquisition
FROM 
employees e
JOIN
dept_manager dm
ON e.emp_no = dm.emp_no
JOIN
salaries s
ON dm.emp_no = s.emp_no
GROUP BY s.emp_no; #Remember when using aggrgate functions we need to group by

#ANOTHER WAY USING THE IF() SYNTAX
SELECT  
dm.emp_no,  
e.first_name,  
e.last_name,  
MAX(s.salary) - MIN(s.salary) AS salary_difference,  
IF(MAX(s.salary) - MIN(s.salary) > 30000, 'Salary was raised by more then $30,000', 'Salary was NOT raised by more then $30,000') AS salary_increase  
FROM  
dept_manager dm  
JOIN  
employees e ON e.emp_no = dm.emp_no  
JOIN  
salaries s ON s.emp_no = dm.emp_no  
GROUP BY s.emp_no;

SELECT
e.emp_no, 
e.first_name,
e.last_name,
CASE
WHEN MAX(de.to_date) < SYSDATE() THEN "No longer employed"#We've just learned a new function SYSDATE()
-- it returns the exact date and time according to the database sever 
-- so essetially we're saying if the employees to-date ISN'T greater than the current time of today, then they're no longer an employee, but if their to-date is greater than today then they're still employed
ELSE "Still an employee" 
END AS current_employee
FROM 
employees e
JOIN dept_emp de
ON e.emp_no = de.emp_no
GROUP BY de.emp_no
LIMIT 100;
-- SYSDATE() is normally used for timestaps, flitering recent data and what have you etc.


SELECT * FROM dept_emp;
SELECT 
dm.emp_no,
e.first_name,
e.last_name,
e.hire_date,
MIN(s.salary) AS min_salary,
MAX(s.salary) AS max_salary,
MAX(s.salary) - MIN(s.salary) AS salary_difference,
CASE 
WHEN MAX(s.salary) - MIN(s.salary) <= 10000 AND MAX(s.salary) - MIN(s.salary) > 0 
    THEN 'insignificant'
        WHEN MAX(s.salary) - MIN(s.salary) > 10000 THEN 'significant'
        ELSE 'salary decrease'
END AS salary_rise
FROM salaries s
JOIN dept_manager dm
ON s.emp_no = dm.emp_no
JOIN employees e 
ON dm.emp_no = e.emp_no
WHERE dm.emp_no > 10005 
GROUP BY dm.emp_no,
    e.first_name,
    e.last_name,
    e.hire_date; #The mistake we made was trying to also group by aliases
-- the second mistake was forgetting to group by the other columns

SELECT 
e.emp_no,
e.first_name,
e.last_name,
CASE 
WHEN MAX(de.to_date) > '2024-12-31' THEN "Currently working" #REMEMBER employees can have multiple contracts and because of that SQL won't know which one to use to run the query, 
-- thats why we have to remember to use MAX() so it utilises the most recent one - literally spent 10 mins wondering what i was doing wrong over the LITTLES ISSUE - sigh, this is how we learn nonetheless
ELSE "No longer with the company"
END as current_status
FROM 
employees e 
JOIN 
dept_emp de 
ON e.emp_no = de.emp_no
WHERE e.emp_no = de.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name;
