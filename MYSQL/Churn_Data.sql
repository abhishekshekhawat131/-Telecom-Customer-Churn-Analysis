create database telecom_churn;
use telecom_churn;
SELECT * FROM churn_data;
select count(*) from churn_data;
SELECT * FROM churn_data LIMIT 5;

# Phase 1:
-- Q1: Retrieve all customers who have churned.
select * from churn_data
where Churn = "Yes";

-- Q2: Find all female senior citizens who are on a month-to-month contract.
select * from churn_data
where gender = "Female"	
and SeniorCitizen = 1
and Contract = "Month-to-month";

SELECT DISTINCT SeniorCitizen FROM churn_data;

-- Q3.	List all customers who have neither a partner nor dependents and have churned.
select * from churn_data
where Partner = "No"
and Dependents = "No"
and Churn = "Yes";

-- Q4.	Find customers whose MonthlyCharges is greater than 70 and have churned.
select * from churn_data;
select * from Churn_data
where MonthlyCharges >70
and Churn = "Yes";

-- Q5.	Retrieve all customers who use Fiber optic internet and have no OnlineSecurity.
select * from churn_data
where InternetService = "Fiber optic"
and OnlineSecurity = "No";

# Phase 2 — GROUP BY & Aggregations
-- Q6.	Find the total number of churned vs retained customers.
/* COUNT(*) means count all rows — it does not refer to any specific column. */
select churn, count(*) as `Total Customers`
from churn_data
group by churn;

-- Q7: Calculate the average MonthlyCharges for churned and retained customers.
select churn, round(avg(MonthlyCharges),2) as `Avg Monthly Charges`  from churn_data
group by churn;

-- Q8. Find the count of customers by Contract type.
select Contract , count(*)  as `Total Customers` 
from churn_data
group by Contract;

-- Q9.	Which PaymentMethod has the highest number of churned customers?
select PaymentMethod, COUNT(*) as `Total Churn Customers`
from churn_data
where Churn = 'Yes'
group by PaymentMethod
order by `Total Churn Customers` desc
limit 1;

-- Q10.	Find the average tenure for each InternetService type.
select InternetService, round(avg(tenure), 2) as `Avg Tenure`
from churn_data
group by InternetService;

# Phase 3 — HAVING
-- Q11.	Find all Contract types where average MonthlyCharges exceeds 60.
select Contract ,round(avg(MonthlyCharges),2) as `Avg Monthly Charges`
from churn_data
group by Contract
having avg(MonthlyCharges) >60;

-- Q12.	Find InternetService types that have more than 1000 churned customers.
select InternetService , count(*) as `Total Churned`
from churn_data where Churn = "Yes"
group by InternetService
having `Total Churned` > 1000;

-- Q13.	Find PaymentMethod groups where total customers exceed 1500.
select PaymentMethod , count(*) as `Total  Customers`
from churn_data
group by PaymentMethod
having  count(*) >1500;

/* Error — Using alias in HAVING:
It works sometimes but mostly dosent so please make sure */

-- 14.	Which tenure values have more than 100 churned customers?-- 
select tenure , count(*) as `Churned Customers`
from churn_data
where Churn = "Yes"
group by tenure
having count(*)>100;

# Phase 4 Subqueries
-- Q 15.	Find all customers whose MonthlyCharges is above the average MonthlyCharges of churned customers.

/* This is a Non-Correlated Subquery. as used comparision operator and has single column*/
select MonthlyCharges from churn_data
where MonthlyCharges >( select avg(MonthlyCharges) from churn_data where  Churn = "Yes") ;

-- Q16.	Find customers who have the same Contract type **as the majority of churned customers**.
select * from churn_data 
where Contract = (select Contract from churn_data 
                  where Churn = "Yes"
                  group by Contract 
                  order by Count(*) desc 
                  limit 1);
                  
-- Q17.	Retrieve customers whose TotalCharges is greater than the average TotalCharges of all fiber optic customers.
select * from churn_data
where TotalCharges > (select avg(TotalCharges) from churn_data where InternetService = 'Fiber optic'); 

DESCRIBE churn_data;

-- Q18.	Find customers who have churned and belong to the **most common PaymentMethod** among churned customers.
select * from churn_data where churn = "Yes"
and PaymentMethod = (select PaymentMethod from churn_data 
                     where churn = "Yes" group by PaymentMethod
					 order by count(*) desc limit 1);
                     
/* --  So your instinct that "majority" and "most common" mean 
the same statistical concept is correct — both use GROUP BY ... 
ORDER BY COUNT(*) DESC LIMIT 1 to find that dominant category.
 That part really is identical logic.-- */
 
 -- Q19.	Rank customers by MonthlyCharges within each Contract type using RANK().
select CustomerID,MonthlyCharges,Contract,
rank() over(partition by Contract order by MonthlyCharges desc) as rnk
from churn_data ;

/* Window function's internal ordering:- ✅ Controls how rnk is calculated
                                         ❌ Has no effect on row display order
										 - ORDER BY MonthlyCharges DESC inside OVER(...)
Final row order in your result set:- ✅ Controls how the rows are displayed
									- ORDER BY Contract, rnk outside, at the end of the query
                                    */
                                    
-- Q20.	Find the top 3 highest paying customers in each InternetService group using DENSE_RANK().
select CustomerID , InternetService, MonthlyCharges, rnk from (
select CustomerID , InternetService, MonthlyCharges,
dense_rank() over(partition by InternetService order by MonthlyCharges desc) rnk
from churn_data) ranked
where rnk<=3;

-- Q21.	Calculate **running total** of TotalCharges ordered by tenure using SUM() OVER.
select totalcharges, tenure, 
sum(totalcharges) over(order by tenure  desc) as rnk
from churn_data;

-- **Q22.	Find the difference in MonthlyCharges between each customer and the next customer using LEAD().
select customerid, tenure, monthlycharges,
lead(monthlycharges) over(order by tenure) as next_customer_charge,
lead(monthlycharges) over(order by tenure) - monthlycharges as charge_difference
from churn_data;

-- Q23.	Create a summary table joining customer demographics with their churn status.
# -- Step 1: Create demographics view
CREATE VIEW customer_demographics AS
SELECT customerID, gender, SeniorCitizen, Partner, Dependents, tenure
FROM churn_data;

# -- Step 2: Create churn view  
CREATE VIEW customer_churn_status AS
SELECT customerID, Contract, MonthlyCharges, TotalCharges, Churn
FROM churn_data;

# -- Step 3: JOIN both views
SELECT d.customerID, d.gender, d.SeniorCitizen, d.Partner, 
       d.Dependents, d.tenure, c.Contract, c.MonthlyCharges, c.Churn,c.totalcharges
FROM customer_demographics d
JOIN customer_churn_status c ON d.customerID = c.customerID
LIMIT 10;

-- Q24.	Find customers who share the same tenure as any churned customer.
select *
from churn_data
where tenure in (
    select tenure
    from churn_data
    where churn = 'Yes'
);