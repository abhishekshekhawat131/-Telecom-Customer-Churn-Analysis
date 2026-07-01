📊 Telecom Customer Churn Analysis


End-to-end data analytics project analyzing 7,043 telecom customers to identify churn patterns, revenue impact, and customer segments using Python, SQL, and Power BI.




🎯 Problem Statement

Telecom companies lose significant revenue due to customer churn. This project analyzes customer data to:


Identify why customers churn
Find which segments are at highest risk
Quantify revenue lost due to churn
Build an interactive dashboard for business decisions



🛠️ Tools & Technologies

ToolPurposePython (Pandas, Seaborn, Matplotlib)Data cleaning, EDA, visualizationSQL (MySQL)Data querying, aggregations, window functionsPower BIInteractive dashboard, DAX measures


📁 Project Structure

telecom-churn-analysis/
│
├── data/
│   └── telco_churn_cleaned.csv
│
├── python/
│   └── Churn_Prediction.ipynb
│
├── sql/
│   └── Churn_Data.sql
│
├── powerbi/
│   └── churn_dashboard.pbix
│   └── dashboard_screenshot.png
│
└── README.md


🐍 Python — EDA Highlights

Libraries: Pandas, Matplotlib, Seaborn

Key analysis performed:


Data cleaning — fixed TotalCharges null values, type conversion
Duplicate & dirty null detection
Univariate Analysis — distribution of tenure, MonthlyCharges, TotalCharges
Skewness analysis (TotalCharges = 0.96, right skewed)
Outlier detection using IQR method on MonthlyCharges
Churn rate distribution — 26.54% churned, 73.46% retained
Gender split analysis
Bivariate & multivariate analysis across all features


Key Finding:


MonthlyCharges is bimodal — two customer segments exist: basic plan users (~₹20) and premium plan users (~₹75-80)




🗄️ SQL — Query Phases

Phase 1 — Basic Filtering


Churned customers retrieval
Female senior citizens on month-to-month contracts
Customers with no partner/dependents who churned
High MonthlyCharges (>70) churned customers
Fiber optic + no OnlineSecurity customers


Phase 2 — GROUP BY & Aggregations


Churned vs retained customer count
Average MonthlyCharges by churn status
Customer count by Contract type
Highest churned PaymentMethod
Average tenure by InternetService type


Phase 3 — HAVING Clause


Contract types with avg MonthlyCharges > 60
InternetService types with > 1000 churned customers
PaymentMethod groups with > 1500 customers
Tenure values with > 100 churned customers


Phase 4 — Subqueries & Window Functions


Customers above average MonthlyCharges of churned segment
Customers matching majority contract type of churned customers
RANK() — customers ranked by MonthlyCharges within Contract type
DENSE_RANK() — top 3 highest paying per InternetService group
SUM() OVER — running total of TotalCharges by tenure
LEAD() — MonthlyCharges difference between consecutive customers
Views + JOIN — customer demographics with churn status summary



📊 Power BI Dashboard

Page 1 — Overview


KPI Cards: Total Customers, Churn Rate%, Churned Customers, High Value Churn
Churn Rate by Tenure Group (Column Chart)
Churn Rate by Payment Method (Bar Chart)
Churn Distribution (Donut Chart)
Slicers: Contract, Internet Services


Page 2 — Revenue Analysis


KPI Cards: Avg Monthly Churned, Avg Monthly Retained, Revenue Lost, Revenue Retained
Avg Monthly Charge by Churn Status (Bar Chart)
Revenue Lost by Contract Type (Pie Chart)


Page 3 — Customer Segmentation


Senior Citizen Churn (Donut Chart)
Internet Service Churn (Treemap)
Partner & Dependents (Clustered Column)
TechSupport vs OnlineSecurity (Matrix Table)
High Value Customer Churn Rate (Gauge Chart)
Slicers: Contract, High Value Label


DAX Measures Created

daxTotal Customers = COUNTROWS('telcom churn')

Churned Customers = 
CALCULATE(COUNTROWS('telcom churn'), 'telcom churn'[Churn] = "Yes")

Churn Rate % = DIVIDE([Churned Customers], [Total Customers], 0) * 100

Revenue Lost = 
CALCULATE(SUM('telcom churn'[TotalCharges]), 'telcom churn'[Churn] = "Yes")

Revenue Retained = 
CALCULATE(SUM('telcom churn'[TotalCharges]), 'telcom churn'[Churn] = "No")

Avg Monthly Churned = 
CALCULATE(AVERAGE('telcom churn'[MonthlyCharges]), 'telcom churn'[Churn] = "Yes")

Avg Monthly Retained = 
CALCULATE(AVERAGE('telcom churn'[MonthlyCharges]), 'telcom churn'[Churn] = "No")


🔍 Key Insights

InsightFindingOverall Churn Rate26.54% — 1 in 4 customers leavingHighest Risk ContractMonth-to-month churns 10x more than 2-yearHighest Risk ServiceFiber optic customers churn ~42%Payment RiskElectronic check users churn 3x more than auto-payTenure Risk0-12 month customers have highest churn (~47%)Add-on ImpactCustomers without TechSupport churn 3x moreSenior CitizensChurn ~41% vs 24% for non-seniorsRevenue Lost$2.86M lost due to churn


📌 How to Run

Python:

bashpip install pandas matplotlib seaborn
jupyter notebook Churn_Prediction.ipynb

SQL:

sql-- Run in MySQL Workbench
source Churn_Data.sql

Power BI:


Open churn_dashboard.pbix in Power BI Desktop
Connect to MySQL local server (127.0.0.1:3306)
Database: telecom_churn, Table: churn_data



📈 Dataset


Source: IBM Telco Customer Churn Dataset (Kaggle)
Rows: 7,043 customers
Features: 24 columns
Target: Churn (Yes/No)



🙋 Author

Abhishek Singh Shekhawat



