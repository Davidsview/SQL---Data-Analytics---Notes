#Exercise: Consider the employees' contracts that have been signed after the 1st of January 2000 and terminated 
-- before the 1st of January 2002 (as registered in the "dept_emp" table).
-- Create a MySQL query that will extract the following information about these employees:
-- Their employee number
-- The salary values of the latest contracts they have signed during the suggested time period
-- The department they have been working in (as specified in the latest contract they've signed during the suggested time period)
-- Use a window function to create a fourth field containing the average salary paid in the department the employee was last working
-- in during the suggested time period. Name that field "average_salary_per_department".

SELECT
de2.emp_no, d.dept_name, s2.salary, AVG(s2.salary) OVER w AS average_salary_per_department
FROM
(SELECT
de.emp_no, de.dept_no, de.from_date, de.to_date
FROM dept_emp de
JOIN
(SELECT
emp_no, MAX(from_date) AS from_date
FROM dept_emp
GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
WHERE
de.to_date < '2002-01-01'
AND de.from_date > '2000-01-01'
AND de.from_date = de1.from_date) de2
JOIN
(SELECT
s1.emp_no, s.salary, s.from_date, s.to_date
FROM salaries s
JOIN

(SELECT 
emp_no, 
MAX(from_date) AS from_date
FROM
salaries
GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
s.to_date < '2002-01-01'
AND s.from_date > '2000-01-01'
AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no
JOIN
departments d ON d.dept_no = de2.dept_no
GROUP BY de2.emp_no, d.dept_name
WINDOW w AS (PARTITION BY de2.dept_no)
ORDER BY de2.emp_no, salary;

SELECT
a.dept_no,
a.dept_name,
MIN(a.salary) AS min_salary,
MAX(a.salary) AS max_salary,
ROUND(AVG(a.salary)) AS avg_salary
FROM
(SELECT
de.dept_no,
d.dept_name,
s.salary
FROM salaries s
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no) a
GROUP BY
a.dept_no,
a.dept_name
ORDER BY
a.dept_no ASC;
