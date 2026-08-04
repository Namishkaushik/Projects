# 🚢 Titanic Survival Dashboard

An interactive data visualization dashboard built with **Streamlit**, **Plotly**, and **Pandas** to explore passenger survival patterns from the Titanic dataset.

The dashboard allows users to upload a Titanic CSV file and instantly generate interactive visualizations that uncover relationships between passenger characteristics and survival.

---

# 📌 Project Overview

The Titanic Survival Dashboard performs basic data preprocessing and presents key insights through interactive charts.

The application enables users to:

- Upload any Titanic dataset in CSV format
- Explore survival patterns
- Compare passenger demographics
- Analyze the impact of class, gender, age, fare, family size, and embarkation port on survival

---

# 🛠️ Technologies Used

- Python
- Streamlit
- Pandas
- Plotly Express
- Plotly Graph Objects

---

# 📂 Dataset

The dashboard works with the standard Titanic dataset containing features such as:

- Passenger Class (Pclass)
- Sex
- Age
- Fare
- Cabin
- Embarked
- SibSp
- Parch
- Survival Status

---

# ⚙️ Features

### Data Upload

- Upload Titanic CSV files directly through the Streamlit interface.

### Data Preprocessing

The dashboard automatically creates additional features including:

- Family Size
- Cabin Availability
- Age Groups

---

# 📊 Dashboard Visualizations

The dashboard contains the following interactive visualizations:

1. Overall Survival Rate
2. Survival Rate by Gender
3. Survival by Passenger Class
4. Passenger Age Distribution
5. Survival Rate by Age Group
6. Fare vs Survival
7. Family Size Impact on Survival
8. Survival by Embarkation Port
9. Cabin Availability vs Survival
10. Survival by Passenger Class and Gender

---

# 📈 Key Insights

Some insights that can be derived from the dashboard include:

- Female passengers had significantly higher survival rates than males.
- First-class passengers survived more frequently than lower classes.
- Children generally had better survival rates.
- Passengers paying higher fares tended to survive more often.
- Travelling with a small family often resulted in better survival chances.
- Cabin information is positively associated with survival.
- Survival rates also vary across embarkation ports.

---

# 🚀 How to Run

### Clone the repository

```bash
git clone https://github.com/YourUsername/Titanic-Survival-Dashboard.git
```

### Navigate into the project

```bash
cd Titanic-Survival-Dashboard
```

### Install dependencies

```bash
pip install streamlit pandas plotly
```

### Run the application

```bash
streamlit run titanic_dashboard.py
```

---

# 📁 Project Structure

```
Titanic-Survival-Dashboard/
│
├── titanic_dashboard.py
├── Titanic.csv
├── dashboard.png
├── requirements.txt
└── README.md
```

---

# 🎯 Learning Outcomes

Through this project, I gained experience with:

- Interactive dashboard development using Streamlit
- Data preprocessing with Pandas
- Data visualization using Plotly
- Building user-friendly analytical applications
- Exploratory Data Analysis (EDA)
- Feature engineering

---

# 🔮 Future Improvements

- Add interactive filters and slicers
- Display KPI cards (Overall Survival Rate, Average Fare, Total Passengers)
- Add downloadable reports
- Include machine learning predictions for survival probability
- Improve dashboard styling with custom themes

---

# 👤 Author

**Namish Kaushik**

Aspiring Data Analyst | Data Science Student

GitHub: https://github.com/NamishKaushik
