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
