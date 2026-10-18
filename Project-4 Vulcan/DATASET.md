# Vulcan Project — Raw Synthetic Dataset

Simulated garage/dealership operational data (India-context: cities, ₹ costs,
EV + ICE vehicle mix). **This is the RAW, uncleaned version** — the messiness
is intentional and is what your Python ETL step should fix.

## Tables

### customers.csv (415 rows)
| column | type | notes |
|---|---|---|
| customer_id | str | e.g. C0001. Note: ~15 intentional duplicate customers exist with IDs C90xx — same person, re-registered |
| name | str | some duplicate rows have inconsistent casing/spacing |
| phone | str | 10-digit |
| email | str | **~26 missing (null)** |
| city | str | one of 10 Indian cities |
| signup_date | date | |

### vehicles.csv (550 rows)
| column | type | notes |
|---|---|---|
| vehicle_id | str | e.g. V0001 |
| customer_id | str | FK to customers |
| make | str | 10 brands, mix of EV-only (Ola Electric, Ather) and ICE/hybrid brands |
| model | str | |
| fuel_type_raw | str | **MESSY ON PURPOSE** — 15 inconsistent variants like 'EV','ev','Electric','electric','Battery Electric','Petrol','petrol','PETROL','Diesel','diesel','DIESEL','Hybrid','hybrid','HEV','Gasoline'. Needs standardizing into a clean `fuel_type` column (EV / Petrol / Diesel / Hybrid) |
| registration_year | int | |
| purchase_date | date | |
| odometer_km | float | **12 missing (NaN)**, **4 outliers set to -999** (bad sentinel value — needs handling, not just dropping) |

### service_records.csv (2,210 rows)
| column | type | notes |
|---|---|---|
| service_id | str | e.g. S00001 |
| vehicle_id | str | FK to vehicles |
| service_date | date | **40 missing (null)** |
| service_type | str | 11 categories — EVs skew toward Battery Check/Software Update/Motor Repair, ICE skews toward Oil Change/Brake Repair |
| technician | str | **some null (unassigned)** |
| cost_inr | float | **6 rows have -1 (bad/garbage value)** — needs handling |
| days_taken | int | |

Note: **~10 duplicate rows** exist (double-entry mistake) — same service_id repeated.

### complaints.csv (350 rows)
| column | type | notes |
|---|---|---|
| complaint_id | str | e.g. CMP0001 |
| vehicle_id | str | FK to vehicles |
| complaint_date | date | |
| category | str | **8 missing (null)** |
| status | str | **MESSY CASING ON PURPOSE** — 'Open','open','Resolved','RESOLVED','Escalated','Closed'. Needs standardizing |
| resolution_days | float | null if unresolved |

## Suggested cleaning checklist (for your ETL script)
- [ ] Standardize `fuel_type_raw` → clean `fuel_type` (EV/Petrol/Diesel/Hybrid)
- [ ] Standardize `status` casing in complaints
- [ ] Handle missing emails, odometer, service_date, technician (decide: impute vs flag vs drop)
- [ ] Fix -999 odometer sentinel values and -1 cost values (treat as missing, not literal)
- [ ] Deduplicate customers (fuzzy match on name+phone) and service_records (exact ID dupes)
- [ ] Join vehicles → customers, service_records → vehicles, complaints → vehicles for your final analytical tables

## Suggested analysis questions (for your SQL step)
1. Average repair cost: EV vs ICE
2. Revenue by month/quarter
3. Repeat-customer rate (customers with >1 service record)
4. Most common complaint category by vehicle make
5. Average resolution time by complaint status
6. Service type distribution: EV vs ICE
