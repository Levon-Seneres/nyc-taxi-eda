-- ANALYSIS SQL SCRIPT 
--(contains business insight queries for NYC Yellow Taxi 2024, the source table is trips_with_zones table)

-- Hourly demand (when are the taxis busiest?)
CREATE TABLE IF NOT EXISTS agg_hourly_demand AS
SELECT
    pickup_hour,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("trip_distance")::NUMERIC, 2)    AS avg_distance_mi,
    ROUND(AVG(trip_duration_min)::NUMERIC, 2)  AS avg_duration_min,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("total_amount")::NUMERIC, 2)     AS avg_total
FROM trips_with_zones
WHERE suspicious_flag IS NULL
GROUP BY pickup_hour
ORDER BY pickup_hour;

-- Demand by day, weekday vs weekend
CREATE TABLE IF NOT EXISTS agg_dow_demand AS
SELECT
    day_of_week,
    CASE day_of_week
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END                                        AS day_name,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("total_amount")::NUMERIC, 2)     AS avg_total,
    ROUND(AVG("tip_amount")::NUMERIC, 2)       AS avg_tip
FROM trips_with_zones
WHERE suspicious_flag IS NULL
GROUP BY day_of_week
ORDER BY day_of_week;

-- Monthly demand and seasonal trends
CREATE TABLE IF NOT EXISTS agg_monthly_demand AS
SELECT
    pickup_month,
    TO_CHAR(DATE_TRUNC('month', "tpep_pickup_datetime"), 'Month') AS month_name,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("total_amount")::NUMERIC, 2)     AS avg_total,
    ROUND(AVG("tip_amount")::NUMERIC, 2)       AS avg_tip,
    ROUND(SUM("total_amount")::NUMERIC, 2)     AS total_revenue
FROM trips_with_zones
WHERE suspicious_flag IS NULL
GROUP BY pickup_month, DATE_TRUNC('month', "tpep_pickup_datetime")
ORDER BY pickup_month;

-- Hour by day heatmap
CREATE TABLE IF NOT EXISTS agg_hour_dow_heatmap AS
SELECT
    pickup_hour,
    day_of_week,
    CASE day_of_week
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END                                        AS day_name,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare
FROM trips_with_zones
WHERE suspicious_flag IS NULL
GROUP BY pickup_hour, day_of_week
ORDER BY day_of_week, pickup_hour;




-- 2A. Pickup borough demand
CREATE TABLE IF NOT EXISTS agg_pu_borough_demand AS
SELECT
    pu_borough,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("total_amount")::NUMERIC, 2)     AS avg_total,
    ROUND(AVG("trip_distance")::NUMERIC, 2)    AS avg_distance_mi,
    ROUND(AVG(trip_duration_min)::NUMERIC, 2)  AS avg_duration_min,
    ROUND(SUM("total_amount")::NUMERIC, 2)     AS total_revenue
FROM trips_with_zones
WHERE suspicious_flag IS NULL
  AND pu_borough IS NOT NULL
GROUP BY pu_borough
ORDER BY total_trips DESC;

-- 2B. Dropoff borough demand
CREATE TABLE IF NOT EXISTS agg_do_borough_demand AS
SELECT
    do_borough,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("total_amount")::NUMERIC, 2)     AS avg_total,
    ROUND(SUM("total_amount")::NUMERIC, 2)     AS total_revenue
FROM trips_with_zones
WHERE suspicious_flag IS NULL
  AND do_borough IS NOT NULL
GROUP BY do_borough
ORDER BY total_trips DESC;

-- Top 20 pickup zones, most active zones
CREATE TABLE IF NOT EXISTS agg_top_pu_zones AS
SELECT
    pu_borough,
    pu_zone,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("total_amount")::NUMERIC, 2)     AS avg_total,
    ROUND(AVG("tip_amount")::NUMERIC, 2)       AS avg_tip,
    ROUND(SUM("total_amount")::NUMERIC, 2)     AS total_revenue
FROM trips_with_zones
WHERE suspicious_flag IS NULL
  AND pu_zone IS NOT NULL
GROUP BY pu_borough, pu_zone
ORDER BY total_trips DESC
LIMIT 20;