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

#Comparing our results with that of the lecturers - THEY DONT WORK - this was given to us - I think he was trying to prove a point or something idk.
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
-- I came back after learning more about SQL and tried something I recently learned teehee - proud of you David.
-- We used the LEFT JOIN function to add the first name of the employees, so we also know the names of the corresponding emp_no
SELECT e.first_name, e.last_name, d.emp_no, COUNT(d.from_date) AS repeated_con
FROM dept_emp d
LEFT JOIN employees e
ON d.emp_no = e.emp_no  #this is what we used to justify joining the dept_emp table and the employees table
WHERE d.from_date > '2000-01-01'
GROUP BY d.emp_no
HAVING COUNT(d.from_date) > 1
ORDER BY e.first_name ASC;
