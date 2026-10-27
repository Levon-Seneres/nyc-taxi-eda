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

-- TAXI ZONES LOOKUP TABLE

DROP TABLE IF EXISTS taxi_zones;

CREATE TABLE taxi_zones (
    LocationID    INTEGER PRIMARY KEY,
    Borough       TEXT,
    Zone          TEXT,
    service_zone  TEXT
);

-- Indexes on trips_raw for faster ingestion verification
CREATE INDEX idx_raw_pickup  ON trips_raw (tpep_pickup_datetime);
CREATE INDEX idx_raw_pu_loc  ON trips_raw (PULocationID);
CREATE INDEX idx_raw_do_loc  ON trips_raw (DOLocationID);