# Findings Report: NYC Yellow Taxi Demand Analysis 2024

---

## Overview

This report covers the findings from analysing 35.5 million NYC yellow taxi trips taken in 2024. The analysis looks at demand patterns, geographic distribution, fare structure, payment behaviour, and tip rates. Each finding is paired with what it means for taxi operators, drivers, and platform businesses.

**Data period:** January 2024 to December 2024
**Total trips analysed:** 35,481,182 (after data quality filtering)
**Source:** NYC Taxi and Limousine Commission Trip Record Data

---

## Finding 1: Yellow Taxis Are Effectively a Manhattan-Only Service

**The data:**
- Manhattan: 31,566,852 pickups (89% of all trips)
- Queens: 3,445,153 pickups (10%)
- Brooklyn: 296,386 pickups (0.8%)
- Bronx: 67,011 pickups (0.2%)
- Staten Island: 608 pickups (0.002%)

**What it shows:**

Yellow taxis operate almost entirely within Manhattan. Staten Island recorded only 608 pickups in an entire year, which is fewer than a single busy Manhattan zone records in a day. Brooklyn and the Bronx are similarly underserved.

This is not simply because fewer people live in outer boroughs. It reflects how yellow taxi licensing and driver behaviour has historically concentrated around Manhattan's dense commercial core. Rideshare services (Uber, Lyft) and green taxis exist specifically to serve the outer boroughs that yellow taxis do not reach.

**Business implication:**

For yellow taxi fleet operators, virtually all revenue comes from Manhattan. Operational decisions around driver placement, vehicle maintenance scheduling, and customer service investment should be built around Manhattan as the primary and near-exclusive market.

For the broader NYC transport market, the outer borough gap is a known and persistent problem. Any operator looking to grow yellow taxi usage outside Manhattan faces strong structural competition from rideshare apps that already have driver supply and customer habits in those areas.

---

## Finding 2: Demand Peaks at 6pm and Drops Sharply After 8pm on Weekdays

**The data:**
- Hour 18 (6pm) consistently records the highest trip volume across all weekdays
- Demand is lowest between 3am and 5am
- Weekend demand shifts later: Saturday and Sunday nights see elevated demand from 10pm to 2am compared to weekdays

**What it shows:**

The demand curve reflects commuter behaviour. Trips build from the morning commute (7am onwards), plateau through midday, then peak sharply at the end of the working day. The weekend late-night pattern reflects leisure and hospitality activity.

**Business implication:**

Driver scheduling should be optimised around the 4pm to 8pm window on weekdays. This is when the most trips are available and when having insufficient driver supply leads to lost revenue and poor passenger experience.

For weekend operations, driver shifts that extend past midnight on Friday and Saturday nights capture a distinct demand segment that weekday-focused scheduling misses.

Surge pricing or driver incentive bonuses during the 5pm to 7pm window on weekdays would help attract more supply at exactly the time it is most needed.

---

## Finding 3: Seasonal Demand Dips in Summer and Peaks in Autumn

**The data:**
- Lowest month: August at 2,592,374 trips
- Highest month: October at 3,289,685 trips
- January and February are also low (winter holiday recovery)
- May and June see a spring pickup before the summer dip

**What it shows:**

Demand follows a clear seasonal curve. Summer holidays reduce commuter traffic in August. October sees high demand as the city returns to full activity after summer. The pattern repeats consistently throughout the year.

**Business implication:**

Fleet maintenance, vehicle inspections, and driver onboarding should be concentrated in August when demand is lowest. Doing this work during peak months (October, May, June) means taking vehicles off the road when they would otherwise be earning.

Revenue forecasting and driver earnings expectations should factor in the seasonal swing. August drivers should expect lower earnings than October drivers even with the same hours worked.

---

## Finding 4: JFK Airport Is the Single Busiest Pickup Zone

**The data:**
- JFK Airport: 1,834,463 trips (rank 1 of all zones)
- Upper East Side South: 1,762,823 (rank 2)
- Midtown Center: 1,733,541 (rank 3)
- LaGuardia Airport: 1,240,759 (rank 8)
- Total airport trips (JFK + LaGuardia): over 3 million

**What it shows:**

JFK is not just a busy zone, it is the busiest zone in the entire dataset, beating every Manhattan neighbourhood. Combined with LaGuardia, airports account for roughly 8.7% of all trips despite being two specific locations.

**Business implication:**

Airport routes are a concentrated, high-volume, high-value segment. Operators that ensure reliable driver availability at JFK and LaGuardia during flight arrival peaks capture disproportionate revenue relative to coverage effort.

JFK already has a flat-rate fare structure ($65.21 average). LaGuardia does not, which creates fare unpredictability for passengers. Extending a flat-rate model to LaGuardia could increase passenger confidence and booking rates on that route.

---

## Finding 5: Airport Fares Are Significantly Higher Than Standard Trips

**The data:**
- Newark average fare: $94.65
- JFK average fare: $65.21
- LaGuardia average fare: $44.61
- Non-airport average fare: $15.11

**What it shows:**

Airport trips, particularly Newark, generate far more revenue per trip than standard city trips. A single Newark trip earns roughly the same as six standard trips. Even LaGuardia, the cheapest airport route, earns nearly three times a standard fare.

**Business implication:**

Drivers who position themselves for airport dispatch earn significantly more per trip. Platforms could use airport fare data to inform drivers of their expected earnings for airport vs city trips, helping drivers make better dispatch decisions.

During high-demand travel windows (Sunday evenings, Friday afternoons, holiday periods), incentive bonuses for airport dispatch would help ensure supply meets demand on the most valuable routes.

---

## Finding 6: Card Payments Dominate at 84%

**The data:**
- Credit card: 83.99% of trips
- Cash: 14.58%
- Dispute: 1.03%
- No charge: 0.39%

**What it shows:**

Cash is a small and declining minority of NYC taxi transactions. The overwhelming majority of passengers pay by card. This is a significant shift from even ten years ago when cash was common.

**Business implication:**

The cost and complexity of cash handling (driver cash management, end-of-shift reconciliation, theft risk, change management) is now serving only 14.6% of transactions. The return on investment for cash infrastructure is low.

Investment should go into card terminal reliability and speed. A slow or unreliable card terminal directly affects the majority of transactions. Contactless payment and in-app payment options are worth prioritising.

The 1.03% dispute rate and 0.39% no-charge rate together represent approximately 500,000 trips per year with payment issues. Reducing this through better terminal technology and clearer fare display has a measurable revenue impact at scale.

---

## Finding 7: Tip Rates Vary Sharply by Borough

**The data (card payments only):**
- Manhattan: 25.64% average tip
- Unknown: 24.39%
- Queens: 21.80%
- EWR: 20.78%
- Staten Island: 18.08%
- Brooklyn: 7.57%
- Bronx: 1.38%

**What it shows:**

Tip rates drop sharply outside the core Manhattan and Queens market. Brooklyn tips at less than a third of the Manhattan rate. The Bronx tips at less than 1/18th of the Manhattan rate.

Two factors likely explain this. First, outer borough riders tend to have lower average incomes and tip less across service industries generally. Second, cash is more commonly used in outer boroughs, and cash tips are not captured in this dataset. The true tip rate in Brooklyn and the Bronx may be higher than the card data shows.

**Business implication:**

Drivers optimising for total earnings should factor tip rates into their borough preference, not just fare amounts. A Queens trip may pay a lower fare than a Manhattan trip but still generate a decent tip. A Bronx trip may pay a reasonable fare but generate almost no measurable card tip.

Platforms that use tip rate data in driver dispatch algorithms risk creating a feedback loop where drivers avoid outer boroughs, reducing supply, worsening service, and further reducing demand. Compensation structures should account for borough tip disparities to ensure fair driver earnings across the city.

---

## Finding 8: Manhattan Is the Slowest Borough

**The data:**
- Manhattan average speed: approximately 10 mph
- Brooklyn: approximately 15 mph
- Queens: approximately 18 mph
- Bronx: approximately 22 mph
- Staten Island: approximately 32 mph

**What it shows:**

Speed and trip volume are inversely related. The more trips a borough generates, the slower the average speed. This directly reflects road congestion. Manhattan's street grid handles over 31 million taxi trips per year and averages walking pace in a car during peak hours.

**Business implication:**

Revenue per trip and revenue per hour are very different metrics in Manhattan. A driver completing 3 trips per hour at $20 each earns $60/hour. The same driver in Manhattan may complete only 2 trips per hour at $22 each due to congestion, earning $44/hour despite higher individual fares.

Fleet operators and drivers should track revenue per hour rather than revenue per trip to understand true profitability across boroughs. This is particularly relevant as NYC's congestion pricing zone charges additional fees for trips entering central Manhattan, adding cost pressure to already slow and congested routes.

---

## Summary

NYC yellow taxi data for 2024 tells a clear story. The service is concentrated in Manhattan, driven by the evening commute, anchored by airport routes, and paid almost entirely by card. Outer boroughs are underserved not by accident but by the structural economics of where drivers choose to operate and where demand is concentrated.

The business opportunity areas are: evening peak driver supply in Manhattan, airport route coverage reliability, card terminal investment, driver compensation structures that account for borough tip disparities, and seasonal fleet planning aligned to the August dip and October peak.
