-- =====================================================
-- Vulcan Project: SQL Analysis
-- Database: VULCAN (PostgreSQL)
-- Tables: customers, vehicles, service_records, complaints
-- (loaded from the cleaned CSV files by sql_analysis.ipynb)
-- =====================================================


-- Check: row count of each table (should be 400, 550, 2200, 350)
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'service_records', COUNT(*) FROM service_records
UNION ALL
SELECT 'complaints', COUNT(*) FROM complaints;


-- Q1: Which service types bring the most revenue?
SELECT service_type,
       COUNT(*) AS total_jobs,
       ROUND(SUM(cost_inr)::numeric, 0) AS total_revenue,
       ROUND(AVG(cost_inr)::numeric, 0) AS avg_cost
FROM service_records
GROUP BY service_type
ORDER BY total_revenue DESC;


-- Q2a: How does the monthly revenue change over time?
-- (the 40 jobs with no service_date are left out)
SELECT TO_CHAR(service_date, 'YYYY-MM') AS service_month,
       COUNT(*) AS total_jobs,
       ROUND(SUM(cost_inr)::numeric, 0) AS total_revenue
FROM service_records
WHERE service_date IS NOT NULL
GROUP BY TO_CHAR(service_date, 'YYYY-MM')
ORDER BY service_month;


-- Q2b: Month-over-month revenue change (window function: LAG)
WITH monthly AS (  
    SELECT DATE_TRUNC('month', service_date) AS service_month,
           SUM(cost_inr) AS total_revenue
    FROM service_records
    WHERE service_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', service_date)
)
SELECT TO_CHAR(service_month, 'YYYY-MM') AS service_month,
       ROUND(total_revenue::numeric, 0) AS total_revenue,
       ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY service_month))::numeric, 0) AS change_inr,
       ROUND((100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY service_month))
              / LAG(total_revenue) OVER (ORDER BY service_month))::numeric, 1) AS change_pct
FROM monthly
ORDER BY service_month;


-- Q3: What is the average service cost for each fuel type?
SELECT v.fuel_type,
       COUNT(*) AS total_jobs,
       COUNT(DISTINCT v.vehicle_id) AS vehicles_serviced,
       ROUND(AVG(s.cost_inr)::numeric, 0) AS avg_cost,
       ROUND(SUM(s.cost_inr)::numeric, 0) AS total_revenue
FROM service_records s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
GROUP BY v.fuel_type
ORDER BY avg_cost DESC;


-- Q4: Who are the top 10 customers by total spend?
SELECT c.customer_id,
       c.name,
       c.city,
       COUNT(DISTINCT v.vehicle_id) AS vehicles_serviced,
       COUNT(*) AS total_jobs,
       ROUND(SUM(s.cost_inr)::numeric, 0) AS total_spent
FROM service_records s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN customers c ON v.customer_id = c.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_spent DESC
LIMIT 10;


-- Q5: What share of customers came back for more than one service?
-- (repeat customer = more than one service record;
--  base = customers with at least one service)
WITH customer_jobs AS (
    SELECT v.customer_id,
           COUNT(*) AS jobs
    FROM service_records s
    JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    GROUP BY v.customer_id
)
SELECT (SELECT COUNT(*) FROM customers) AS total_customers,
       COUNT(*) AS customers_serviced,
       COUNT(*) FILTER (WHERE jobs > 1) AS repeat_customers,
       ROUND(100.0 * COUNT(*) FILTER (WHERE jobs > 1) / COUNT(*), 1) AS repeat_pct
FROM customer_jobs;


-- Q6a: Most common complaint categories and their unresolved share
-- (unresolved = Open or Escalated)
SELECT category,
       COUNT(*) AS total_complaints,
       COUNT(*) FILTER (WHERE status IN ('Open', 'Escalated')) AS unresolved,
       ROUND(100.0 * COUNT(*) FILTER (WHERE status IN ('Open', 'Escalated')) / COUNT(*), 1) AS unresolved_pct
FROM complaints
GROUP BY category
ORDER BY total_complaints DESC;


-- Q6b: Overall share of complaints in each status
SELECT status,
       COUNT(*) AS total_complaints,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM complaints), 1) AS pct_of_all
FROM complaints
GROUP BY status
ORDER BY total_complaints DESC;


-- Q7: Which vehicle makes get the most complaints per vehicle?
-- (LEFT JOIN keeps vehicles that have no complaints)
SELECT v.make,
       COUNT(DISTINCT v.vehicle_id) AS total_vehicles,
       COUNT(c.complaint_id) AS total_complaints,
       ROUND(COUNT(c.complaint_id)::numeric / COUNT(DISTINCT v.vehicle_id), 2) AS complaints_per_vehicle
FROM vehicles v
LEFT JOIN complaints c ON v.vehicle_id = c.vehicle_id
GROUP BY v.make
ORDER BY complaints_per_vehicle DESC;


-- Q8a: Data check: resolution_days does not match status
SELECT status,
       COUNT(*) AS total_complaints,
       COUNT(resolution_days) AS with_days,
       ROUND(AVG(resolution_days)::numeric, 1) AS avg_days
FROM complaints
GROUP BY status
ORDER BY total_complaints DESC;


-- Q8b: Average resolution time per complaint category
-- (only Resolved and Closed complaints that have a value)
SELECT category,
       COUNT(resolution_days) AS complaints_counted,
       ROUND(AVG(resolution_days)::numeric, 1) AS avg_resolution_days
FROM complaints
WHERE status IN ('Resolved', 'Closed')
GROUP BY category
ORDER BY avg_resolution_days DESC;


-- Data check: service records dated before the vehicle's purchase date
SELECT COUNT(*) AS services_before_purchase
FROM service_records s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
WHERE s.service_date < v.purchase_date;
