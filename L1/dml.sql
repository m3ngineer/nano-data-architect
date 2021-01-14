-- load data into jobs table
Insert into jobs(job_nm)
SELECT DISTINCT job_title
FROM proj_stg stg;

-- load data into departments table
Insert into departments(dept_nm)
SELECT DISTINCT department_nm FROM proj_stg;

Insert into salaries(employee_id, salary)
SELECT DISTINCT Emp_ID, salary FROM proj_stg;

Insert into education(edu_lvl)
SELECT DISTINCT education_lvl FROM proj_stg;

Insert into cities(city_nm)
SELECT DISTINCT city FROM proj_stg;

Insert into states(state_code)
SELECT DISTINCT state FROM proj_stg;

Insert into locations(location_nm, city_id, state_id)
SELECT DISTINCT stg.location, cities.city_id, states.state_id FROM proj_stg stg
JOIN cities ON cities.city_nm = stg.city
JOIN states ON states.state_code = stg.state
;

Insert into employees(employee_id, employee_nm, email, education_id)
SELECT DISTINCT stg.Emp_ID, stg.Emp_NM, stg.Email, education.edu_id FROM proj_stg stg
JOIN education ON education.edu_lvl = stg.education_lvl
;

Insert into employee_hist(employee_id, job_id, start_date, end_date, hiring_dept_id, location_id)
SELECT DISTINCT
  stg.Emp_ID,
  jobs.job_id,
  stg.start_dt,
  stg.end_dt,
  dept.dept_id,
  loc.location_id
FROM proj_stg stg
JOIN jobs ON jobs.job_nm = stg.job_title
JOIN departments dept ON dept.dept_nm = stg.department_nm
JOIN locations loc ON loc.location_nm = stg.location
;
