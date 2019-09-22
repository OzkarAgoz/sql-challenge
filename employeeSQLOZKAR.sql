DROP TABLE departments;
DROP TABLE dept_emp;
DROP TABLE dept_manager;
DROP TABLE employees;
DROP TABLE salaries;
DROP TABLE titles;

CREATE TABLE departments
(dept_no character varying(10) PRIMARY KEY,
  dept_name character varying(50));

ALTER TABLE departments 
RENAME COLUMN dept_no TO dept_noPK;

--ALTER TABLE dept_emp  DROP CONSTRAINT emp_no;
--ALTER TABLE departments  ADD CONSTRAINT dept_no  PRIMARY KEY (dept_no);
--REFERENCES must be linked to a primary key
--FOREIGN KEY (dept_name) REFERENCES so_headers (dept_name)

select * from departments;

COPY departments(dept_nopk,dept_name) 
FROM '/Users/ozkaragoz/project/EmployeeSQL/departments.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE dept_emp
(emp_no character varying(10) REFERENCES employees(emp_no),
  dept_no varchar REFERENCES departments(dept_noPK),
  from_date date, to_date date);

select * from dept_emp;

COPY dept_emp(emp_no, dept_no, from_date, to_date) 
FROM '/Users/ozkaragoz/project/EmployeeSQL/dept_emp.csv' DELIMITER ',' CSV HEADER;
----------------------------------------------- this is for exercise only
select emp_no, dept_no, dept_name 
from departments, dept_emp
where departments.dept_nopk = dept_emp.dept_no;
----------------------------------------------- exercise ends
CREATE TABLE dept_manager
(dept_no character varying(10) REFERENCES departments(dept_nopk),
  emp_no varchar(10) REFERENCES employees(emp_no), from_date date, to_date date);

ALTER TABLE dept_manager 
RENAME COLUMN to_date TO to_dateMGR;

select * from dept_manager;

COPY dept_manager(dept_no, emp_no, from_date, to_date) 
FROM '/Users/ozkaragoz/project/EmployeeSQL/dept_manager.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE employees
(emp_no character varying(10) PRIMARY KEY, birth_date date, first_name VARCHAR, last_name VARCHAR, gender VARCHAR, 
 hire_date date, to_date date);

ALTER TABLE employees 
RENAME COLUMN emp_no TO emp_noPK;

select * from employees;

COPY employees(emp_no, birth_date, first_name, last_name, gender, hire_date) 
FROM '/Users/ozkaragoz/project/EmployeeSQL/employees.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE salaries
(emp_no character varying(10) REFERENCES employees(emp_no), salary INT, from_date date, to_date date);

select * from salaries;

COPY salaries(emp_no, salary, from_date, to_date) 
FROM '/Users/ozkaragoz/project/EmployeeSQL/salaries.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE titles
(emp_no character varying(10) REFERENCES employees(emp_no), title VARCHAR, from_date date, to_date date);

select * from titles;

COPY titles(emp_no, title, from_date, to_date) 
FROM '/Users/ozkaragoz/project/EmployeeSQL/titles.csv' DELIMITER ',' CSV HEADER;

-------------------------------------------------------------------------------------------

--List the following details of each employee: employee number, last name, first name, gender, and salary.
select emp_noPK, last_name, first_name, gender, salary
from employees, salaries
where employees.emp_noPK = salaries.emp_no;

--List employees who were hired in 1987.
select first_name, last_name, hire_date
FROM employees
where hire_date BETWEEN '1986-12-31' AND '1988-01-01';

--List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
select dept_nopk, dept_name, emp_nopk, last_name, first_name, from_date, to_dateMGR
from dept_manager, departments, employees
where employees.emp_noPK = dept_manager.emp_no
  AND departments.dept_noPK = dept_manager.dept_no;

--List the department of each employee with the following information: employee number, last name, first name, and department name.
select emp_nopk, last_name, first_name, dept_name
from employees, departments, dept_emp
where employees.emp_noPK = dept_emp.emp_no
  AND departments.dept_noPK = dept_emp.dept_no;

--List all employees whose first name is "Duangkaew" and last names begin with "P."
select first_name, last_name
from employees
where first_name = 'Duangkaew'
AND last_name like 'P%';

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
select emp_nopk, last_name, first_name, dept_name
from employees, departments, dept_emp
where employees.emp_noPK = dept_emp.emp_no
  AND departments.dept_noPK = dept_emp.dept_no
  AND dept_name IN
(
  SELECT dept_name
  FROM departments
  WHERE dept_name IN ('Sales')
);

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
select emp_nopk, last_name, first_name, dept_name
from employees, departments, dept_emp
where employees.emp_noPK = dept_emp.emp_no
  AND departments.dept_noPK = dept_emp.dept_no
  AND dept_name IN
(
  SELECT dept_name
  FROM departments
  WHERE dept_name IN ('Sales', 'Development')
);

--In ascending order, list the frequency count of employee last names, i.e., how many employees share each last name.
select last_name, 
count(last_name) as "Total_Employee" 
from employees 
group by last_name
order by "last_name" asc;

---------------------------------------------------------------------------------------------------------------------














