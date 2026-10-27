-- MAIN TRIPS TABLE

DROP TABLE IF EXISTS trips_raw;

CREATE TABLE trips_raw (
    VendorID              SMALLINT,
    tpep_pickup_datetime  TIMESTAMP,
    tpep_dropoff_datetime TIMESTAMP,
    passenger_count       FLOAT,
    trip_distance         FLOAT,
    RatecodeID            FLOAT,
    store_and_fwd_flag    TEXT,
    PULocationID          INTEGER,
    DOLocationID          INTEGER,
    payment_type          BIGINT,
    fare_amount           FLOAT,
    extra                 FLOAT,
    mta_tax               FLOAT,
    tip_amount            FLOAT,
    tolls_amount          FLOAT,
    improvement_surcharge FLOAT,
    total_amount          FLOAT,
    congestion_surcharge  FLOAT,
    Airport_fee           FLOAT
);