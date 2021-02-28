
-- Integrate climate and Yelp data sets by identifying a common data field
SELECT
  *
FROM ods.yelp_business business
JOIN ods.yelp_review review ON review.business_id = business.business_id
JOIN ods.weather_temperature temp ON temp.date::DATE = review.date::DATE
JOIN ods.weather_precipitation precip ON precip.date::DATE = review.date::DATE
LIMIT 1;

-- Write SQL queries to generate a correlation report between climate data and Yelp data
SELECT
  review_id,
  review_stars,
  review_date,
  precipitation,
  precipitation_normal
  temp_min,
  temp_max,
  temp_normal_min,
  temp_normal_max
FROM fct_yelp_review_weather
;

SELECT
  CORR(review_stars, precipitation) as corr
FROM (
  SELECT
    review_stars,
    precipitation
  FROM dwh.fct_yelp_review_weather
  LIMIT 5000
  ) p
;
