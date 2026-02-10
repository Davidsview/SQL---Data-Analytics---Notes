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
