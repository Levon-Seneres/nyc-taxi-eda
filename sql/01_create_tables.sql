-- MAIN TRIPS CREATION SQL SCRIPT
-- Creates trips_raw

DROP TABLE IF EXISTS trips_raw;
CREATE TABLE trips_raw (
    id                    BIGSERIAL PRIMARY KEY,
    VendorID              SMALLINT,
    tpep_pickup_datetime  TIMESTAMP,
    tpep_dropoff_datetime TIMESTAMP,
    passenger_count       SMALLINT,
    trip_distance         NUMERIC(8,2),
    RatecodeID            SMALLINT,
    store_and_fwd_flag    CHAR(1),
    PULocationID          SMALLINT,
    DOLocationID          SMALLINT,
    payment_type          SMALLINT,
    fare_amount           NUMERIC(8,2),
    extra                 NUMERIC(8,2),
    mta_tax               NUMERIC(8,2),
    tip_amount            NUMERIC(8,2),
    tolls_amount          NUMERIC(8,2),
    improvement_surcharge NUMERIC(8,2),
    total_amount          NUMERIC(8,2),
    congestion_surcharge  NUMERIC(8,2),
    Airport_fee           NUMERIC(8,2)
);
CREATE INDEX idx_trips_raw_pickup  ON trips_raw (tpep_pickup_datetime);
CREATE INDEX idx_trips_raw_dropoff ON trips_raw (tpep_dropoff_datetime);
CREATE INDEX idx_trips_raw_pu_loc  ON trips_raw (PULocationID);
CREATE INDEX idx_trips_raw_do_loc  ON trips_raw (DOLocationID);

DROP TABLE IF EXISTS taxi_zones;
CREATE TABLE taxi_zones (
    LocationID   SMALLINT PRIMARY KEY,
    Borough      VARCHAR(50),
    Zone         VARCHAR(100),
    service_zone VARCHAR(50)
);