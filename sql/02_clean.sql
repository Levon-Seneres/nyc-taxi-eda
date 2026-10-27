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

    -- FLAG SUSPICIOUS ROWS
    CASE
        WHEN passenger_count IS NULL OR passenger_count = 0   THEN 'null_or_zero_passengers'
        WHEN trip_distance   > 200                            THEN 'extreme_distance'
        WHEN fare_amount     > 500                            THEN 'extreme_fare'
        WHEN EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 60.0 > 300
                                                              THEN 'extreme_duration'
        WHEN tip_amount < 0                                   THEN 'negative_tip'
        ELSE NULL
    END                                                         AS suspicious_flag

FROM trips_raw

-- ── DROP DETERMINILISTICALLY WRONG ROWS
WHERE
    tpep_pickup_datetime  >= '2024-01-01'
    AND tpep_pickup_datetime  <  '2025-01-01'
    AND tpep_dropoff_datetime >= '2024-01-01'
    AND tpep_dropoff_datetime <  '2025-01-01'
    AND tpep_dropoff_datetime > tpep_pickup_datetime
    AND trip_distance > 0
    AND fare_amount   > 0
    AND total_amount  > 0
    AND EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) >= 60
    AND EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) <= 21600
;

-- INDEXES
CREATE INDEX idx_clean_pickup    ON trips_clean (tpep_pickup_datetime);
CREATE INDEX idx_clean_dropoff   ON trips_clean (tpep_dropoff_datetime);
CREATE INDEX idx_clean_pu_loc    ON trips_clean (PULocationID);
CREATE INDEX idx_clean_do_loc    ON trips_clean (DOLocationID);
CREATE INDEX idx_clean_date      ON trips_clean (pickup_date);
CREATE INDEX idx_clean_hour      ON trips_clean (pickup_hour);
CREATE INDEX idx_clean_flag      ON trips_clean (suspicious_flag);
CREATE INDEX idx_clean_payment   ON trips_clean (payment_type);

-- VERIFICATION
SELECT
    COUNT(*)                                                     AS total_rows,
    COUNT(*) FILTER (WHERE suspicious_flag IS NOT NULL)          AS flagged_rows,
    COUNT(*) FILTER (WHERE suspicious_flag IS     NULL)          AS clean_rows,
    ROUND(
        COUNT(*) FILTER (WHERE suspicious_flag IS NOT NULL) * 100.0 / COUNT(*)
    , 2)                                                         AS pct_flagged,
    MIN(tpep_pickup_datetime)                                    AS earliest,
    MAX(tpep_pickup_datetime)                                    AS latest
FROM trips_clean;