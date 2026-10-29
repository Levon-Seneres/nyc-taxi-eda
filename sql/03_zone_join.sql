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

FROM trips_clean tc
LEFT JOIN taxi_zones pz ON tc."PULocationID" = pz."LocationID"
LEFT JOIN taxi_zones dz ON tc."DOLocationID" = dz."LocationID"
;

-- INDEXES
CREATE INDEX idx_zones_pickup_dt  ON trips_with_zones ("tpep_pickup_datetime");
CREATE INDEX idx_zones_pu_borough ON trips_with_zones (pu_borough);
CREATE INDEX idx_zones_do_borough ON trips_with_zones (do_borough);
CREATE INDEX idx_zones_pu_zone    ON trips_with_zones (pu_zone);
CREATE INDEX idx_zones_do_zone    ON trips_with_zones (do_zone);
CREATE INDEX idx_zones_payment    ON trips_with_zones ("payment_type");
CREATE INDEX idx_zones_flag       ON trips_with_zones (suspicious_flag);
CREATE INDEX idx_zones_pickup_hr  ON trips_with_zones (pickup_hour);
CREATE INDEX idx_zones_date       ON trips_with_zones (pickup_date);

-- VERIFICATION
SELECT
    COUNT(*)                                             AS total_rows,
    COUNT(*) FILTER (WHERE pu_borough IS NULL)           AS pu_unmatched,
    COUNT(*) FILTER (WHERE do_borough IS NULL)           AS do_unmatched,
    COUNT(DISTINCT pu_borough)                           AS unique_pu_boroughs,
    COUNT(DISTINCT do_borough)                           AS unique_do_boroughs,
    COUNT(DISTINCT pu_zone)                              AS unique_pu_zones,
    COUNT(DISTINCT do_zone)                              AS unique_do_zones
FROM trips_with_zones;