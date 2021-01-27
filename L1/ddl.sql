
DROP TABLE IF EXISTS jobs CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;
DROP TABLE IF EXISTS education CASCADE;
DROP TABLE IF EXISTS states CASCADE;
DROP TABLE IF EXISTS cities CASCADE;
DROP TABLE IF EXISTS addresses CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS employee_hist CASCADE;

CREATE TABLE jobs (
  job_id SERIAL PRIMARY KEY,
  job_nm varchar(50)
);

CREATE TABLE departments (
  dept_id SERIAL PRIMARY KEY,
  dept_nm varchar(50)
);

CREATE TABLE salaries (
  salary_id SERIAL PRIMARY KEY,
  salary INT
);

CREATE TABLE education (
  edu_id SERIAL PRIMARY KEY,
  edu_lvl varchar(50)
);

CREATE TABLE states (
  state_id SERIAL PRIMARY KEY,
  state_code varchar(2)
);

CREATE TABLE cities (
  city_id SERIAL PRIMARY KEY,
  city_nm varchar(50),
  state_id INT REFERENCES states(state_id)
);

CREATE TABLE addresses (
  address_id SERIAL PRIMARY KEY,
  address VARCHAR(50),
  location_nm varchar(50),
  city_id INT REFERENCES cities(city_id)
);

CREATE TABLE employees (
  employee_id varchar(8) PRIMARY KEY,
  employee_nm varchar(50),
  email varchar(100),
  education_id INT REFERENCES education(edu_id)
);

CREATE TABLE employee_hist (
  id SERIAL PRIMARY KEY,
  employee_id VARCHAR(8) REFERENCES employees(employee_id),
  job_id INT REFERENCES jobs(job_id),
  start_date DATE,
  end_date DATE,
  hiring_dept_id INT REFERENCES departments(dept_id),
  location_id INT REFERENCES locations(location_id),
  salary_id INT REFERENCES salaries(salary_id)
);
