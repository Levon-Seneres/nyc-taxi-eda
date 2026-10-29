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
