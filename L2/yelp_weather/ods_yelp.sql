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
    PARSE_JSON(SRC):business_id,
    PARSE_JSON(SRC):name,
    PARSE_JSON(SRC):address,
    PARSE_JSON(SRC):city,
    PARSE_JSON(SRC):state,
    PARSE_JSON(SRC):postal_code,
    PARSE_JSON(SRC):latitude,
    PARSE_JSON(SRC):longitude,
    PARSE_JSON(SRC):stars,
    PARSE_JSON(SRC):review_count,
    PARSE_JSON(SRC):is_open,
    PARSE_JSON(SRC):attributes:BusinessAcceptsCreditCards,
    PARSE_JSON(SRC):attributes:BikeParking,
    PARSE_JSON(SRC):attributes:GoodForKids,
    PARSE_JSON(SRC):attributes:BusinessParking,
    PARSE_JSON(SRC):attributes:ByAppointmentOnly,
    PARSE_JSON(SRC):attributes:RestaurantsPriceRange2,
    PARSE_JSON(SRC):categories,
    PARSE_JSON(SRC):hours
FROM staging.yelp_business_raw;

--  Yelp Reviews
create or replace table yelp_review (
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

INSERT INTO yelp_review
SELECT
    PARSE_JSON(SRC):review_id,
    PARSE_JSON(SRC):user_id,
    PARSE_JSON(SRC):business_id,
    PARSE_JSON(SRC):stars,
    PARSE_JSON(SRC):useful,
    PARSE_JSON(SRC):funny,
    PARSE_JSON(SRC):cool,
    PARSE_JSON(SRC):text,
    PARSE_JSON(SRC):date
FROM staging.yelp_review_raw;

--  Yelp Checkin
create or replace table yelp_checkin (
  business_id string not null unique,
  date string,
  constraint pk_business_id primary key (business_id),
  constraint fk_business_id foreign key (business_id) references yelp_business(business_id)
);

INSERT INTO yelp_checkin
SELECT
    PARSE_JSON(SRC):business_id,
    PARSE_JSON(SRC):date
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
  PARSE_JSON(SRC):user_id,
  PARSE_JSON(SRC):name,
  PARSE_JSON(SRC):review_count,
  PARSE_JSON(SRC):yelping_since,
  PARSE_JSON(SRC):useful,
  PARSE_JSON(SRC):funny,
  PARSE_JSON(SRC):cool,
  PARSE_JSON(SRC):elite,
  PARSE_JSON(SRC):friends,
  PARSE_JSON(SRC):fans,
  PARSE_JSON(SRC):average_stars,
  PARSE_JSON(SRC):compliment_hot,
  PARSE_JSON(SRC):compliment_more,
  PARSE_JSON(SRC):compliment_profile,
  PARSE_JSON(SRC):compliment_cute,
  PARSE_JSON(SRC):compliment_list,
  PARSE_JSON(SRC):compliment_note,
  PARSE_JSON(SRC):compliment_plain,
  PARSE_JSON(SRC):compliment_cool,
  PARSE_JSON(SRC):compliment_funny,
  PARSE_JSON(SRC):compliment_writer,
  PARSE_JSON(SRC):compliment_photos
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
  PARSE_JSON(SRC):user_id,
  PARSE_JSON(SRC):business_id,
  PARSE_JSON(SRC):text,
  PARSE_JSON(SRC):date,
  PARSE_JSON(SRC):compliment_count
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
    PARSE_JSON(SRC):business_id,
    PARSE_JSON(SRC):highlights,
    PARSE_JSON(SRC):delivery_or_takeout,
    PARSE_JSON(SRC):grubhub_enabled,
    PARSE_JSON(SRC):call_to_action_enabled,
    PARSE_JSON(SRC):request_quote_enabled,
    PARSE_JSON(SRC):covid_banner,
    PARSE_JSON(SRC):temporary_closed_until,
    PARSE_JSON(SRC):virtual_services
FROM staging.yelp_covid_features_raw;
