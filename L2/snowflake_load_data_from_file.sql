CREATE OR REPLACE TABLE pickups (
  id integer not null,
  pickup_datetime datetime,
  dropoff_datetime datetime,
  Pickup_longitude float,
  Pickup_latitude float,
  Dropoff_longitude float,
  Dropoff_latitude float,
  Passenger_count integer,
  Trip_distance float,
  Fare_amount float,
  Total_amount float,
  pickup_date date,
  pickup_time string,
  dropoff_date date,
  dropoff_time string

)

put file:///Users/mattheweng/Downloads/Split_files/1st_1gb.csv @staging auto_compress=true;
put file:///Users/mattheweng/Downloads/Split_files/2nd_1gb.csv @staging auto_compress=true;
put file:///Users/mattheweng/Downloads/Split_files/2gb_file.csv @staging auto_compress=true;

copy into pickups from @staging/1st_1gb.csv file_format = (format_name = complex) on_error = 'continue';
copy into pickups from @staging/2nd_1gb.csv file_format = (format_name = complex) on_error = 'continue';
copy into pickups from @staging/2gb_file.csv file_format = (format_name = complex) on_error = 'continue';
