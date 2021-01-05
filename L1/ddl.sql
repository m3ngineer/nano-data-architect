CREATE TABLE jobs (
  job_id SERIAL PRIMARY KEY,
  job_nm varchar(50)
);

CREATE TABLE departments (
  dept_id SERIAL PRIMARY KEY,
  dept_nm varchar(50)
);

CREATE TABLE salaries (
  employee_id SERIAL PRIMARY KEY,
  salary INT
);

CREATE TABLE education (
  edu_id SERIAL PRIMARY KEY,
  edu_lvl varchar(25)
);

CREATE TABLE cities (
  city_id SERIAL PRIMARY KEY,
  city_nm varchar(50)
);

CREATE TABLE states (
  state_id SERIAL PRIMARY KEY,
  state_code varchar(50)
);

CREATE TABLE locations (
  location_id SERIAL PRIMARY KEY,
  location_nm varchar(50),
  city_id INT REFERENCES cities(city_id),
  state_id INT REFERENCES states(state_id)
);

CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,
  employee_nm varchar(50),
  email varchar(50),
  education_id INT REFERENCES education(edu_id)
);

CREATE TABLE employee_hist (
  id SERIAL PRIMARY KEY,
  employee_id INT REFERENCES,
  job_id INT REFERENCES jobs(job_id),
  start_date DATE,
  end_date DATE,
  hiring_dept_id INT REFERENCES departments(dept_id),
  location_id INT REFERENCES locations(location_id)
);
