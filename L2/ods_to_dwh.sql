-- Load data from ODS to data warehouse

DROP TABLE IF EXISTS dim_complex;
DROP TABLE IF EXISTS dim_employees;
DROP TABLE IF EXISTS dim_facilities;
DROP TABLE IF EXISTS dim_high_touch_areas;
DROP TABLE IF EXISTS dim_rooms;
DROP TABLE IF EXISTS dim_frequency;
DROP TABLE IF EXISTS dim_floors;
DROP TABLE IF EXISTS dim_cleaning_schedule;
DROP TABLE IF EXISTS dim_protocols;

CREATE TABLE dim_complex (
  complex_id integer not null unique,
  complex_name string
);

INSERT INTO dim_complex
SELECT
    complex_id,
    complex_name
FROM ods.complex;


CREATE TABLE dim_employees (
  employee_id integer not null unique,
  first_name string,
  last_name string,
  badge_status string,
  remote_office string
);

INSERT INTO dim_employees
SELECT
    employee_id,
    first_name,
    last_name,
    badge_status,
    remote_office
FROM ods.employees;

CREATE TABLE dim_facilities (
  building_id integer not null unique,
  building_name string,
  sqft string,
  complex_id integer
);

INSERT INTO dim_facilities
SELECT
  building_id,
  building_name,
  sqft,
  complex_id
FROM ods.facilities;

CREATE TABLE dim_high_touch_areas (
  spot_id integer not null unique,
  high_touch_areas string
);

INSERT INTO high_touch_areas
SELECT
  spot_id,
  high_touch_areas
FROM ods.high_touch_areas;

CREATE TABLE dim_protocols (
  protocol_id integer not null unique,
  step_id integer,
  step_name string
);

INSERT INTO dim_protocols
SELECT
  protocol_id,
  step_id,
  step_name
FROM ods.protocols;

CREATE TABLE dim_floors (
  floor_id integer not null unique,
  floor_name string,
  building_id integer
);

INSERT INTO dim_floors
SELECT
  floor_id,
  floor_name,
  building_id
FROM ods.floors;


CREATE TABLE dim_rooms (
  room_id integer not null unique,
  room_name string,
  floor_id integer,
  building_id integer,
  total_area integer,
  area_cleaned integer
);

INSERT INTO dim_rooms
SELECT
  room_id,
  room_name,
  floor_id,
  building_id,
  total_area,
  area_cleaned
FROM ods.rooms;


CREATE TABLE dim_frequency (
  frequency_id integer not null unique,
  frequency string,
  building_id integer
);

INSERT INTO dim_frequency
SELECT
  frequency_id,
  frequency,
  building_id
FROM ods.frequency;

CREATE TABLE fct_cleaning_schedule (
  transaction_id integer not null unique,
  employee_id integer,
  first_name string,
  last_name string,
  step_id integer,
  step_name string,
  spot_id integer,
  high_touch_area string,
  frequency_id integer,
  frequency integer,
  room_id integer,
  room_name string,
  floor_id integer,
  floor_name string,
  building_id integer,
  building_name string,
  complex_id integer,
  complex_name string,
  sqft string,
  total_area string,
  cleaned_area string,
  cleaned_on string,
  test_value number,
  efficiency number
  constraint pk_transaction_id primary key (transaction_id),
  constraint fk_frequency_id foreign key (frequency_id) references ods.frequency(frequency_id),
  constraint fk_building_id foreign key (building_id) references ods.facilities(building_id),
  constraint fk_floor_id foreign key (floor_id) references ods.floors(floor_id),
  constraint fk_room_id foreign key (room_id) references ods.rooms(room_id),
  constraint fk_employee_id foreign key (employee_id) references ods.employees(employee_id),
  constraint fk_spot_id foreign key (spot_id) references ods.high_touch_areas(spot_id)
  constraint fk_complex_id foreign key (complex_id) references ods.complex(complex_id)
);

INSERT INTO fct_cleaning_schedule
  SELECT DISTINCT
  e.employee_id,
  e.first_name,
  e.last_name,
  p.step_id,
  p.step_name,
  hta.spot_id,
  hta.high_touch_area,
  fr.frequency_id,
  fr.frequency,
  c.complex_id,
  c.complex_name,
  fa.building_id,
  fa.building_name,
  fl.floor_id,
  fl.floor_name,
  r.room_id,
  r.room_name,
  fa.sqft,
  fa.total_area,
  sched.cleaned_area,
  sched.cleaned_on,
  sched.test_value,
  sched.efficiency
FROM ods.cleaning_schedule sched
JOIN ods.employees e ON e.employee_id = sched.employee_id
JOIN ods.protocols p ON p.step_id = sched.step_id
JOIN ods.high_touch_areas hta ON hta.spot_id = sched.spot_id
JOIN ods.frequency fr ON fr.frequency_id = sched.frequency_id
JOIN ods.complex c ON c.complex_id = sched.complex_id
JOIN ods.facilities fa ON fa.building_id = sched.building_id
JOIN ods.floors ON fl fl.floor_id = sched.floor_id
JOIN ods.rooms r ON r.room_id = sched.room_id
;
