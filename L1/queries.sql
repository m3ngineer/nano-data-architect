-- Question 1: Return a list of employees with Job Titles and Department Names
SELECT employee_nm FROM employees

-- Question 2: Insert Web Programmer as a new job title
INSERT INTO jobs (job_nm)
VALUES ('Web Programmer');

-- Question 3: Correct the job title from web programmer to web developer
UPDATE jobs
SET job_nm = 'Web Developer'
WHERE job_nm = 'Web Programmer'
VALUES ('Web Programmer');

-- Question 4: Delete the job title Web Developer from the database
DELETE FROM jobs
WHERE job_nm = 'Web Developer'


-- Question 5: How many employees are in each department?
SELECT department_nm, count(hist.employee_id)
FROM employee_hist hist
JOIN departments dept ON dept.dept_id = hist.hiring_dept_id;

-- Question 6: Write a query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.
SELECT employee_nm, job_nm, dept_nm,

-- Question 7: Describe how you would apply table security to restrict access to employee salaries using an SQL server.
-- ** answer in a short paragraph, how you would apply table security to restrict access to employee salaries
