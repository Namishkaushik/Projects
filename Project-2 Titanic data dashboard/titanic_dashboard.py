# titanic_dashboard_plotly.py
import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

st.set_page_config(page_title="Titanic Dashboard", layout="wide")

st.title("🚢 Titanic Survival Dashboard (Stylish Edition)")

# File upload
uploaded_file = st.file_uploader("Upload Titanic CSV file", type=["csv"])
if uploaded_file:
    df = pd.read_csv(uploaded_file)

    # Preprocessing
    df['FamilySize'] = df['SibSp'] + df['Parch']
    df['CabinAvailable'] = df['Cabin'].notnull()
    df['AgeGroup'] = pd.cut(df['Age'], bins=[0,12,18,35,50,80], 
                            labels=["Child","Teen","Young Adult","Adult","Senior"])

    # Layout: use columns for side-by-side charts
    # 1. Survival Rate Overall
    col1, col2 = st.columns(2)
    with col1:
        st.subheader("1. Survival Rate Overall")
        fig = px.pie(df, names=df['Survived'].map({0:"Not Survived",1:"Survived"}), 
                     title="Overall Survival Rate", hole=0.4, color_discrete_sequence=px.colors.sequential.RdBu)
        st.plotly_chart(fig, use_container_width=True)

    # 2. Survival by Gender
    with col2:
        st.subheader("2. Survival by Gender")
        gender_survival = df.groupby("Sex")["Survived"].mean().reset_index()
        fig = px.bar(gender_survival, x="Sex", y="Survived", 
                     title="Survival Rate by Gender", color="Sex", text="Survived")
        fig.update_traces(texttemplate='%{text:.2f}', textposition="outside")
        st.plotly_chart(fig, use_container_width=True)

    # 3. Survival by Passenger Class
    col3, col4 = st.columns(2)
    with col3:
        st.subheader("3. Survival by Passenger Class")
        fig = px.histogram(df, x="Pclass", color="Survived", barmode="stack", 
                           title="Survival by Class", color_discrete_map={0:"red",1:"green"})
        st.plotly_chart(fig, use_container_width=True)

    # 4. Age Distribution
    with col4:
        st.subheader("4. Age Distribution of Passengers")
        fig = px.histogram(df, x="Age", nbins=30, title="Age Distribution", color_discrete_sequence=["#636EFA"])
        st.plotly_chart(fig, use_container_width=True)

    # 5. Survival by Age Group
    col5, col6 = st.columns(2)
    with col5:
        st.subheader("5. Survival by Age Group")
        age_survival = df.groupby("AgeGroup")["Survived"].mean().reset_index()
        fig = px.bar(age_survival, x="AgeGroup", y="Survived", title="Survival Rate by Age Group", text="Survived")
        fig.update_traces(texttemplate='%{text:.2f}', textposition="outside")
        st.plotly_chart(fig, use_container_width=True)

    # 6. Fare vs Survival
    with col6:
        st.subheader("6. Fare vs Survival")
        fig = px.scatter(df, x="Fare", y="Survived", color="Survived", 
                         title="Fare vs Survival", color_discrete_map={0:"red",1:"green"})
        st.plotly_chart(fig, use_container_width=True)

    # 7. Family Size Impact
    col7, col8 = st.columns(2)
    with col7:
        st.subheader("7. Family Size Impact")
        fam_survival = df.groupby("FamilySize")["Survived"].mean().reset_index()
        fig = px.bar(fam_survival, x="FamilySize", y="Survived", title="Survival Rate by Family Size", text="Survived")
        fig.update_traces(texttemplate='%{text:.2f}', textposition="outside")
        st.plotly_chart(fig, use_container_width=True)

    # 8. Survival by Embarkation Port
    with col8:
        st.subheader("8. Survival by Embarkation Port")
        port_survival = df.groupby("Embarked")["Survived"].mean().reset_index()
        fig = px.bar(port_survival, x="Embarked", y="Survived", title="Survival Rate by Port", text="Survived")
        fig.update_traces(texttemplate='%{text:.2f}', textposition="outside")
        st.plotly_chart(fig, use_container_width=True)

    # 9. Cabin Availability vs Survival
    col9, col10 = st.columns(2)
    with col9:
        st.subheader("9. Cabin Availability vs Survival")
        cabin_survival = df.groupby("CabinAvailable")["Survived"].mean().reset_index()
        fig = px.bar(cabin_survival, x="CabinAvailable", y="Survived", 
                     title="Survival Rate by Cabin Availability", text="Survived")
        fig.update_traces(texttemplate='%{text:.2f}', textposition="outside")
        st.plotly_chart(fig, use_container_width=True)

    # 10. Combined Insight (Class + Gender)
    with col10:
        st.subheader("10. Combined Insight (Class + Gender)")
        fig = px.bar(df.groupby(["Pclass","Sex"])["Survived"].mean().reset_index(), 
                     x="Pclass", y="Survived", color="Sex", barmode="group", 
                     title="Survival by Class + Gender", text="Survived")
        fig.update_traces(texttemplate='%{text:.2f}', textposition="outside")
        st.plotly_chart(fig, use_container_width=True)
