-- Creates trips_clean from trips_raw
-- Drops deterministically bad rows, derives useful columns,
-- flags suspicious rows for Python to decide on later.

DROP TABLE IF EXISTS trips_clean;

CREATE TABLE trips_clean AS
SELECT
    VendorID,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    RatecodeID,
    store_and_fwd_flag,
    PULocationID,
    DOLocationID,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    Airport_fee,

    EXTRACT(HOUR FROM tpep_pickup_datetime)::SMALLINT          AS pickup_hour,
    EXTRACT(DOW  FROM tpep_pickup_datetime)::SMALLINT          AS day_of_week,
    EXTRACT(MONTH FROM tpep_pickup_datetime)::SMALLINT         AS pickup_month,
    DATE(tpep_pickup_datetime)                                  AS pickup_date,

    ROUND(
        EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 60.0
    , 2)::NUMERIC(8,2)                                          AS trip_duration_min,

    CASE
        WHEN EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 3600.0 > 0
        THEN ROUND(
            trip_distance /
            (EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 3600.0)
        , 2)
        ELSE NULL
    END::NUMERIC(8,2)                                           AS avg_speed_mph,