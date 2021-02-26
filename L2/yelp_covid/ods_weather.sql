create database Yelp;
create schema ODS;

-- Load data from staging to ODS

create or replace table weather_temperature (
  date date not null unique,
  min numeric,
  max numeric,
  normal_min numeric,
  normal_max numeric,
  constraint pk_date primary key(date)
);

INSERT INTO weather_temperature
SELECT
  date,
  min,
  max,
  normal_min,
  normal_max
FROM staging.weather_temperature
;

create or replace table weather_precipitation (
  date date not null unique,
  precipitation string,
  precipitation_normal numeric,
  constraint pk_date primary key (date),
  constraint fk_date foreign key (date) references weather_precipitation(date)
);

INSERT INTO weather_precipitation
SELECT
  date,
  precipitation,
  precipitation_normal
FROM staging.weather_precipitation
;
