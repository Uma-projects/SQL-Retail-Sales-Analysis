--SQL RETAIL SALE ANALYSIS--

--Creating Database
CREATE DATABASE Reatail_sales;

--Creating Table
DROP TABLE IF EXISTS retail_sales
CREATE TABLE retail_sales (
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(20),
	age INT,
	category VARCHAR(20),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales;

--Data Cleaning
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	age IS NULL OR
	category IS NULL OR
	quantiy	IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
	quantiy	IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;

--Data Exploration

--No. of uniques sales
SELECT COUNT(*)
FROM retail_sales;

--Top selling categories
SELECT
	category,
	SUM(quantity) AS unique_orders
FROM retail_sales
GROUP BY category;

--Monthly Sales Trend
SELECT
	DATE_TRUNC('month',sale_date) as sale_month,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY sale_month
ORDER BY sale_month;

--Unique customers
SELECT
COUNT (DISTINCT(customer_id)) AS unique_customers
FROM retail_sales;

--Data Analysis & Business Key Problems & Answers--

--Q1. Retrieve complete transaction details for all sales made specifically on November 5th, 2022.
--Q2. Identify all purchases made under the 'Clothing' category during November 2022 where the quantity sold was at least 4 units.
--Q3. Calculate the total revenue generated (total_sale) for each product category across the entire dataset.
--Q4. Determine the average age of customers who have made purchases in the 'Beauty' category.
--Q5. Retrieve all transactions where the total sale value exceeded ₹1000, indicating high-value purchases.
--Q6. Count the total number of transactions segmented by gender and category, to understand purchase patterns across demographics.
--Q7. Analyze monthly sales by calculating the average sale per month, and identify the highest-grossing month in each year.
--Q8. List the top 5 customers who have contributed the highest cumulative sales over the entire dataset.
--Q9. Determine how many unique customers made purchases in each product category.
--Q10. Categorize each sale into time-based shifts:
--Morning (before 12 PM)
--Afternoon (12 PM to 5:59 PM)
--Evening (after 6 PM)
--Then count the total number of transactions per shift.

--Q1. Retrieve complete transaction details for all sales made specifically on November 5th, 2022.
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';

--Q2. Identify all purchases made under the 'Clothing' category during November 2022 where the quantity sold was at least 4 units.
SELECT *
FROM retail_sales
WHERE
	category='Clothing' AND
	quantity>=4 AND
	sale_date BETWEEN '2022-11-01' AND '2022-11-30';

--Q3. Calculate the total revenue generated (total_sale) for each product category across the entire dataset.
SELECT
	category,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;

--Q4. Determine the average age of customers who have made purchases in the 'Beauty' category.
SELECT
	ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category='Beauty';

--Q5. Retrieve all transactions where the total sale value exceeded ₹1000, indicating high-value purchases.
SELECT *
FROM retail_sales
WHERE total_sale>1000;

--Q6. Count the total number of transactions segmented by gender and category, to understand purchase patterns across demographics.
SELECT
	gender,
	category,
	COUNT(transactions_id) AS unique_transactions
FROM retail_sales
GROUP BY gender,category;

--Q7. Analyze monthly sales by calculating the average sale per month, and identify the highest-grossing month in each year.
SELECT *
FROM
	(SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS average_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
	FROM retail_sales
	GROUP BY year,month)
WHERE sales_rank=1;

--Q8. List the top 5 customers who have contributed the highest cumulative sales over the entire dataset.
SELECT
	customer_id,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC LIMIT 5;

--Q9. Determine how many unique customers made purchases in each product category.
SELECT
	category,
	COUNT(DISTINCT(customer_id)) AS unique_customers
FROM retail_sales
GROUP BY category;

--Q10. Categorize each sale into time-based shifts:
--Morning (before 12 PM)
--Afternoon (12 PM to 5:59 PM)
--Evening (after 6 PM)
--Then count the total number of transactions per shift.
SELECT
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
		ELSE 'evening'
	END AS shift,
	COUNT(*) AS uniue_orders
FROM retail_sales
GROUP BY shift;

--END--

