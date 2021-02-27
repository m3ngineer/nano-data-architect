create database Yelp;
create schema STAGING;
create or replace file format json_format
  type = json
  ;

create or replace stage staging;

-- Create a target table for the JSON data
create or replace table yelp_business_raw (
  src variant
);

create or replace table yelp_review_raw (
  src variant
);

create or replace table yelp_checkin_raw (
  src variant
);

create or replace table yelp_user_raw (
  src variant
);

create or replace table yelp_tip_raw (
  src variant
);

create or replace table yelp_covid_features_raw (
  src variant
);

-- Load raw JSON from staging into target table
put file:///Users/mattheweng/Downloads/yelp_dataset/yelp_academic_dataset_business.json @staging auto_compress=true;
copy into yelp_business_raw from @staging/yelp_academic_dataset_business.json  file_format = (format_name =json_format) on_error = 'skip_file';

put file:///Users/mattheweng/Downloads/yelp_dataset/yelp_academic_dataset_review.json @staging auto_compress=true;
copy into yelp_review_raw from @staging/yelp_academic_dataset_review.json  file_format = (format_name =json_format) on_error = 'skip_file';

put file:///Users/mattheweng/Downloads/yelp_dataset/yelp_academic_dataset_checkin.json @staging auto_compress=true;
copy into yelp_checkin_raw from @staging/yelp_academic_dataset_checkin.json  file_format = (format_name =json_format) on_error = 'skip_file';

put file:///Users/mattheweng/Downloads/yelp_dataset/yelp_academic_dataset_user.json @staging auto_compress=true;
copy into yelp_user_raw from @staging/yelp_academic_dataset_user.json  file_format = (format_name =json_format) on_error = 'skip_file';

put file:///Users/mattheweng/Downloads/yelp_dataset/yelp_academic_dataset_tip.json @staging auto_compress=true;
copy into yelp_tip_raw from @staging/yelp_academic_dataset_tip.json  file_format = (format_name =json_format) on_error = 'skip_file';

put file:///Users/mattheweng/Downloads/covid_19_dataset_2020_06_10/yelp_academic_dataset_covid_features.json @staging auto_compress=true;
copy into yelp_covid_features_raw from @staging/yelp_academic_dataset_covid_features.json  file_format = (format_name =json_format) on_error = 'skip_file';
