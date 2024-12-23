""" Business context:  
In the banking sector, customer retention is a critical aspect of sustaining profitability and growth, 
espectical for services that rely on recurring use, such as credit cards. The dataset for this project represents a financial institution
dealing with increasing customer churn, which impacts the bank’s revenue and reputation. This project aims to analyze the reasons why customers
discontinue the company's services. From there, it will develop appropriate strategies for the future.
Objective: 
Analyze which factors affect the churn rate of bank customers.
Provide actionable insights for bank to reduce churn rate and improve its business
"""

-- Data Processing
""" Clean data """ 

-- Delete the last 2 column -- 
ALTER TABLE BankChurners 
DROP NaiveBayes1 ,NaiveBayes2

-- Find the data shape 
SELECT COUNT(*) AS row_count
FROM BankChurners;

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_NAME = 'BankChurners';

SELECT *
FROM BankChurners bc 
WHERE bc.Avg_Utilization_Ratio IS NULL; 


-- Find the Unique data 
-- Standardize the Data 
SELECT DISTINCT Education_Level 
FROM BankChurners bc ;

SELECT DISTINCT Marital_Status 
FROM BankChurners bc ;

SELECT DISTINCT Income_Category 
FROM BankChurners bc;

SELECT DISTINCT Card_Category 
FROM BankChurners bc;

CREATE TABLE Churner(
SELECT  *
FROM BankChurners bc 
WHERE bc.Education_Level != "Unknown" AND bc.Marital_Status != "Unknown" AND
bc.Income_Category != "Unknown");

-- 1. Remove Duplicates 
-- 2. Standardize the Data 
-- 3. Null values or blank values 
-- 4. Remove Any columns 


-- -- 

ALTER TABLE Churner 
ADD COLUMN row_num int; 

SELECT *
FROM Churner;

UPDATE Churner AS c  
JOIN (
SELECT CLIENTNUM,
ROW_NUMBER() OVER(
PARTITION BY Attrition_Flag, Customer_Age, Gender, Dependent_count, Education_level, Marital_Status, Income_Category, 
Card_Category, Months_on_book, Total_Relationship_Count, Months_Inactive_12_mon, 
Contacts_Count_12_mon, Credit_Limit, Total_Revolving_Bal, Avg_Open_To_Buy, Total_Amt_Chng_Q4_Q1,Total_Trans_Amt,
Total_Trans_Ct,Total_Ct_Chng_Q4_Q1, Avg_Utilization_Ratio
ORDER BY CLIENTNUM) AS row_num 
FROM Churner) AS t ON c.CLIENTNUM = t.CLIENTNUM
SET c.row_num = t.row_num ;

--  Select only the unique records where RowNum = 1
SELECT *
FROM Churner
WHERE row_num = 1;

-- delete row_num
ALTER TABLE Churner 
DROP COLUMN row_num;

-- Standardizing data ( only need with clientnum)
-- SELECT CLIENTNUM,TRIM(CLIENTNUM)
-- from Churner;
-- 
-- UPDATE Churner
-- SET CLIENTNUM = TRIM(CLIENTNUM);

SELECT *
FROM Churner;


-- Find the Null data 

SELECT CLIENTNUM
FROM Churner b
WHERE b.CLIENTNUM IS NULL ;

SELECT *
FROM Churner b 
WHERE b.Attrition_Flag IS NULL;

SELECT *
FROM BankChurners bc 
WHERE bc.Customer_Age IS NULL;

SELECT *
FROM Churner b 
WHERE b.Gender IS NULL;

SELECT *
FROM Churner b 
WHERE b.Dependent_count IS NULL;

SELECT *
FROM Churner b  
WHERE b.Education_Level IS NULL;

SELECT *
FROM Churner b 
WHERE b.Marital_Status IS NULL; 

SELECT *
FROM Churner b 
WHERE b.Income_Category IS NULL;

SELECT *
FROM Churner b 
WHERE b.Card_Category IS NULL;

SELECT *
FROM Churner b 
WHERE b.Months_on_book IS NULL; 

SELECT *
FROM Churner b 
WHERE b.Total_Relationship_Count IS NULL;

SELECT *
FROM Churner b 
WHERE b.Months_Inactive_12_mon IS NULL;

SELECT *
FROM Churner b 
WHERE b.Contacts_Count_12_mon IS NULL; 

SELECT *
FROM Churner b  
WHERE b.Credit_Limit IS NULL; 

SELECT *
FROM Churner b  
WHERE b.Total_Revolving_Bal IS NULL; 

SELECT *
FROM Churner b  
WHERE b.Avg_Open_To_Buy IS NULL; 

SELECT *
FROM Churner b 
WHERE b.Total_Amt_Chng_Q4_Q1 IS NULL; 

SELECT *
FROM Churner b 
WHERE b.Total_Trans_Amt IS NULL; 

SELECT *
FROM Churner b  
WHERE b.Total_Trans_Ct IS NULL; 

SELECT *
FROM Churner b 
WHERE b.Total_Ct_Chng_Q4_Q1 IS NULL; 

SELECT *
FROM Churner b  
WHERE b.Avg_Utilization_Ratio IS NULL;

"""Analyze data"""

-- Calculate counts for each catefgory of Attrition_Flag 
--CREATE TABLE Attition_flag AS 
SELECT COUNT(Attrition_Flag) AS Distribution_of_Attrition_Flag, Attrition_Flag 
FROM Churner
GROUP BY Attrition_Flag;

--  Gender, Attrition_flag, count, percentage, percentage_gender 
-- Percentage of Attrition by Gender 
SELECT *
FROM Churner ;

--CREATE TABLE Gender AS 
SELECT Attrition_Flag, Gender, count(*), count(*) * 100/SUM(count(*)) OVER () AS percentage,
count(*)*100 / Sum(count(*)) OVER (PARTITION BY Gender) AS percentage_gender
FROM Churner C
Group By Attrition_Flag , Gender;

-- Percentage of Attrition by Income Category  
SELECT DISTINCT Income_Category 
FROM Churner c;

--CREATE TABLE Income_Category AS 
SELECT Income_Category, Attrition_flag, count(*),  count(*) * 100/SUM(count(*)) OVER () AS percentage,
count(*)*100 / Sum(count(*)) OVER (PARTITION BY Income_Category) AS Percentage_income
FROM Churner c 
GROUP BY Income_Category , Attrition_Flag;

-- Attrition Percentage By customer__Age - Attrition_Flag
--CREATE TABLE Customer_Age AS
SELECT Customer_Age , Attrition_flag, count(*),  count(*) * 100/SUM(count(*)) OVER () AS percentage,
count(*)*100 / Sum(count(*)) OVER (PARTITION BY Customer_Age) AS Percentage_Customer_Age
FROM Churner c 
GROUP BY Customer_Age , Attrition_Flag;

-- Attrition Percentage By Card Category - Gender -Attrition_Flag
--CREATE TABLE Card_Category AS 
SELECT Attrition_Flag, Card_Category , Gender, count(*), count(*) * 100/SUM(count(*)) OVER () AS percentage
FROM Churner 
GROUP BY Attrition_Flag , Card_Category, Gender

-- Depedent_count ( how many people are dependent on a credit card)
--CREATE TABLE Dependent_count AS
SELECT Attrition_Flag, Dependent_count , count(*)
FROM Churner 
GROUP BY Attrition_Flag, Dependent_count;


-- Marital_status, count(*), percentage, total_count, Percenatage status
--CREATE TABLE Marital_status AS
SELECT  Marital_status,Attrition_flag, count(*), count(*) * 100/SUM(count(*)) OVER () AS percentage
FROM Churner c 
GROUP BY Marital_status,Attrition_flag


-- Attrition_flag by Months_on_book
--CREATE TABLE Months_on_book AS
SELECT  Months_on_book ,Attrition_flag, count(*), count(*) * 100/SUM(count(*)) OVER () AS percentage
FROM Churner c 
GROUP BY Months_on_book ,Attrition_flag;

-- Percentage of Attrition by Education_Level, nên tính total count của mỗi level, và phần trăm 
--CREATE TABLE Education AS
SELECT Education_Level,Attrition_Flag, count(*), count(*) * 100/SUM(count(*)) OVER () AS percentage
FROM Churner 
GROUP BY Education_Level, Attrition_flag;

-- Total Transaction Count (Last 12 months) - Total_Trans_Ct
-- CREATE TABLE Tran_count_last_12months AS 
SELECT Total_Trans_Ct, Attrition_Flag
FROM Churner;
SELECT *
FROM Churner;

-- Change in Transaction Count (Q4 over Q1)  - Total_Ct_Chng_Q4_Q1
-- Total count change Q4 to Q1 by Attrition Flag ( box )
--CREATE TABLE Trans_count_Q4_over_Q1 AS
SELECT Total_Ct_Chng_Q4_Q1, Attrition_Flag  #Box chart 
FROM Churner;

-- Calculate the sum of Total_Ct_Chng_Q4_Q1for each category of Attrition_Flag
--CREATE TABLE Total_Count_change_Q4_Q1 AS 
SELECT SUM(Total_Ct_Chng_Q4_Q1) AS Total_Count_Change_Q4_Q1_By_Attrition_Flag, Attrition_Flag
FROM Churner
GROUP BY Attrition_Flag ;  #Bar chart 

-- Total Revolving Balance on the Credit Card 
--CREATE TABLE Revolving_Balance AS 
SELECT Total_Revolving_Bal, Attrition_Flag 
FROM Churner ;

-- Calculate the sum of Total_Revolving_Bal for each category of Attrition_Flag 
--CREATE TABLE Total_Revolving_Balance AS 
SELECT SUM(Total_Revolving_Bal) AS Total_Revolving_Balance, Attrition_Flag 
FROM Churner
GROUP BY Attrition_Flag ;  #Bar chart 

-- No. of Contacts in the last 12 months (contacts_count_12_mon)
--CREATE TABLE No_of_Contacts AS 
SELECT Attrition_Flag, Months_Inactive_12_mon, count(*), count(*) * 100/SUM(count(*)) OVER () AS percentage
FROM Churner
GROUP BY  Attrition_Flag, Months_Inactive_12_mon ; 

-- Calculate the sum of Contacts_Count_12_mon for each category of Attrition_Flag 
-- CREATE TABLE Total_Contacts AS
SELECT SUM(Contacts_Count_12_mon) AS Contacts_Count_12_months, Attrition_Flag 
FROM Churner
GROUP BY Attrition_Flag; #Bar chart 

-- Calculate the sum of contacts_count_12_mon for each category of Attrition_flag
-- Existing Customer
-- CREATE TABLE Contact_count_Existing AS
SELECT Contacts_Count_12_mon ,Attrition_Flag, count(*), count(*) * 100/SUM(count(*)) OVER () AS percentage
FROM Churner 
WHERE Attrition_Flag = "Existing Customer"
GROUP BY Contacts_Count_12_mon , Attrition_flag;  #Bar chart 

-- Attrited Customer 
-- CREATE TABLE Contact_count_Attrited AS 
SELECT Contacts_Count_12_mon ,Attrition_Flag, count(*), count(*) * 100/SUM(count(*)) OVER () AS percentage
FROM Churner 
WHERE Attrition_Flag = "Attrited Customer"
GROUP BY Contacts_Count_12_mon , Attrition_flag;  #Bar chart 

-- Average Card Utilization Ratio by Attrition flag 
--CREATE TABLE Avg_Utilization_Ratio AS
SELECT Avg_Utilization_Ratio , Attrition_Flag 
FROM Churner;

-- total Avg_Utilization_Ratio by Attrition flag 
--CREATE TABLE Total_Avg_Utilization_Ratio AS 
SELECT SUM(Avg_Utilization_Ratio) AS Total_Utilization_Ratio, Attrition_Flag
FROM Churner 
GROUP BY
Attrition_Flag;

-- credit limit 
SELECT *
FROM Churner;

-- CREATE TABLE Credit_Card AS 
SELECT Credit_Limit, Attrition_Flag 
FROM Churner







