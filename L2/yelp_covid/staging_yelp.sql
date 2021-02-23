create database Yelp;
create schema  Public;
create or replace file format json_format
  type = json
  ;

create or replace stage staging file_format = json_format;

-- Create a target table for the JSON data
create or replace table yelp_business_raw (
  src variant
);

-- Load raw JSON from staging into target table
put file:///Users/mattheweng/Downloads/yelp_dataset/yelp_academic_dataset_business.json @staging auto_compress=true;
copy into yelp_business_raw from @staging/yelp_academic_dataset_business.json  file_format = (format_name =json_format) on_error = 'skip_file';
