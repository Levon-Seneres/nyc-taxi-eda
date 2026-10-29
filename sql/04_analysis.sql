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

-- Top 20 dropoff zones, most active destination zones
CREATE TABLE IF NOT EXISTS agg_top_do_zones AS
SELECT
    do_borough,
    do_zone,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("total_amount")::NUMERIC, 2)     AS avg_total,
    ROUND(SUM("total_amount")::NUMERIC, 2)     AS total_revenue
FROM trips_with_zones
WHERE suspicious_flag IS NULL
  AND do_zone IS NOT NULL
GROUP BY do_borough, do_zone
ORDER BY total_trips DESC
LIMIT 20;

-- Borough to borough
CREATE TABLE IF NOT EXISTS agg_borough_flow AS
SELECT
    pu_borough,
    do_borough,
    COUNT(*)                                   AS total_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("trip_distance")::NUMERIC, 2)    AS avg_distance_mi
FROM trips_with_zones
WHERE suspicious_flag IS NULL
  AND pu_borough IS NOT NULL
  AND do_borough IS NOT NULL
GROUP BY pu_borough, do_borough
ORDER BY total_trips DESC;


-- Payment type
-- 1=Credit card, 2=Cash, 3=No charge, 4=Dispute, 5=Unknown, 6=Voided
CREATE TABLE IF NOT EXISTS agg_payment_type AS
SELECT
    "payment_type",
    CASE "payment_type"
        WHEN 1 THEN 'Credit Card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No Charge'
        WHEN 4 THEN 'Dispute'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Voided Trip'
    END                                        AS payment_label,
    COUNT(*)                                   AS total_trips,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_trips,
    ROUND(AVG("fare_amount")::NUMERIC, 2)      AS avg_fare,
    ROUND(AVG("tip_amount")::NUMERIC, 2)       AS avg_tip,
    ROUND(AVG("total_amount")::NUMERIC, 2)     AS avg_total,
    ROUND(SUM("total_amount")::NUMERIC, 2)     AS total_revenue
FROM trips_with_zones
WHERE suspicious_flag IS NULL
GROUP BY "payment_type"
ORDER BY total_trips DESC;

-- Tip analysis (only credit card trips)
CREATE TABLE IF NOT EXISTS agg_tip_analysis AS
SELECT
    pu_borough,
    COUNT(*)                                              AS total_cc_trips,
    ROUND(AVG("tip_amount")::NUMERIC, 2)                 AS avg_tip,
    ROUND(AVG("tip_amount" / NULLIF("fare_amount", 0) * 100)::NUMERIC, 2) AS avg_tip_pct,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "tip_amount")::NUMERIC, 2) AS median_tip,
    COUNT(*) FILTER (WHERE "tip_amount" = 0)             AS zero_tip_trips,
    ROUND(COUNT(*) FILTER (WHERE "tip_amount" = 0) * 100.0 / COUNT(*), 2) AS pct_zero_tip
FROM trips_with_zones
WHERE suspicious_flag IS NULL
  AND "payment_type" = 1
  AND pu_borough IS NOT NULL
GROUP BY pu_borough
ORDER BY avg_tip_pct DESC;

-- Fare component sources
CREATE TABLE IF NOT EXISTS agg_fare_components AS
SELECT
    ROUND(AVG("fare_amount")::NUMERIC, 2)            AS avg_base_fare,
    ROUND(AVG("extra")::NUMERIC, 2)                  AS avg_extra,
    ROUND(AVG("mta_tax")::NUMERIC, 2)                AS avg_mta_tax,
    ROUND(AVG("tip_amount")::NUMERIC, 2)             AS avg_tip,
    ROUND(AVG("tolls_amount")::NUMERIC, 2)           AS avg_tolls,
    ROUND(AVG("improvement_surcharge")::NUMERIC, 2)  AS avg_improvement_surcharge,
    ROUND(AVG("congestion_surcharge")::NUMERIC, 2)   AS avg_congestion_surcharge,
    ROUND(AVG("Airport_fee")::NUMERIC, 2)            AS avg_airport_fee,
    ROUND(AVG("total_amount")::NUMERIC, 2)           AS avg_total
FROM trips_with_zones
WHERE suspicious_flag IS NULL;