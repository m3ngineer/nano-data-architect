-- Question 1: Return a list of employees with Job Titles and Department Names
SELECT DISTINCT
  employee_nm, job_nm, dept_nm
FROM employee_hist hist
JOIN employees emp ON emp.employee_id = hist.employee_id
JOIN departments dept ON dept.dept_id = hist.hiring_dept_id
JOIN jobs ON jobs.job_id = hist.job_id;

-- Question 2: Insert Web Programmer as a new job title
INSERT INTO jobs (job_nm)
VALUES ('Web Programmer');

-- Question 3: Correct the job title from web programmer to web developer
UPDATE jobs
SET job_nm = 'Web Developer'
WHERE job_nm = 'Web Programmer';

-- Question 4: Delete the job title Web Developer from the database
DELETE FROM jobs
WHERE job_nm = 'Web Developer';

-- Question 5: How many employees are in each department?
SELECT dept_nm, count(hist.employee_id)
FROM employee_hist hist
JOIN departments dept ON dept.dept_id = hist.hiring_dept_id
GROUP BY dept_nm;

-- Question 6: Write a query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.
SELECT
  emp.employee_nm, job_nm, dept_nm, man.employee_nm AS manager_nm, start_date, end_date
FROM employee_hist hist
JOIN employees emp ON emp.employee_id = hist.employee_id
JOIN employees man ON man.employee_id = hist.manager_id
JOIN departments dept ON dept.dept_id = hist.hiring_dept_id
JOIN jobs ON jobs.job_id = hist.job_id
WHERE emp.employee_nm = 'Toni Lembeck';

-- Question 7: Describe how you would apply table security to restrict access to employee salaries using an SQL server.
-- ** answer in a short paragraph, how you would apply table security to restrict access to employee salaries

-- To restrict access to the employee salaries table I would only provide read permissions to users who were administrators or in the HR department

-- Create a view that returns all employee attributes; results should resemble initial Excel file
CREATE OR REPLACE VIEW employee_attr AS (
  SELECT DISTINCT
    emps.employee_id,
    emps.employee_nm,
    emps.email,
    jobs.job_nm AS job_title,
    sal.salary,
    dept.dept_nm,
    man.employee_nm AS manager_nm,
    hist.start_date,
    hist.end_date,
    loc.location_nm,
    add.address,
    cities.city_nm,
    states.state_code,
    edu.edu_lvl
  FROM employee_hist hist
  JOIN employees emps ON emps.employee_id = hist.employee_id
  JOIN jobs ON jobs.job_id = hist.job_id
  JOIN salaries sal ON sal.salary_id = hist.salary_id
  JOIN departments dept ON dept.dept_id = hist.hiring_dept_id
  JOIN employees man ON man.employee_id = hist.manager_id
  JOIN addresses add ON add.address_id = hist.address_id
  JOIN cities ON cities.city_id = add.city_id
  JOIN states ON states.state_id = cities.state_id
  JOIN locations loc ON loc.location_id = states.location_id
  JOIN education edu ON edu.edu_id = emps.education_id
);
