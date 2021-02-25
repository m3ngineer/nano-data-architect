create database Yelp;
create schema  Public;
create or replace file format json_format
  type = json
  ;

create or replace stage ods file_format = json_format;

-- Load data from staging to ODS

create or replace table yelp_business (
  business_id string not null unique,
  name string,
  address string,
  city string,
  state string,
  postal_code string,
  latitude numeric,
  longitude numeric,
  stars numeric,
  review_count integer,
  is_open integer,
  BusinessAcceptsCreditCards string,
  BikeParking string,
  GoodForKids string,
  BusinessParking variant,
  ByAppointmentOnly string,
  RestaurantsPriceRange2 string,
  categories string,
  hours variant,
  constraint pk_business_id primary key(business_id)
);

INSERT INTO yelp_business
SELECT
    SRC:business_id,
    SRC:name,
    SRC:address,
    SRC:city,
    SRC:state,
    SRC:postal_code,
    SRC:latitude,
    SRC:longitude,
    SRC:stars,
    SRC:review_count,
    SRC:is_open,
    SRC:attributes:BusinessAcceptsCreditCards,
    SRC:attributes:BikeParking,
    SRC:attributes:GoodForKids,
    SRC:attributes:BusinessParking,
    SRC:attributes:ByAppointmentOnly,
    SRC:attributes:RestaurantsPriceRange2,
    SRC:categories,
    SRC:hours
FROM yelp_business_raw;


create or replace table yelp_reviews (
  review_id string not null unique,
  user_id string,
  business_id string,
  stars numeric,
  useful numeric,
  funny numeric,
  cool numeric,
  text numeric,
  date timestamp
  constraint pk_review_id primary key(review_id),
  constraint fk_review_id foreign key(business_id) references (business_id)
);

INSERT INTO yelp_reviews
SELECT
    SRC:review_id,
    SRC:user_id,
    SRC:business_id,
    SRC:stars,
    SRC:useful,
    SRC:funny,
    SRC:text,
    SRC:date
FROM yelp_reviews_raw;
