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

#This was a tricky one but we sure showed them:
-- Write a query that obtains an output whose first column must contain annual salaries higher than 80,000 dollars.
-- The second column, renamed to “emps_with_same_salary”, must show the number of employee contracts signed with this salary.
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
