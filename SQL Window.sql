use hrdata;

/******************************************************************************************************/
/* FIRST VALUE*/
-- 1. Find the employee having the lowest salary
SELECT first_name, last_name, salary,
FIRST_VALUE(CONCAT(first_name, ' ', last_name)) OVER(
ORDER BY salary) lowest_salary
FROM employees;

-- 2. Find the employee with the lowest salary in each department
SELECT e.first_name, e.last_name, d.department_name, e.salary,
FIRST_VALUE(CONCAT(e.first_name, ' ', e.last_name)) OVER (
PARTITION BY d.department_name
ORDER BY salary) lowest_salary
FROM employees e 
INNER JOIN departments d ON e.department_id = d.department_id;

/******************************************************************************************************/
/*LAG*/
-- 1. Return employee's current year's salary as well as previous year's salary
SELECT employee_id, fiscal_year, salary,
LAG (salary) OVER (
partition by employee_id
order by salary) previous_salary
FROM basic_pays;

/****************************************************************************************************/
/*LAST VALUE*/
-- 1. Find the employees with the highest salary
SELECT first_name, last_name, salary,
LAST_VALUE(CONCAT(first_name, ' ', last_name)) OVER (
ORDER BY salary
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) highest_salary
from employees;

-- 2. Find the employee with the highest salary across departments
SELECT e.first_name, e.last_name, d.department_name, e.salary,
LAST_VALUE(CONCAT(e.first_name, ' ', e.last_name)) OVER (
PARTITION BY d.department_name
ORDER BY e.salary
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) highest_salary
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

/****************************************************************************************************/
/*LEAD*/
-- 1. For each employee hired, return the hire date of the employee hired just after

SELECT first_name, last_name, hire_date,
LEAD(hire_date,1) OVER (
ORDER BY hire_date) next_hire_date
FROM employees;

-- 2. For each employee hired, return the hire date of the employee from the same department hired just after

SELECT e.first_name, e.last_name, d.department_name, e.hire_date,
LEAD(e.hire_date,1, 'NA') OVER (
PARTITION BY d.department_name
ORDER BY e.hire_date) next_hire_date
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

/****************************************************************************************************/
/*DENSE RANK*/
-- 1. Rank employees by the salary
SELECT employee_id, first_name, last_name, salary,
DENSE_RANK() OVER (
ORDER BY salary desc) as salary_rank
FROM employees;

-- 2. Find employees with the highest salary across each departments (Use sub query in the from clause)

SELECT * FROM 
(SELECT e.employee_id, e.first_name, e.last_name, d.department_name, e.salary,
DENSE_RANK() OVER (
PARTITION BY d.department_name
ORDER BY e.salary desc) as salary_rank
FROM employees e JOIN departments d
ON e.department_id = d.department_id) a
WHERE a.salary_rank = 1;

-- 3. Find the employees with the highest salary for each year
SELECT * FROM
(SELECT employee_id, fiscal_year, salary,
DENSE_RANK() OVER (
PARTITION BY fiscal_year
ORDER BY salary desc) as salary_rank
FROM basic_pays) t
WHERE t.salary_rank = 1;

/****************************************************************************************************/
/*NTILE*/
-- 1. Divide the employees into 5 buckets/groups based on the salary
SELECT employee_id, first_name, last_name, salary,
NTILE(5)OVER(
ORDER BY SALARY desc) salary_bucket
FROM employees;

-- 2. Divide the employees into 2 groups based on salary for each department
SELECT e.employee_id, e.first_name, e.last_name, d.department_name, e.salary,
NTILE(2) OVER(
PARTITION BY d.department_name
ORDER BY e.salary desc) as salary_bucket
FROM employees e JOIN departments d
ON e.department_id = d.department_id;

/****************************************************************************************************/
/*RANK*/

-- 1. Rank employees by the salary
SELECT employee_id, first_name, last_name, salary,
RANK()OVER(
ORDER BY salary desc) as salary_rank
FROM employees;

-- 2. Rank employees by the salary for each department
SELECT e.employee_id, e.first_name, e.last_name, d.department_name, e.salary,
RANK()OVER(
PARTITION BY d.department_name
ORDER BY e.salary desc) salary_rank
FROM employees e join departments d
ON e.department_id = d.department_id;

/****************************************************************************************************/
/*ROW NUMBER*/

-- 1. Add a sequential number to each row
SELECT ROW_NUMBER() OVER(
ORDER BY salary) row_num,
employee_id, first_name, last_name, salary
FROM employees;