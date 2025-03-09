Create database Lung_Cancer;
CREATE TABLE lung_cancer (
    ID INT ,
    Country VARCHAR(255),
    Population_Size INT,
    Age INT,
    Gender VARCHAR(10),
    Smoker VARCHAR(3),
    Years_of_Smoking INT,
    Cigarettes_per_Day INT,
    Passive_Smoker VARCHAR(3),
    Family_History VARCHAR(3),
    Lung_Cancer_Diagnosis VARCHAR(3),
    Cancer_Stage VARCHAR(50),
    Survival_Years INT,
    Adenocarcinoma_Type VARCHAR(50),
    Air_Pollution_Exposure VARCHAR(10),
    Occupational_Exposure VARCHAR(3),
    Indoor_Pollution VARCHAR(3),
    Healthcare_Access VARCHAR(50),
    Early_Detection VARCHAR(3),
    Treatment_Type VARCHAR(50),
    Developed_or_Developing VARCHAR(50),
    Annual_Lung_Cancer_Deaths INT,
    Lung_Cancer_Prevalence_Rate FLOAT,
    Mortality_Rate FLOAT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Lung Cancer.csv' 
INTO TABLE lung_cancer 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

ALTER TABLE lung_cancer MODIFY ID INT  PRIMARY KEY;


select * from lung_cancer where country="china" ;
DESC  lung_cancer;

-- Basic Level
-- 1. Retrieve all records for individuals diagnosed with lung cancer.
Select * from lung_cancer where Lung_Cancer_Diagnosis="Yes" ;

-- 2. Count the number of smokers and non-smokers.
Select 
    Sum(case when smoker="Yes" then 1 else 0 end) as Smoker_Count,
    sum(case when smoker="No" then 1 else 0 end) as Non_Smoker_Count
from lung_cancer;
-- 3. List all unique cancer stages present in the dataset.
select distinct Cancer_Stage 
from lung_cancer;
-- 4. Retrieve the average number of cigarettes smoked per day by smokers.
Select Avg(Cigarettes_per_day) as Avg_Cigarettes_Smoked 
from lung_cancer 
where smoker="Yes";
-- 5. Count the number of people exposed to high air pollution.
Select COUNT(*) AS High_Air_Pollution_Exposure 
From lung_cancer 
Where Air_Pollution_Exposure = 'High';
-- 6. Find the top 5 countries with the highest lung cancer deaths.
Select Country,Avg(Annual_Lung_Cancer_Deaths) as Total_Deaths 
from lung_cancer 
group by Country
order by Total_Deaths Desc
Limit 5;
-- 7. Count the number of people diagnosed with lung cancer by gender.
Select Gender,count(*) 
from lung_cancer
Where Lung_Cancer_Diagnosis="Yes"
Group by Gender; 
-- 8. Retrieve records of individuals older than 60 who are diagnosed with lung cancer.
Select * from lung_cancer 
where Age>60 and lung_cancer_diagnosis="Yes";

-- Intermediate Level
-- 1. Find the percentage of smokers who developed lung cancer.
SELECT 
    (COUNT(CASE WHEN Smoker = 'Yes' AND Lung_Cancer_Diagnosis = 'Yes' THEN 1 END) * 100.0 / 
     COUNT(CASE WHEN Smoker = 'Yes' THEN 1 END)) AS Percentage_Smokers_With_Cancer
FROM lung_cancer;

-- 2. Calculate the average survival years based on cancer stages.
Select Cancer_Stage,Avg(Survival_Years) as Avg_Survival_Years
from lung_cancer 
where Lung_cancer_diagnosis="yes"
group by Cancer_Stage;
-- 3. Count the number of lung cancer patients based on passive smoking.
Select Passive_Smoker  as Patient_Count,count(*) from lung_cancer 
where lung_cancer_diagnosis="Yes" 
group by passive_smoker;

-- 4. Find the country with the highest lung cancer prevalence rate.
Select Country ,max(Lung_Cancer_Prevalence_Rate) as Highest_Prevalence
from lung_cancer 
group by Country 
order  by Highest_Prevalence Desc 
limit 1;
-- 5. Identify the smoking years' impact on lung cancer.
select Years_of_Smoking,count(*) as Cancer_Patients
from lung_cancer
where Lung_Cancer_Diagnosis="Yes"
group by Years_of_Smoking
order by Years_of_Smoking;
-- 6. Determine the mortality rate for patients with and without early detection.
select Early_Detection,avg(mortality_rate ) as Avg_Mortality_Rate
from lung_cancer 
where Lung_Cancer_Diagnosis="Yes"
group by Early_Detection;
-- 7. Group the lung cancer prevalence rate by developed vs. developing countries.
SELECT Developed_or_Developing, 
       AVG(Lung_Cancer_Prevalence_Rate) AS Avg_Prevalence_Rate
FROM lung_cancer
GROUP BY Developed_or_Developing;

-- Advanced Level
-- 1. Identify the correlation between lung cancer prevalence and air pollution levels.
SELECT Air_Pollution_Exposure, AVG(Lung_Cancer_Prevalence_Rate) AS Avg_Prevalence
FROM lung_cancer
GROUP BY Air_Pollution_Exposure
ORDER BY Avg_Prevalence DESC;

-- 2. Find the average age of lung cancer patients for each country.
select country,avg(age) as Avg_Age
from lung_cancer
where Lung_Cancer_Diagnosis="Yes"
group by Country
order by Avg_Age;
-- 3. Calculate the risk factor of lung cancer by smoker status, passive smoking, and family history.
SELECT 
Smoker, Passive_Smoker, Family_History, 
COUNT(*) AS Cancer_Patients, 
(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM lung_cancer WHERE Lung_Cancer_Diagnosis = 'Yes')) 
AS Risk_Percentage
FROM lung_cancer
WHERE Lung_Cancer_Diagnosis = 'Yes'
GROUP BY Smoker, Passive_Smoker, Family_History
ORDER BY Risk_Percentage DESC;
-- 4. Rank countries based on their mortality rate.
SELECT Country, MAX(Mortality_Rate) AS Max_Mortality_Rate,
RANK() OVER (ORDER BY MAX(Mortality_Rate) DESC) AS Rank_of_country
FROM lung_cancer
GROUP BY Country;

-- 5. Determine if treatment type has a significant impact on survival years.
SELECT Treatment_Type, AVG(Survival_Years) AS Avg_Survival
FROM lung_cancer
WHERE Lung_Cancer_Diagnosis = 'Yes'
GROUP BY Treatment_Type
ORDER BY Avg_Survival DESC;
-- 6. Compare lung cancer prevalence in men vs. women across countries.
SELECT Country, Gender, 
       AVG(Lung_Cancer_Prevalence_Rate) AS Avg_Prevalence
FROM lung_cancer
GROUP BY Country, Gender
ORDER BY Country, Avg_Prevalence DESC;
 
-- 7. Find how occupational exposure, smoking, and air pollution collectively impact lung cancer rates.
SELECT Occupational_Exposure, Smoker, Air_Pollution_Exposure, 
       COUNT(*) AS Cancer_Patients
FROM lung_cancer
WHERE Lung_Cancer_Diagnosis = 'Yes'
GROUP BY Occupational_Exposure, Smoker, Air_Pollution_Exposure
ORDER BY Cancer_Patients DESC;

-- 8. Analyze the impact of early detection on survival years.
SELECT Early_Detection, AVG(Survival_Years) AS Avg_Survival
FROM lung_cancer
WHERE Lung_Cancer_Diagnosis = 'Yes'
GROUP BY Early_Detection;



