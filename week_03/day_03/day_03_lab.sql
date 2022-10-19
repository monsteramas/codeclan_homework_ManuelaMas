/*
 * 1 MVP
 */

/* Question 1.
How many employee records are lacking both a grade and salary?
*/

SELECT count(*)
FROM employees
WHERE grade = 0 AND salary IS NULL;



/* Question 2.
Produce a table with the two following fields (columns):
- the department
- the employees full name (first and last name)
Order your resulting table alphabetically by department, and then by last name.
*/

SELECT 
    department,
    concat(first_name, ' ', last_name) AS full_name
FROM employees;



/* Question 3.
Find the details of the top ten highest paid employees 
who have a last_name beginning with ‘A’.
*/

SELECT *
FROM employees
WHERE last_name LIKE 'A%' AND salary IS NOT NULL 
ORDER BY salary DESC 
LIMIT 10;



/*
 * Question 4.
Obtain a count by department of the employees 
who started work with the corporation in 2003.
 */

SELECT 
    department,
    count(*) AS start_in_2003
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department ;



/*
 * Question 5.
Obtain a table showing department, fte_hours and the number of employees 
in each department who work each fte_hours pattern. 
Order the table alphabetically by department, 
and then in ascending order of fte_hours.

Hint
You need to GROUP BY two columns here.
 */

SELECT 
    department,
    fte_hours,
    count(id) AS n_employees
FROM employees 
GROUP BY fte_hours, department 
ORDER BY department, fte_hours;



/*
 * Question 6.
Provide a breakdown of the numbers of employees enrolled, not enrolled, 
and with unknown enrollment status in the corporation pension scheme.
 */

SELECT 
    DISTINCT (pension_enrol),
    count(id)
FROM employees 
GROUP BY pension_enrol ;



/*
 * Question 7.
Obtain the details for the employee with the highest salary 
in the ‘Accounting’ department who is not enrolled in the pension scheme.
 */

SELECT *
FROM employees 
WHERE department = 'Accounting' AND pension_enrol = FALSE AND salary IS NOT NULL 
ORDER BY salary DESC 
LIMIT 1;



/*
 * Question 8.
Get a table of country, number of employees in that country, 
and the average salary of employees in that country 
for any countries in which more than 30 employees are based. 
Order the table by average salary descending.

Hints
A HAVING clause is needed to filter using an aggregate function.

You can pass a column alias to ORDER BY.
 */

SELECT 
    country ,
    count(id) AS n_employees,
    round(avg(salary)) AS avg_salary
FROM employees 
GROUP BY country 
HAVING count(id) > 30
ORDER BY avg(salary);



/*
 * Question 9.
 Return a table containing each employees first_name, last_name, 
 full-time equivalent hours (fte_hours), salary, 
 and a new column effective_yearly_salary which should contain 
 fte_hours multiplied by salary. 
 Return only rows where effective_yearly_salary is more than 30000.
 */


SELECT 
    first_name,
    last_name,
    fte_hours,
    salary,
    round (fte_hours * salary) AS effective_yearly_salary
FROM employees 
WHERE round (fte_hours * salary) > 30000
ORDER BY effective_yearly_salary;



/*
 * Question 10.
 Find the details of all employees in either Data Team 1 or Data Team 2.
  
 Hint
 name is a field in table `teams.
 */


SELECT *
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id 
WHERE t."name" = 'Data Team 1' OR t.name = 'Data Team 2'
ORDER BY t."name";



/*
 * Question 11.
 * Find the first name and last name of all employees who lack a local_tax_code.
 */

SELECT 
    first_name,
    last_name,
    pd.local_tax_code 
FROM employees AS e
LEFT JOIN pay_details AS pd 
ON e.id = pd.id 
WHERE pd.local_tax_code IS NULL;



/*
 * Question 12.
 The expected_profit of an employee is defined as 
 (48 * 35 * charge_cost - salary) * fte_hours, where charge_cost 
 depends upon the team to which the employee belongs. 
 Get a table showing expected_profit for each employee.
  
 Hints
 charge_cost is in teams, while salary and fte_hours are in employees, 
 so a join will be necessary.
 
 You will need to change the type of charge_cost in order to 
 perform the calculation.
 */

SELECT
    e.id,
    e.first_name,
    e.last_name,
    round((48 * 35 * CAST(t.charge_cost AS int) - e.salary)) * e.fte_hours AS expected_profit
FROM employees AS e
LEFT JOIN teams AS t 
ON t.id = e.team_id;

-- if the default for the 'round' function is '0', why do I get decimals?



/*
 Question 13. [Tough]
 Find the first_name, last_name and salary of the lowest paid employee 
 in Japan, who works the least common full-time equivalent hours 
 across the corporation.
  
 Hint
 You will need to use a subquery to calculate the mode.
 */

/* My subquery: First calculate:
who works the least common full-time equivalent hours 
across the corporation.
 */



SELECT 
    fte_hours,
    count(fte_hours) AS n_fte
FROM employees 
GROUP BY fte_hours
ORDER BY n_fte
LIMIT 1;

-- the result is nested below:

SELECT 
    fte_hours
FROM
    (
        SELECT
            fte_hours,
            count(fte_hours) AS n_fte
        FROM
            employees
        GROUP BY
            fte_hours
        ORDER BY
            n_fte
        LIMIT 1
    ) AS least_common_hours;

-- then nested again in place of 0.5 (least_common_hours) below:

SELECT 
    first_name,
    last_name,
    salary 
FROM employees 
WHERE country = 'Japan' AND fte_hours = 0.5
ORDER BY salary 
LIMIT 1;

-- the final query is:

SELECT 
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    country = 'Japan'
    AND fte_hours = (
        SELECT
            fte_hours
        FROM
            (
                SELECT
                    fte_hours,
                    count(fte_hours) AS n_fte
                FROM
                    employees
                GROUP BY
                    fte_hours
                ORDER BY
                    n_fte
                LIMIT 1
            ) AS least_common_hours
    )
ORDER BY
    salary
LIMIT 1;




/*
 * Question 14.
Obtain a table showing any departments in which there are 
two or more employees lacking a stored first name. 
Order the table in descending order of the number of employees 
lacking a first name, and then in alphabetical order by department.
 */

SELECT 
    department, 
    count(id) AS n_employees_no_name
FROM employees 
WHERE first_name IS NULL 
GROUP BY department 
HAVING count(id) >= 2;



/*
 * Question 15. [Bit tougher]
 Return a table of those employee first_names shared 
 by more than one employee, together with a count of the number 
 of times each first_name occurs. 
 Omit employees without a stored first_name from the table. 
 Order the table descending by count, and then alphabetically by first_name.
 */

SELECT 
    DISTINCT (first_name),
    count(first_name) AS double_names
FROM employees 
WHERE first_name IS NOT NULL 
GROUP BY first_name 
HAVING count(id) > 1
ORDER BY double_names DESC, first_name;



/*
 * Question 16. [Tough] 
 Find the proportion of employees in each department who are grade 1.
  
 Hints 
  
 Think of the desired proportion for a given department 
 as the number of employees in that department who are grade 1, 
 divided by the total number of employees in that department.
  
 You can write an expression in a SELECT statement, e.g. grade = 1. 
 This would result in BOOLEAN values.
  
 If you could convert BOOLEAN to INTEGER 1 and 0, you could sum them. 
 The CAST() function lets you convert data types.
  
 In SQL, an INTEGER divided by an INTEGER yields an INTEGER. 
 To get a REAL value, you need to convert the top, 
 bottom or both sides of the division to REAL.
 */

-- wanted output:
-- department, percentage (n_emp_gr_1_dep / n_emp_dep)
-- training, 0.11


SELECT 
    department,
    sum(CAST ((grade = 1) AS int)) /
    CAST(count(id) AS REAL) AS percentage_grade_1
FROM employees
GROUP BY department 
ORDER BY department;



   































