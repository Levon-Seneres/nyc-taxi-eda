-- DATA CLEANING SCRIPT (CREATES trips_clean TABLE FROM trips_raw)

DROP TABLE IF EXISTS trips_clean;

CREATE TABLE trips_clean AS
SELECT
    -- ─
    "VendorID",
    "tpep_pickup_datetime",
    "tpep_dropoff_datetime",
    "passenger_count",
    "trip_distance",
    "RatecodeID",
    "store_and_fwd_flag",
    "PULocationID",
    "DOLocationID",
    "payment_type",
    "fare_amount",
    "extra",
    "mta_tax",
    "tip_amount",
    "tolls_amount",
    "improvement_surcharge",
    "total_amount",
    "congestion_surcharge",
    "Airport_fee",

    -- TIME FEATURES
    EXTRACT(HOUR  FROM "tpep_pickup_datetime")::SMALLINT        AS pickup_hour,
    EXTRACT(DOW   FROM "tpep_pickup_datetime")::SMALLINT        AS day_of_week,
    EXTRACT(MONTH FROM "tpep_pickup_datetime")::SMALLINT        AS pickup_month,
    DATE("tpep_pickup_datetime")                                AS pickup_date,

    -- TRIP DURATION
    ROUND(
        (EXTRACT(EPOCH FROM ("tpep_dropoff_datetime" - "tpep_pickup_datetime")) / 60.0)::NUMERIC
    , 2)                                                        AS trip_duration_min,

    -- AVG SPEED
    CASE
        WHEN EXTRACT(EPOCH FROM ("tpep_dropoff_datetime" - "tpep_pickup_datetime")) > 0
        THEN ROUND(
            ("trip_distance" /
            (EXTRACT(EPOCH FROM ("tpep_dropoff_datetime" - "tpep_pickup_datetime")) / 3600.0))::NUMERIC
        , 2)
        ELSE NULL
    END                                                         AS avg_speed_mph,

    -- FLAGGING SUSPICIOUS ROWS
    CASE
        WHEN "passenger_count" IS NULL OR "passenger_count" = 0 THEN 'null_or_zero_passengers'
        WHEN "trip_distance" > 200                              THEN 'extreme_distance'
        WHEN "fare_amount"   > 500                              THEN 'extreme_fare'
        WHEN EXTRACT(EPOCH FROM ("tpep_dropoff_datetime" - "tpep_pickup_datetime")) / 60.0 > 300
                                                                THEN 'extreme_duration'
        WHEN "tip_amount" < 0                                   THEN 'negative_tip'
        ELSE NULL
    END                 

FROM trips_raw

WHERE
    "tpep_pickup_datetime"  >= '2024-01-01'
    AND "tpep_pickup_datetime"  <  '2025-01-01'
    AND "tpep_dropoff_datetime" >= '2024-01-01'
    AND "tpep_dropoff_datetime" <  '2025-01-01'
    AND "tpep_dropoff_datetime" >  "tpep_pickup_datetime"
    AND "trip_distance" > 0
    AND "fare_amount"   > 0
    AND "total_amount"  > 0
    AND EXTRACT(EPOCH FROM ("tpep_dropoff_datetime" - "tpep_pickup_datetime")) >= 60
    AND EXTRACT(EPOCH FROM ("tpep_dropoff_datetime" - "tpep_pickup_datetime")) <= 21600
;