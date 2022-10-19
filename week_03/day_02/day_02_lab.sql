/* 
 * MVP
 */


/*
 * Q1(a). Find the first name, last name and team name of employees 
 * who are members of teams.
 * 
 * We only want employees who are also in the teams table. 
 * So which type of join should we use?
 */
 

SELECT 
    e.first_name ,
    e.last_name ,
    t."name" 
FROM employees AS e
INNER JOIN teams AS t 
ON t.id = e.team_id;


/*
 * Q1(b). Find the first name, last name and team name of employees who 
 * are members of teams and are enrolled in the pension scheme.
 */

SELECT 
    e.first_name ,
    e.last_name ,
    t."name" 
FROM employees AS e
INNER JOIN teams AS t 
ON t.id = e.team_id
WHERE e.pension_enrol = TRUE;


/*
 * Q1(c). Find the first name, last name and team name of employees 
 * who are members of teams, where their team has a charge cost 
 * greater than 80.
 * 
 * Hints:
 * Charge_cost may be the wrong type to compare with value 80. 
 * Can you find a way to convert it without changing the database?
 */

SELECT 
    e.first_name ,
    e.last_name ,
    t."name" 
FROM employees AS e
INNER JOIN teams AS t 
ON t.id = e.team_id
WHERE cast(t.charge_cost AS int ) > 80;


/*
 * Q2(a). Get a table of all employees details, together with 
 * their local_account_no and local_sort_code, if they have them.
 * 
 * Hints:
 * local_account_no and local_sort_code are fields in pay_details, 
 * and employee details are held in employees, so this query requires a JOIN.
 * 
 * What sort of JOIN is needed if we want details of all employees, 
 * even if they don’t have stored local_account_no and local_sort_code?
 */


SELECT *
FROM employees AS e
LEFT  JOIN pay_details AS pd 
ON pd.id = e.id ;


/* 
 * Q2(b). Amend your query above to also return the name of the team 
 * that each employee belongs to.
 */

SELECT *
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id;


/*
 * Q3(a). Make a table, which has each employee id along with 
 * the team that employee belongs to.
 */


SELECT
    e.id AS employee_id,
    t."name" 
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
ORDER BY employee_id;

/*
 * Q3(b). Breakdown the number of employees in each of the teams.
 * 
 * Hint: You will need to add a group by to the table you created above.
 */


SELECT
    t."name" ,
    count(e.id)
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id;


/* Q3(c). Order the table above by so that the teams 
 * with the least employees come first.
 */

SELECT
    t."name" ,
    count(e.id)
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
ORDER BY count(e.id);


/* Q4(a). Create a table with the team id, team name and 
 * the count of the number of employees in each team.
 * 
 * Hint: If you GROUP BY teams.id, because it’s the primary key, 
 * you can SELECT any other column of teams that you want 
 * (this is an exception to the rule that normally 
 * you can only SELECT a column that you GROUP BY).
 */

SELECT 
    t.id,
    t."name",
    count(t.id)
FROM teams AS t
INNER JOIN employees AS e 
ON t.id = e.team_id 
GROUP BY t.id;


/* Q4(b). The total_day_charge of a team is defined as the charge_cost 
 * of the team multiplied by the number of employees in the team. 
 * Calculate the total_day_charge for each team.
 */

SELECT 
    t.id,
    t."name",
    t.charge_cost,
    count(t.id) AS employee_count,
    CAST(t.charge_cost AS int) * count(t.id) AS total_day_charge
FROM teams AS t
INNER JOIN employees AS e 
ON t.id = e.team_id 
GROUP BY t.id;


/* Q4(c). How would you amend your query from above to show only 
 * those teams with a total_day_charge greater than 5000?
 */

SELECT 
    t.id,
    t."name",
    t.charge_cost,
    count(t.id) AS employee_count,
    CAST(t.charge_cost AS int) * count(t.id) AS total_day_charge
FROM teams AS t
INNER JOIN employees AS e 
ON t.id = e.team_id 
GROUP BY t.id
HAVING (CAST(t.charge_cost AS int) * count(t.id)) > 5000;




/* 
 * Extension
 */

/*
 * Q5 - How many of the employees serve on one or more committees?
 * 
 * Hints: All of the details of membership of committees is held 
 * in a single table: employees_committees, so this doesn’t require a join.
 * 
 * Some employees may serve in multiple committees. 
 * Can you find the number of distinct employees who serve?
 *  
 * [Extra hint - do some research on the DISTINCT() function].
 */

-- cannot make it work, don't understand the documentation
SELECT DISTINCT employee_id
FROM employees_committees
GROUP BY committee_id ;


/*
 * Q6 - How many of the employees do not serve on a committee?
 * 
 * Hints: This requires joining over only two tables.
 * 
 * Could you use a join and find rows without a match in the join?
 */


SELECT 
    count(e.id) AS n_employees_not_in_committee
FROM employees_committees AS ec 
RIGHT JOIN employees AS e
ON ec.employee_id = e.id
WHERE ec.employee_id IS NULL;   




























