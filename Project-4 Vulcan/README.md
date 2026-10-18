# VULCAN: Garage Operations Analysis

An end-to-end analysis of a synthetic Indian garage/dealership dataset (customers, vehicles, service records and complaints, with a mix of EV and ICE vehicles).

**Pipeline:** raw CSVs → cleaning in Python (pandas) → PostgreSQL database → SQL analysis → Power BI dashboard.

| Stage | Tool | What was done |
|---|---|---|
| Clean | Python (pandas) | Fixed duplicates, inconsistent categories, placeholder values and missing data in 4 raw tables |
| Store | PostgreSQL | Loaded the cleaned tables into a database called `VULCAN` |
| Analyse | SQL | Answered 8 business questions using joins, CTEs, aggregates and date functions |
| Visualise | Power BI | Built a 2-page dashboard connected live to the PostgreSQL database |

---

## Repository contents

| File | Description |
|---|---|
| `1. clean_data.ipynb` | Data cleaning of the four raw tables |
| `2. sql_analysis.ipynb` | Loads the cleaned data into PostgreSQL and answers 8 questions with SQL, with a written finding for each |
| `3. queries.sql` | All SQL queries in one file |
| `VULCAN_Dashboard.pbix` | Power BI dashboard |
| `customers_clean.csv`, `vehicles_clean.csv`, `service_clean.csv`, `complaints_clean.csv` | Cleaned tables |
| `customers.csv`, `vehicles.csv`, `service_records.csv`, `complaints.csv` | Raw tables |
| `DATASET.md` | Description of the raw dataset |

---

## Dataset

Four related tables of simulated garage data (India-context cities, ₹ costs, EV and ICE vehicles):

| Table | Raw rows | Clean rows | Description |
|---|---|---|---|
| `customers` | 415 | 400 | Customer details and city |
| `vehicles` | 550 | 550 | Vehicles owned by customers (make, model, fuel type, odometer) |
| `service_records` | 2,210 | 2,200 | Service jobs with type, technician, cost and days taken |
| `complaints` | 350 | 350 | Complaints with category, status and resolution days |

Relationships: `customers` → `vehicles` → `service_records` and `vehicles` → `complaints` (one-to-many).

---

## 1. Data cleaning (Python)

Each column was inspected, the problem was investigated, a decision was made, and the result was verified before moving on.

**What was fixed**

- **Duplicate customers:** merged 15 customers who had registered twice (`C90xx` IDs) into their original IDs, and updated the vehicles that pointed to them.
- **Duplicate service records:** removed 10 exact duplicate rows.
- **Fuel type:** standardised 15 spellings (`ev`, `Electric`, `Battery Electric`, `Gasoline`, `HEV` and so on) into 4 values (EV, Petrol, Diesel, Hybrid) in a new `fuel_type` column, and checked it against make and model (for example, every EV model is `EV`).
- **Complaint status:** standardised the casing to 4 values (Open, Resolved, Escalated, Closed).
- **Placeholder values:** treated the `-999` odometer values (4) and the `-1` costs (6) as missing instead of real numbers.
- **Phone numbers:** read as text, so that leading zeros are kept. (An earlier version lost them by reading the column as numbers. This was caught with a length check and fixed.)
- **Data types:** converted all date columns to proper dates and cleaned name casing and spacing.
- **Foreign keys:** confirmed that every `vehicle_id` and `customer_id` matches a row in its parent table.

**What was deliberately left as missing**

Values that could not be estimated without guessing were not filled: 26 emails, 16 odometer readings, 40 service dates, 6 costs and 63 resolution days. Missing complaint categories became `Uncategorized`, and missing technicians became `Unassigned`.

---

## 2. SQL analysis (PostgreSQL)

The cleaned tables are loaded into a PostgreSQL database (`VULCAN`) with `pandas` and `SQLAlchemy`, and queried with `pd.read_sql`. SQL used: `JOIN` and `LEFT JOIN` across up to 3 tables, `GROUP BY`, `FILTER`, CTEs, subqueries and date functions.

| # | Question |
|---|---|
| 1 | Which service types bring the most revenue? |
| 2 | How does monthly revenue change over time? |
| 3 | What is the average service cost for each fuel type? |
| 4 | Who are the top 10 customers by spend? |
| 5 | What share of customers came back for more than one service? |
| 6 | Which complaint categories are the most common, and what share is still unresolved? |
| 7 | Which vehicle makes get the most complaints per vehicle? |
| 8 | What is the average resolution time per complaint category? |

---

## 3. Power BI dashboard

The dashboard connects to the PostgreSQL database and covers all 8 questions on two pages. A city slicer filters every visual.

**Page 1: Business Performance**

- Cards: Total Revenue, Total Jobs, Avg Cost per Job
- Monthly revenue (line chart)
- Revenue by service type (bar chart)
- Average cost per job by fuel type (column chart)

**Page 2: Customers and Complaints**

- Cards: Total Complaints, Unresolved Complaints, Unresolved %, Repeat Customer %, Avg Resolution Days
- Top 10 customers by spend
- Complaints by category, unresolved vs resolved (stacked bar)
- Complaints per vehicle by make

<!-- Add screenshots to a `screenshots` folder, then these will display: -->
![Business Performance](screenshots/business_performance.png)
![Customers and Complaints](screenshots/customers_complaints.png)

---

## Key findings

- **Revenue comes from expensive jobs, not frequent ones.** Insurance Claim and Motor Repair bring in about 49% of the revenue from only 15% of the jobs. Software Update is the most frequent job but earns under 2% of the revenue.
- **EVs cost about 11% more per job** (₹6,333 against about ₹5,720 for Petrol, Diesel and Hybrid), and make up 35% of the jobs and 37% of the revenue. This does not account for the type of service.
- **Monthly revenue has no clear trend.** It moves between about ₹2.9 lakh and ₹6.8 lakh in the full months.
- **The business does not depend on a few customers.** The top 10 customers bring in about 11% of the revenue.
- **Customers come back.** 94.2% of the 292 customers who have used the garage had more than one service. However, 108 of the 400 registered customers have never had a service.
- **About half of the complaints are unresolved.** 179 of 350 (51.1%) are Open or Escalated.
- **Complaints per vehicle vary by make.** Ola Electric has the most (0.81) and Honda the fewest (0.34).
- **Technical complaints take longest to resolve.** Software Glitch averages 7.2 days, against 3.6 days for Noise/Vibration. The overall average is 5.3 days.

---

## Limitations

- The dataset is synthetic, so the findings describe this dataset and not a real garage.
- `resolution_days` does not match `status` (Open and Escalated complaints have values, and some Resolved and Closed complaints have none). Resolution time is therefore calculated only from Resolved and Closed complaints that have a value (142 complaints).
- 297 service records are dated before the purchase date of their vehicle. This was not corrected, because it is not clear which date is wrong, so vehicle age was not used in any analysis.
- The repeat-customer rate counts service records, not separate visits, so it is likely higher than the true return rate.
- Some groups are small (for example, 8 to 19 complaints per category in the resolution-time analysis), so close values should not be ranked with confidence.

---

## How to run

1. Install PostgreSQL and create an empty database called `VULCAN`.
2. Install the Python packages: `pip install pandas numpy sqlalchemy psycopg2-binary`
3. Run `1. clean_data.ipynb` to produce the cleaned CSV files.
4. Run `2. sql_analysis.ipynb`. It asks for your PostgreSQL password when it runs, so the password is never saved in the notebook.
5. Open `VULCAN_Dashboard.pbix` in Power BI Desktop. If it cannot connect, go to **Home → Transform data → Data source settings**, and point it to your own PostgreSQL server (`localhost`, database `VULCAN`).