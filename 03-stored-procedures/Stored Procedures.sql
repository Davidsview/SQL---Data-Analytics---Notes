USE employees;
#The aim here is to create a routine that will produce the first 1,000 employees whenever we call it.


DELIMITER // #Refer back to our word notes to understand why we use dolar signs
CREATE PROCEDURE select_employees()
BEGIN

SELECT * 
FROM employees
LIMIT 1000;

END //
DELIMITER ; #SQL is a weirdo, it won't explicitly tell us our procedure is working like it does with everything else because it's a procedure

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
