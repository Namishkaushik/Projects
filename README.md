# Data Science Projects

This repository contains my hands-on data analysis, visualization, and business intelligence projects.

Each project focuses on solving real-world problems using Python, SQL, Power BI, and data analysis techniques. The objective is to demonstrate my skills in data cleaning, SQL analysis, exploratory data analysis (EDA), dashboard development, and generating actionable business insights.

**Skills Demonstrated:** Data Cleaning, ETL Pipelines, SQL (PostgreSQL), Exploratory Data Analysis (EDA), Data Visualization, Dashboard Development, Business Intelligence, Feature Engineering

---

# 📌 Projects

## 1. VULCAN: Garage Operations Analysis

**Tools:** Python, Pandas, SQLAlchemy, PostgreSQL, SQL, Power BI

**Focus:** End-to-End Data Pipeline (Cleaning → Database → SQL Analysis → Dashboard)

- Built a complete pipeline on a synthetic garage/dealership dataset (4 related tables, ~3,500 raw rows): raw CSVs → Pandas cleaning → PostgreSQL → SQL analysis → Power BI dashboard with a live database connection.
- Cleaned messy data with documented decisions:
  - Merged 15 duplicate customers and updated the foreign keys of their vehicles
  - Standardised 15 fuel-type spellings into 4 categories
  - Treated placeholder values (-999, -1) as missing instead of real numbers
- Answered 8 business questions using joins, CTEs, FILTER and window functions (LAG).
- Found that EVs cost ~11% more per job, but only ~3% more once the mix of service types is held equal.
- Dropped a 94.2% repeat-customer rate because it could not separate loyal customers from others, and documented the dataset's limitations.
- Built a 2-page Power BI dashboard (Business Performance, Customers and Complaints) with a city slicer.

---

## 2. Superstore Sales Dashboard

**Tools:** Microsoft Excel, Power BI

**Focus:** Business Intelligence & Sales Analysis

- Analyzed Superstore sales data using Excel Pivot Tables and Power BI dashboards.
- Designed an interactive dashboard to monitor business performance through key metrics and visualizations.
- Created KPI cards for:
  - Total Sales
  - Total Profit
  - Total Quantity Sold
- Developed business-focused visualizations including:
  - Month-to-month Sales and Profit by Year
  - Sales by Category and Sub-Category
  - Sales by Customer Segment
  - Sales by Ship Mode and Payment Mode
  - Sales per State (map) with a region slicer
- Identified high-performing categories, profitable regions, customer trends, and loss-making product categories.
- Provided business recommendations to support inventory planning, pricing strategies, and regional sales improvements.

---

## 3. Titanic Survival Dashboard

**Tools:** Python, Streamlit, Plotly

**Focus:** Interactive Data Dashboard

- Built an interactive web dashboard to explore survival patterns from the Titanic dataset.
- Implemented dynamic CSV upload with automatic feature engineering, including:
  - Family Size
  - Age Group
  - Cabin Availability
- Developed 10 interactive visualizations covering:
  - Survival by Gender
  - Passenger Class
  - Age Distribution
  - Fare vs Survival
  - Family Size Impact
  - Embarkation Port
  - Cabin Availability
  - Combined Passenger Class and Gender Analysis
- Built using Streamlit and Plotly for an interactive user experience.

---

## 4. Student Performance Analysis

**Tools:** Python, Pandas, Matplotlib, Seaborn

**Focus:** Exploratory Data Analysis (EDA)

- Analyzed academic, behavioral, and family-related factors affecting student performance.
- Studied the impact of:
  - Study time
  - Absences
  - Alcohol consumption (weekday & weekend)
  - Internet access
  - Parental education
  - Family support
- Used grouping, aggregation, binning, and a correlation heatmap to identify trends.
- Interpreted results while considering sample size and dataset limitations.

---

# 🔧 Tools & Technologies

- Python
- Pandas
- SQL (PostgreSQL)
- SQLAlchemy
- Jupyter Notebook
- Streamlit
- Plotly
- Matplotlib / Seaborn
- Microsoft Excel
- Power BI

---

# 🚀 About Me

I am a B.Voc Software Development student with a growing interest in Data Science, Data Analytics, and Business Intelligence.

This repository showcases my practical learning journey through real-world projects involving data cleaning, SQL analysis, visualization, and dashboard development. I continuously expand my skills by building projects that transform raw data into meaningful insights.

More projects will be added as I continue learning and exploring the field of Data Science.

---

# 📫 Connect with Me

**GitHub:** https://github.com/NamishKaushik

**LinkedIn:** https://www.linkedin.com/in/namish-kaushik-a62aa2339