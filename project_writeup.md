# Project Writeup: NYC Yellow Taxi End-to-End Demand EDA 2024

---

## Project Goal

The goal of this project was to build a complete end-to-end data analysis portfolio piece using NYC yellow taxi trip data for 2024. The project needed to demonstrate the full analyst workflow: ingesting raw data, cleaning it, running SQL aggregations, exporting results, and visualising findings in Tableau dashboards.

The target audience is hiring managers reviewing a data analyst portfolio on GitHub.

---

## Data Source

**NYC Taxi and Limousine Commission (TLC) Trip Record Data**
https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

The raw data is published monthly as Parquet files. The 2024 dataset covers January through December and contains over 35 million individual trip records. Each row represents one trip and includes fields such as pickup and dropoff timestamps, locations, passenger count, fare amount, tip amount, payment type, and trip distance.

The raw files are several gigabytes and are not included in this repository. Only the aggregated output tables are stored in `tableau_data/`.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| PostgreSQL 18 | Database to store and query the raw trip data |
| Python (pandas, sqlalchemy) | Load Parquet files into PostgreSQL, run data profiling |
| Jupyter Notebooks | Document each stage of the pipeline |
| SQL | Clean the data and build aggregation tables |
| Tableau Public Desktop | Build and publish the dashboards |
| GitHub | Version control and portfolio hosting |

---

## Stage 1: Data Ingestion

**Notebook:** `01_ingestion.ipynb`

The raw TLC Parquet files were loaded into a local PostgreSQL database using Python and SQLAlchemy. Each monthly file was read with pandas and inserted into a staging table called `trips_raw`.

**Key decisions:**

- Parquet was chosen over CSV because the TLC provides Parquet files and they load faster with pandas.
- All 12 monthly files were loaded into one table rather than 12 separate tables. This made downstream SQL queries simpler.
- Column names were kept as the original TLC names (e.g. `VendorID`, `PULocationID`) with quoted identifiers in PostgreSQL to preserve capitalisation.

**Result:** One staging table with approximately 35.5 million rows.

---

## Stage 2: Data Profiling

**Notebook:** `02_profiling.ipynb`

Before cleaning, the data was profiled to understand its shape, missing values, distributions, and outliers.

**What was checked:**

- Missing values per column
- Distribution of numeric fields (fare, distance, duration, passenger count)
- Outlier detection: extreme fares, extreme distances, extreme durations
- Suspicious flags: zero passengers, zero fare, negative values
- Correlation between numeric fields

**Key findings from profiling:**

- 4.07 million rows had null or zero passenger counts
- 473 rows had extreme durations (likely data errors)
- 351 rows had extreme fares
- 250 rows had extreme distances
- The fare and distance distributions were heavily right-skewed, meaning a small number of very long or expensive trips pulled the averages up

**Output:** A set of EDA charts saved to `reports/` including distributions, boxplots, correlation matrix, and flag comparisons.

---

## Stage 3: SQL Cleaning and Aggregation

**Scripts:** `sql/01_create_tables.sql` through `sql/04_analysis.sql`

After profiling, a cleaned table was created by filtering out rows that failed quality checks. The cleaning criteria were:

- Remove trips with zero or null passenger count
- Remove trips with fare amount below $2.50 (the TLC minimum)
- Remove trips with zero or negative distance
- Remove trips with duration under 1 minute or over 5 hours
- Remove rows with null pickup or dropoff location IDs

A taxi zone lookup table was joined to convert location IDs into human-readable zone and borough names.

**Aggregation tables:**

17 aggregation tables were created from the cleaned data, each answering a specific analytical question:

| Table | What it covers |
|---|---|
| agg_hourly_demand | Trip volume by hour of day |
| agg_dow_demand | Trip volume by day of week |
| agg_monthly_demand | Trip volume by month |
| agg_hour_dow_heatmap | Trip volume by hour and day combined |
| agg_pu_borough_demand | Pickup volume and fares by borough |
| agg_do_borough_demand | Dropoff volume by borough |
| agg_top_pu_zones | Top pickup zones by trip count |
| agg_top_do_zones | Top dropoff zones by trip count |
| agg_borough_flow | Pickup to dropoff borough matrix |
| agg_payment_type | Payment method breakdown |
| agg_tip_analysis | Tip rates by borough (card payments only) |
| agg_fare_components | Average breakdown of each fare component |
| agg_rate_code | Trip volume and fares by rate code |
| agg_speed_by_borough | Average speed and trip volume by borough |
| agg_passenger_dist | Passenger count distribution |
| agg_airport_trips | Fare and trip stats for airport routes |
| agg_suspicious_flags | Count of data quality issues |

Each table was exported as a CSV into `tableau_data/`.

---

## Stage 4: Tableau Dashboard Build

**File:** `docs/Taxi_tableau.twbx`

The 17 CSV files were connected to Tableau as data sources and converted to Hyper extracts so the workbook could be published to Tableau Public (which does not support live database connections).

A borough boundary GeoJSON file from NYC Open Data was added as a spatial data source to enable the filled map chart.

**Three dashboards were built:**

### Dashboard 1: Demand Patterns
Charts included: KPI tiles (total trips, avg distance, avg duration, avg fare), trips by hour of day bar chart, trips by hour and day of week heatmap, monthly trip volume line chart.

### Dashboard 2: Geographic Demand and Congestion
Charts included: filled borough map (coloured by trip volume), avg speed by borough line chart, total trips by borough bar chart, top 20 pickup zones bar chart, trips by pickup borough bar chart, pickup to dropoff borough flow matrix.

### Dashboard 3: Fares, Tips and Payment Behaviour
Charts included: payment method split pie chart, rate code breakdown treemap, airport fares bar chart, fare component breakdown bar chart, average tip percentage by borough bar chart.

**Design decisions:**

- Blue was used as the primary colour for trip volume charts across all dashboards. Green was used for fare and payment charts. Orange was used for speed and time-based charts. This keeps colour meaningful rather than decorative.
- Annotations were added to each chart to highlight the key insight on that chart, so the dashboard tells a story without the reader needing to interpret the numbers themselves.
- A summary text tile was added at the bottom of each dashboard with one to two sentences describing the overall finding from that dashboard.
- Chart types were varied on Dashboard 3 (pie chart, treemap, bar charts) to avoid the monotonous look of five identical horizontal bar charts.

**Technical issues encountered:**

The main challenge was the blend between the borough demand CSV extract and the GeoJSON boundary file for the map chart. Tableau's relationship editor only works with SQL connections, not file extracts. The blend had to be set up at the worksheet level using the Edit Blend Relationships dialog, linking the `Pu Borough` field to the `Boroname` field in the boundary file. After converting both sources to Hyper extracts, the blend link broke and had to be re-established on the worksheet.

---

## Stage 5: GitHub Publishing

The repo was structured as follows:

- `dashboards/` stores PNG screenshots and PDF exports of the three dashboards
- `data/` contains placeholder READMEs explaining where to download the raw data
- `docs/` stores the Tableau workbook
- `notebooks/` stores the three Jupyter notebooks
- `reports/` stores the EDA chart outputs
- `sql/` stores the four SQL scripts
- `tableau_data/` stores the 17 aggregated CSV files and the borough GeoJSON

The raw trip data files were not committed due to their size (several GB). A README in `data/raw/` explains how to download them from the TLC website.

---

## Limitations

- **Cash tips are not recorded.** The tip analysis only covers card payments. Actual tip rates in outer boroughs where cash is more common may be higher than the data shows.
- **Unknown and EWR locations.** Some trips have pickup locations recorded as Unknown or EWR (Newark Airport area). These were kept in the data but excluded from certain borough-level charts where they distort the analysis.
- **Data quality flags affect a small percentage of records.** Approximately 4 million rows had data quality issues and were excluded from the cleaned table. This is about 11% of the raw data.
- **The dataset only covers yellow taxis.** Green taxis, for-hire vehicles, and rideshare trips are not included. The findings describe yellow taxi behaviour specifically, not the broader NYC for-hire transport market.
