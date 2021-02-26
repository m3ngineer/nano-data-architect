create database Yelp;
create schema STAGING;
create or replace file format csv_format_weather
  type = csv
  FIELD_DELIMITER = ','
  RECORD_DELIMITER = '\n'
  skip_header = 1
  null_if = ('NULL', 'null')
  empty_field_as_null = true
  compression = gzip
  error_on_column_count_mismatch=false
  DATE_FORMAT='YYYYMMDD'
  ;

create or replace stage staging file_format = csv_format_weather;

create or replace table weather_precipitation (
  date date,
  precipitation string,
  precipitation_normal numeric
);

put file:///Users/mattheweng/Downloads/USW00023169_precipitation.csv @staging auto_compress=true;
copy into weather_precipitation from @staging/USW00023169_precipitation.csv  file_format = (format_name = csv_format_weather) on_error = 'continue';

create or replace table weather_temperature (
  date date,
  min numeric,
  max numeric,
  normal_min numeric,
  normal_max numeric
);

put file:///Users/mattheweng/Downloads/USW00023169_temperature.csv @staging auto_compress=true;
copy into weather_temperature from @staging/USW00023169_temperature.csv  file_format = (format_name = csv_format_weather) on_error = 'continue';
