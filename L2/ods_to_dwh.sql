-- Load data from ODS to data warehouse

DROP TABLE IF EXISTS complex;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS facilities;
DROP TABLE IF EXISTS high_touch_areas;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS frequency;
DROP TABLE IF EXISTS floors;
DROP TABLE IF EXISTS cleaning_schedule;
DROP TABLE IF EXISTS protocols;

CREATE TABLE complex (
  complex_id integer not null unique,
  complex_name string,
  constraint pk_complex_id primary key(complex_id)
);

INSERT INTO complex
SELECT
    complex_id,
    complex_name
FROM ods.complex;


CREATE TABLE employees (
  employee_id integer not null unique,
  first_name string,
  last_name string,
  badge_status string,
  remote_office string,
  constraint pk_employee_id primary key (employee_id)
);

INSERT INTO employees
SELECT
    employee_id,
    first_name,
    last_name,
    badge_status,
    remote_office
FROM ods.employees;

CREATE TABLE facilities (
  building_id integer not null unique,
  building_name string,
  sqft string,
  complex_id integer,
  constraint pk_building_id primary key (building_id),
  constraint fk_complex_id foreign key (complex_id) references complex(complex_id)
);

INSERT INTO facilities
SELECT
  building_id,
  building_name,
  sqft,
  complex_id
FROM ods.facilities;

CREATE TABLE high_touch_areas (
  spot_id integer not null unique,
  high_touch_areas string,
  constraint pk_spot_id primary key (spot_id)
);

INSERT INTO high_touch_areas
SELECT
  spot_id,
  high_touch_areas
FROM ods.high_touch_areas;

CREATE TABLE protocols (
  protocol_id integer not null unique,
  step_id integer,
  step_name string,
  constraint pk_protocol_id primary key(protocol_id)
);

INSERT INTO protocols
SELECT
  protocol_id,
  step_id,
  step_name
FROM ods.protocols;

CREATE TABLE floors (
  floor_id integer not null unique,
  floor_name string,
  building_id integer,
  constraint pk_floor_id primary key (floor_id),
  constraint fk_building_id foreign key (building_id) references facilities(building_id)
);

INSERT INTO floors
SELECT
  floor_id,
  floor_name,
  building_id
FROM ods.floors;


CREATE TABLE rooms (
  room_id integer not null unique,
  room_name string,
  floor_id integer,
  building_id integer,
  total_area integer,
  area_cleaned integer,
  constraint pk_room_id primary key (room_id),
  constraint fk_floor_id foreign key (floor_id) references floors(floor_id),
  constraint fk_building_id foreign key (building_id) references facilities(building_id)
);

INSERT INTO rooms
SELECT
  room_id,
  room_name,
  floor_id,
  building_id,
  total_area,
  area_cleaned
FROM ods.rooms;


CREATE TABLE frequency (
  frequency_id integer not null unique,
  frequency string,
  building_id integer,
  constraint pk_frequency_id primary key (frequency_id),
  constraint fk_building_id foreign key (building_id) references facilities(building_id)
);

INSERT INTO frequency
SELECT
  frequency_id,
  frequency,
  building_id
FROM ods.frequency;

CREATE TABLE cleaning_schedule (
  transaction_id integer not null unique,
  step_id integer,
  cleaned_on string,
  frequency_id integer,
  building_id integer,
  floor_id integer,
  room_id integer,
  employee_id integer,
  spot_id integer,
  test_value number,
  efficiency number,
  constraint pk_transaction_id primary key (transaction_id),
  constraint fk_frequency_id foreign key (frequency_id) references frequency(frequency_id),
  constraint fk_building_id foreign key (building_id) references facilities(building_id),
  constraint fk_floor_id foreign key (floor_id) references floors(floor_id),
  constraint fk_room_id foreign key (room_id) references rooms(room_id),
  constraint fk_employee_id foreign key (employee_id) references employees(employee_id),
  constraint fk_spot_id foreign key (spot_id) references high_touch_areas(spot_id)
);

INSERT INTO cleaning_schedule
SELECT
  transaction_id,
  step_id,
  cleaned_on,
  frequency_id,
  building_id,
  floor_id,
  room_id,
  employee_id,
  spot_id,
  test_value,
  efficiency
FROM ods.cleaning_schedule;
