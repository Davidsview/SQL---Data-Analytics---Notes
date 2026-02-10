#QUESTION: Select the first 100 rows from the ‘dept_emp’ table. 
SELECT * FROM dept_emp
LIMIT 100;

#QUESTION: Ordered by employee number (emp_no) in descending order, retrieve the first five rows of output from the department-employees table (dept_emp).
SELECT *  
FROM dept_emp
ORDER BY emp_no DESC
LIMIT 5;

#How many departments are there in the “employees” database? Use the ‘dept_emp’ table to answer the question.
SELECT COUNT(DISTINCT dept_no) #Notice how we used DISTINCT? because if we didn't we would've got a value of like 30000 or some nonsense like that 
-- but we know that's only because there were repeated departments
FROM dept_emp;

SELECT SUM(salary) 
FROM salaries
WHERE from_date > '1997-01-01';

select MAX(emp_no) from salaries;
