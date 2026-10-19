# VULCAN: Garage Operations Analysis

An end-to-end analysis of a synthetic Indian garage/dealership dataset (customers, vehicles, service records and complaints, with a mix of EV and ICE vehicles).

**Pipeline:** raw CSVs → cleaning in Python (pandas) → PostgreSQL database → SQL analysis → Power BI dashboard.

> The dataset is synthetic, so the findings describe this dataset and not a real garage. The point of the project is the process: cleaning decisions, SQL analysis, and honest handling of data problems.

| Stage | Tool | What was done |
|---|---|---|
| Clean | Python (pandas) | Fixed duplicates, inconsistent categories, placeholder values and missing data in 4 raw tables |
| Store | PostgreSQL | Loaded the cleaned tables into a database called `VULCAN` |
| Analyse | SQL | Answered 8 business questions using joins, CTEs, window functions, aggregates and date functions |
| Visualise | Power BI | Built a 2-page dashboard connected live to the PostgreSQL database |

---

## Repository contents

| File | Description |
|---|---|
| `1. clean_data.ipynb` | Data cleaning of the four raw tables |
| `2. sql_analysis.ipynb` | Loads the cleaned data into PostgreSQL and answers 8 questions with SQL, with a written finding for each |
| `3. queries.sql` | All SQL queries in one file |
| `VULCAN_Dashboard.pbix` | Power BI dashboard (needs a PostgreSQL connection, see "How to run") |
| `Dashboard Screenshots/` | Dashboard screenshots, so the dashboard can be viewed without Power BI |
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

The cleaned tables are loaded into a PostgreSQL database (`VULCAN`) with `pandas` and `SQLAlchemy`, and queried with `pd.read_sql`. SQL used: `JOIN` and `LEFT JOIN` across up to 3 tables, `GROUP BY`, `FILTER`, CTEs, window functions (`LAG`), subqueries and date functions.

| # | Question |
|---|---|
| 1 | Which service types bring the most revenue? |
| 2 | How does monthly revenue change over time, and what is the month-over-month change? (uses `LAG`) |
| 3 | What is the average service cost for each fuel type? |
| 4 | Who are the top 10 customers by spend? |
| 5 | What share of customers came back for more than one service? |
| 6 | Which complaint categories are the most common, and what share is still unresolved? |
| 7 | Which vehicle makes get the most complaints per vehicle? |
| 8 | What is the average resolution time per complaint category? |

---

## 3. Power BI dashboard

The dashboard connects to the PostgreSQL database and has two pages. A city slicer filters every visual. It covers Q1 to Q4, Q6 and Q7, plus the overall average resolution time from Q8 (the per-category breakdown is in the notebook).

Q5 (repeat-customer rate) is deliberately left off the dashboard. At 94.2% it cannot separate loyal customers from others (see Key findings). It is replaced by a more useful card: customers who have never had a service.

**Page 1: Business Performance**

- Cards: Avg Cost per Job, Total Jobs, Total Revenue
- Monthly revenue (line chart; the first and last months are left out because they are only partly covered by the data)
- Revenue by service type (bar chart)
- Average cost per job by fuel type (column chart, EV highlighted)

![Business Performance](Dashboard%20Screenshots/business_performance.png)

**Page 2: Customers and Complaints**

- Cards: Total Complaints, Unresolved Complaints, Unresolved %, Never Serviced Customers, Avg Resolution Days
- Top 10 customers by spend
- Complaints by category, unresolved vs resolved (stacked bar, sorted by unresolved count)
- Complaints per vehicle by make

![Customers and Complaints](Dashboard%20Screenshots/customers_complaints.png)

---

## Key findings

**Revenue and cost**

- **Revenue comes from expensive jobs, not frequent ones.** Insurance Claim and Motor Repair bring in about 49% of the revenue from only 15% of the jobs. Software Update is the most frequent job but earns under 2% of the revenue.
- **EVs cost about 11% more per job, but most of that gap comes from what they are serviced for.** The average is ₹6,333 for EVs against ₹5,724 for Petrol, Diesel and Hybrid combined. EVs make up 35% of the jobs and 37% of the revenue. EVs are serviced mostly for Software Update (25% of EV jobs), Motor Repair (14%) and Battery Check (14%), while ICE and Hybrid vehicles are serviced mostly for General Service (18%), Brake Repair (15%) and Oil Change (14%). When the ICE service mix is applied to EV prices, the gap shrinks to about 3% (₹5,892 against ₹5,711). Within a single service type, EVs cost slightly more in 8 of 11 types, usually by a few percent.
- **Monthly revenue has no clear trend.** It moves between about ₹2.9 lakh and ₹6.8 lakh in the full months. Month-over-month changes keep flipping sign, from -52% (April 2025) to +125% (May 2025), most of them between 10% and 30% either way.

**Customers**

- **The business does not depend on a few customers.** The top 10 customers bring in about 11% of the revenue.
- **108 of the 400 registered customers (27%) have never had a service.** This is the more useful customer finding, and it is shown on the dashboard.
- **Almost every customer who has used the garage has several services on record, so the repeat-customer rate is not informative here.** 94.2% of the 292 customers who have used the garage have more than one service record, and the figure is the same when counting distinct service dates. The 2,200 jobs are spread over only 292 customers (about 7.5 each), so nearly everyone counts as a repeat customer. A rate this high cannot separate loyal customers from others, and it is a property of the synthetic data more than of the business.

**Complaints**

- **About half of the complaints are unresolved.** 179 of 350 (51.1%) are Open (121) or Escalated (58).
- **Complaints per vehicle vary by make.** Ola Electric has the most (0.81) and Honda the fewest (0.34). With only 350 complaints spread over 10 makes, these differences are indicative and not conclusive.
- **Technical complaints appear to take longest to resolve.** Software Glitch averages 7.2 days, against 3.6 days for Noise/Vibration, with an overall average of 5.3 days. Each category has only 8 to 19 complaints with a usable value, so only the rough ordering (technical issues slower than comfort issues) should be trusted, not the exact ranks.

---

## Recommendations

These assume the numbers reflect a real garage, which they do not. They show how the findings would be turned into actions.

1. **Work down the unresolved complaints, starting with the 58 Escalated ones.** Half of all complaints are Open or Escalated. Set a target resolution time per category, and track the Open/Escalated share monthly.
2. **Fix how resolution is recorded.** `resolution_days` is filled for Open complaints and empty for some Resolved ones, so resolution time cannot be trusted. Make the days field required when a complaint is closed and blank otherwise.
3. **Contact the 108 customers who have never booked a service.** They are 27% of the customer base and the cheapest group to win back.
4. **Protect the high-value job types.** Insurance Claim and Motor Repair drive about half of the revenue. Software Update is frequent but earns little, so it is a candidate for bundling into other visits or for a fixed low price that does not use bay time.
5. **Do not price EV servicing from the headline average.** Most of the EV premium comes from the type of work. Compare prices within each service type.

---

## Limitations

- The dataset is synthetic, so the findings describe this dataset and not a real garage.
- `resolution_days` does not match `status` (Open and Escalated complaints have values, and some Resolved and Closed complaints have none). Resolution time is therefore calculated only from Resolved and Closed complaints that have a value (142 complaints).
- 297 service records are dated before the purchase date of their vehicle. This was not corrected, because it is not clear which date is wrong, so vehicle age was not used in any analysis.
- The repeat-customer rate is close to 100% because of how many jobs the dataset gives each customer, so it should not be used to judge loyalty. Counting distinct service dates gives the same result.
- The EV against ICE comparison groups Petrol, Diesel and Hybrid together, and the within-service-type differences are small, so they were not tested for statistical significance.
- Some groups are small (for example, 8 to 19 complaints per category in the resolution-time analysis), so close values should not be ranked with confidence.
- The dashboard's monthly revenue chart leaves out the first and last months, which are only partly covered by the data. The SQL results for Q2 and the headline totals still include all dated jobs, so the month-over-month change for the first and last months compares against a partial month and should be ignored.

---

## How to run

1. Install PostgreSQL and create an empty database called `VULCAN`.
2. Install the Python packages: `pip install pandas numpy sqlalchemy psycopg2-binary`
3. Run `1. clean_data.ipynb` to produce the cleaned CSV files.
4. Run `2. sql_analysis.ipynb`. It asks for your PostgreSQL password when it runs, so the password is never saved in the notebook.
5. Open `VULCAN_Dashboard.pbix` in Power BI Desktop. If it cannot connect, go to **Home → Transform data → Data source settings**, and point it to your own PostgreSQL server (`localhost`, database `VULCAN`).

No PostgreSQL or Power BI? The screenshots in `Dashboard Screenshots/` show both dashboard pages.