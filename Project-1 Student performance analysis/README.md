# Student Performance Analysis
 
## 📌 Project Overview
This project explores the factors that influence students' academic performance using a real-world student dataset.  
The analysis focuses on understanding how academic habits, family background, and lifestyle choices relate to final grades.
 
---
 
## 🎯 Objectives
- Analyze average final grades across different student groups
- Understand the relationship between:
  - Study time and grades
  - Absences and academic performance
  - Alcohol consumption and grades
  - Internet access and performance
  - Parental education and student outcomes
  - Family support and grades
  - Gender and academic performance
  - School attended and academic performance
 
---
 
## 📊 Key Analysis Performed
- Grouped analysis using `groupby()`
- Aggregation using `agg()` (mean, count)
- Category mapping using `map()`
- Binning continuous variables using `pd.cut()`
- Data visualizations using `matplotlib` and `seaborn`
- Interpretation of trends with sample-size awareness
 
---
 
## 🔍 Key Insights
- Female students have a slightly higher average final grade compared to male students.
- Higher study time is generally associated with higher average final grades.
- Increased absences show a negative relationship with academic performance.
- Higher alcohol consumption tends to correlate with lower grades, with weekend consumption showing a stronger effect.
- Students with family support and educated parents show slightly better academic outcomes.
- Students with internet access perform marginally better on average.
- Academic performance varies slightly across schools (GP vs MS), suggesting school-level factors may play a role.
- Some categories show variability due to smaller sample sizes and should be interpreted cautiously.
 
---
 
## 🛠️ Tools Used
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook
 
---
 
## 📁 Files
- `student analysis.ipynb` – Main analysis notebook
- `README.md` – Project documentation
- `student-por.csv` – Dataset (UCI ML Repository — Portuguese secondary school students)
 
---
 
## 📌 Notes
This project focuses on **exploratory data analysis**, not predictive modeling.  
It is intended to demonstrate data understanding, reasoning, and interpretation skills.
