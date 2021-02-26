create database Yelp;
create schema ODS;
create or replace file format json_format
  type = json
;

-- Load data from staging to ODS

-- Yelp Business
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
FROM staging.yelp_business_raw;

--  Yelp Reviews
create or replace table yelp_reviews (
  review_id string not null unique,
  user_id string,
  business_id string,
  stars numeric,
  useful numeric,
  funny numeric,
  cool numeric,
  text string,
  date timestamp,
  constraint pk_review_id primary key (review_id),
  constraint fk_business_id foreign key (business_id) references yelp_business(business_id)
);

INSERT INTO yelp_reviews
SELECT
    SRC:review_id,
    SRC:user_id,
    SRC:business_id,
    SRC:stars,
    SRC:useful,
    SRC:funny,
    SRC:cool,
    SRC:text,
    SRC:date
FROM staging.yelp_reviews_raw;

--  Yelp Checkin
create or replace table yelp_checkin (
  business_id string not null unique,
  date string,
  constraint pk_business_id primary key (business_id),
  constraint fk_business_id foreign key (business_id) references yelp_business(business_id)
);

INSERT INTO yelp_checkin
SELECT
    SRC:business_id,
    SRC:date
FROM staging.yelp_checkin_raw;

--  Yelp User
create or replace table yelp_user (
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
  compliment_photos numeric,
  constraint pk_user_id primary key (user_id)
);

INSERT INTO yelp_user
SELECT
  SRC:user_id,
  SRC:name,
  SRC:review_count,
  SRC:yelping_since,
  SRC:useful,
  SRC:funny,
  SRC:cool,
  SRC:elite,
  SRC:friends,
  SRC:fans,
  SRC:average_stars,
  SRC:compliment_hot,
  SRC:compliment_more,
  SRC:compliment_profile,
  SRC:compliment_cute,
  SRC:compliment_list,
  SRC:compliment_note,
  SRC:compliment_plain,
  SRC:compliment_cool,
  SRC:compliment_funny,
  SRC:compliment_writer,
  SRC:compliment_photos
FROM staging.yelp_user_raw;

-- Yelp Tip
create or replace table yelp_tip (
  user_id string not null unique,
  business_id string,
  text string,
  date timestamp,
  compliment_count numeric,
  constraint pk_user_id primary key (user_id),
  constraint fk_user_id foreign key (user_id) references yelp_user(user_id),
  constraint fk_business_id foreign key (business_id) references yelp_business(business_id)
);

INSERT INTO yelp_tip
SELECT
  SRC:user_id,
  SRC:business_id,
  SRC:text,
  SRC:date,
  SRC:compliment_count
FROM staging.yelp_tip_raw;

-- Yelp Covid Features
create or replace table yelp_covid_features (
  business_id string not null unique,
  highlights string,
  delivery_or_takeout string,
  grubhub_enabled string,
  call_to_action_enabled string,
  request_quote_enabled string,
  covid_banner string,
  temporary_closed_until string,
  virtual_services string,
  constraint pk_business_id primary key (business_id),
  constraint fk_business_id foreign key (business_id) references yelp_business(business_id)
);

INSERT INTO yelp_covid_features
SELECT
    SRC:business_id,
    SRC:highlights,
    SRC:delivery_or_takeout,
    SRC:grubhub_enabled,
    SRC:call_to_action_enabled,
    SRC:request_quote_enabled,
    SRC:covid_banner,
    SRC:temporary_closed_until,
    SRC:virtual_services
FROM staging.yelp_covid_features_raw;
