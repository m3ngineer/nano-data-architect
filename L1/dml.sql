
-- load data into jobs table
Insert into jobs(job_nm)
SELECT DISTINCT job_title
FROM proj_stg stg;

-- load data into departments table
Insert into departments(dept_nm)
SELECT DISTINCT department_nm FROM proj_stg;

Insert into salaries(salary)
SELECT DISTINCT salary FROM proj_stg;

Insert into education(edu_lvl)
SELECT DISTINCT education_lvl FROM proj_stg;

Insert into locations(location_nm)
SELECT DISTINCT location FROM proj_stg;

Insert into states(state_code, location_id)
SELECT DISTINCT proj_stg.state, loc.location_id FROM proj_stg
JOIN locations loc ON loc.location_nm = proj_stg.location
;

Insert into cities(city_nm, state_id)
SELECT DISTINCT city, states.state_id FROM proj_stg
JOIN states ON states.state_code = proj_stg.state
;

Insert into addresses(address, city_id)
SELECT DISTINCT stg.address, cities.city_id FROM proj_stg stg
JOIN cities ON cities.city_nm = stg.city
;

Insert into employees(employee_id, employee_nm, email, education_id)
SELECT DISTINCT stg.Emp_ID, stg.Emp_NM, stg.Email, education.edu_id FROM proj_stg stg
JOIN education ON education.edu_lvl = stg.education_lvl
;

Insert into employee_hist(employee_id, job_id, hire_date, start_date, end_date, manager_id, hiring_dept_id, address_id, salary_id)
SELECT DISTINCT
  stg.Emp_ID,
  jobs.job_id,
  stg.hire_dt,
  stg.start_dt,
  stg.end_dt,
  emp.employee_id,
  dept.dept_id,
  add.address_id,
  sal.salary_id
FROM proj_stg stg
JOIN jobs ON jobs.job_nm = stg.job_title
JOIN employees emp ON emp.employee_nm = stg.manager
JOIN departments dept ON dept.dept_nm = stg.department_nm
JOIN addresses add ON add.address = stg.address
JOIN salaries sal ON sal.salary = stg.salary
;
