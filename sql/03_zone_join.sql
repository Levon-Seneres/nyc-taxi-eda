-- ZONE JOINING SCRIPT 
--(Creates trips_with_zones from trips_clean + taxi_zones, making it human-readable with the borough/zone names for pickup & dropoff)

DROP TABLE IF EXISTS trips_with_zones;

CREATE TABLE trips_with_zones AS
SELECT
    -- trips_clean COLUMNS
    tc."VendorID",
    tc."tpep_pickup_datetime",
    tc."tpep_dropoff_datetime",
    tc."passenger_count",
    tc."trip_distance",
    tc."RatecodeID",
    tc."store_and_fwd_flag",
    tc."PULocationID",
    tc."DOLocationID",
    tc."payment_type",
    tc."fare_amount",
    tc."extra",
    tc."mta_tax",
    tc."tip_amount",
    tc."tolls_amount",
    tc."improvement_surcharge",
    tc."total_amount",
    tc."congestion_surcharge",
    tc."Airport_fee",
    tc.pickup_hour,
    tc.day_of_week,
    tc.pickup_month,
    tc.pickup_date,
    tc.trip_duration_min,
    tc.avg_speed_mph,
    tc.suspicious_flag,

    -- PICKUP ZONES
    pz."Borough"      AS pu_borough,
    pz."Zone"         AS pu_zone,
    pz."service_zone" AS pu_service_zone,

    -- DROPOFF ZONES
    dz."Borough"      AS do_borough,
    dz."Zone"         AS do_zone,
    dz."service_zone" AS do_service_zone