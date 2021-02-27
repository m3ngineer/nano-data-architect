create database Yelp;
create schema DWH;

-- Load data from ODS to Datawarehouse

-- Yelp Business
create or replace table dim_yelp_business (
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
  hours variant
);

INSERT INTO dim_yelp_business
SELECT
    business_id,
    name,
    address,
    city,
    state,
    postal_code,
    latitude,
    longitude,
    stars,
    review_count,
    is_open,
    BusinessAcceptsCreditCards,
    BikeParking,
    GoodForKids,
    BusinessParking,
    ByAppointmentOnly,
    RestaurantsPriceRange2,
    categories,
    hours
FROM ods.yelp_business;

--  Yelp Reviews
create or replace table dim_yelp_review (
  review_id string not null unique,
  user_id string,
  business_id string,
  stars numeric,
  useful numeric,
  funny numeric,
  cool numeric,
  text string,
  date timestamp
);

INSERT INTO dim_yelp_review
SELECT
    review_id,
    user_id,
    business_id,
    stars,
    useful,
    funny,
    cool,
    text,
    date
FROM ods.yelp_review;

--  Yelp Checkin
create or replace table dim_yelp_checkin (
  business_id string not null unique,
  date string
);

INSERT INTO dim_yelp_checkin
SELECT
    business_id,
    date
FROM ods.yelp_checkin;

--  Yelp User
create or replace table dim_yelp_user (
  user_id string not null unique,
  name string,
  review_count numeric,
  yelping_since timestamp,
  useful numeric,
  funny numeric,
  cool numeric,
  elite string,
  friends string,
  fans numeric,
  average_stars numeric,
  compliment_hot numeric,
  compliment_more numeric,
  compliment_profile numeric,
  compliment_cute numeric,
  compliment_list numeric,
  compliment_note numeric,
  compliment_plain numeric,
  compliment_cool numeric,
  compliment_funny numeric,
  compliment_writer numeric,
  compliment_photos numeric
);

INSERT INTO dim_yelp_user
SELECT
  user_id,
  name,
  review_count,
  yelping_since,
  useful,
  funny,
  cool,
  elite,
  friends,
  fans,
  average_stars,
  compliment_hot,
  compliment_more,
  compliment_profile,
  compliment_cute,
  compliment_list,
  compliment_note,
  compliment_plain,
  compliment_cool,
  compliment_funny,
  compliment_writer,
  compliment_photos
FROM ods.yelp_user;

-- Yelp Tip
create or replace table dim_yelp_tip (
  user_id string not null unique,
  business_id string,
  text string,
  date timestamp,
  compliment_count numeric
);

INSERT INTO dim_yelp_tip
SELECT
  user_id,
  business_id,
  text,
  date,
  compliment_count
FROM ods.yelp_tip;

-- Yelp Covid Features
create or replace table dim_yelp_covid_features (
  business_id string not null unique,
  highlights string,
  delivery_or_takeout string,
  grubhub_enabled string,
  call_to_action_enabled string,
  request_quote_enabled string,
  covid_banner string,
  temporary_closed_until string,
  virtual_services string
);

INSERT INTO dim_yelp_covid_features
SELECT
    business_id,
    highlights,
    delivery_or_takeout,
    grubhub_enabled,
    call_to_action_enabled,
    request_quote_enabled,
    covid_banner,
    temporary_closed_until,
    virtual_services
FROM ods.yelp_covid_features;


-- Weather Temperature
create or replace table dim_weather_temperature (
  date date not null unique,
  min numeric,
  max numeric,
  normal_min numeric,
  normal_max numeric
);

INSERT INTO dim_weather_temperature
SELECT
  date,
  min,
  max,
  normal_min,
  normal_max
FROM ods.weather_temperature
;

-- Weather Precipitation
create or replace table dim_weather_precipitation (
  date date not null unique,
  precipitation numeric,
  precipitation_normal numeric
);

INSERT INTO dim_weather_precipitation
SELECT
  date,
  (CASE WHEN precipitation = 'T' THEN NULL ELSE precipitation END) AS precipitation,
  precipitation_normal
FROM ods.weather_precipitation
;

-- Fact Table
create or replace table fct_yelp_review_weather (
  -- business
  business_id string,
  name string,
  address string,
  city string,
  state string,
  postal_code string,
  latitude numeric,
  longitude numeric,
  business_stars numeric,
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
  -- review
  review_id string not null unique,
  user_id string,
  review_stars numeric,
  review_useful numeric,
  review_funny numeric,
  review_cool numeric,
  review_text string,
  review_datetime timestamp,
  review_date date,
  -- user
  user_name string,
  user_review_count numeric,
  yelping_since timestamp,
  user_useful numeric,
  user_funny numeric,
  user_cool numeric,
  user_elite string,
  user_friends string,
  user_fans numeric,
  user_average_stars numeric,
  -- weather
  precipitation numeric,
  precipitation_normal numeric,
  temp_min numeric,
  temp_max numeric,
  temp_normal_min numeric,
  temp_normal_max numeric
);

INSERT INTO fct_yelp_review_weather
SELECT
  -- business
  yb.business_id,
  yb.name AS business_name,
  yb.address,
  yb.city,
  yb.state,
  yb.postal_code,
  yb.latitude,
  yb.longitude,
  yb.stars AS business_stars,
  yb.review_count,
  yb.is_open,
  yb.BusinessAcceptsCreditCards,
  yb.BikeParking,
  yb.GoodForKids,
  yb.BusinessParking,
  yb.ByAppointmentOnly,
  yb.RestaurantsPriceRange2,
  yb.categories,
  yb.hours,
  -- review
  yr.review_id,
  yr.user_id,
  yr.stars AS review_stars,
  yr.useful AS review_useful,
  yr.funny AS review_funny,
  yr.cool AS review_cool,
  yr.text AS review_text,
  yr.date AS review_datetime,
  yr.date::DATE AS review_date,
  -- user
  yu.name AS user_name,
  yu.review_count AS user_review_count,
  yu.yelping_since,
  yu.useful AS user_useful,
  yu.funny AS user_funny,
  yu.cool AS user_cool,
  yu.elite AS user_elite,
  yu.friends AS user_friends,
  yu.fans AS user_fans,
  yu.average_stars AS user_average_stars,
  -- weather
  wp.precipitation,
  wp.precipitation_normal,
  wt.min AS temp_min,
  wt.max AS temp_max,
  wt.normal_min AS temp_normal_min,
  wt.normal_max AS temp_normal_max
FROM dwh.dim_yelp_business yb
JOIN dwh.dim_yelp_review yr ON yr.business_id = yb.business_id
JOIN dwh.dim_yelp_user yu ON yu.user_id = yr.user_id
JOIN dwh.dim_weather_temperature wt ON wt.date = yr.date::DATE
JOIN dwh.dim_weather_precipitation wp ON wp.date = yr.date::DATE
;
