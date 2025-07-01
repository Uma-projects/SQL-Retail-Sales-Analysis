# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Retail_sales`

This project uses a retail sales dataset containing timestamped transactions including customer demographics, product categories, quantities, prices, and order values. The goal is to answer real-world business questions using advanced SQL techniques such as aggregation, filtering, ranking, and window functions.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_sales`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Reatail_sales;

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
```

### 2. Data Cleaning

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```

### 2. Data Exploration

```sql
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
```

### 3. Data Analysis & Business Key Problems & Answers--

The following SQL queries were developed to answer specific business questions:

1. **Sales on a Specific Date**
```sql
--Q1. Retrieve complete transaction details for all sales made specifically on November 5th, 2022.
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';
```

2. **Category-Based Filter with Quantity Threshold**
```sql
--Q2. Identify all purchases made under the 'Clothing' category during November 2022 where the quantity sold was at least 4 units.
SELECT *
FROM retail_sales
WHERE
	category='Clothing' AND
	quantity>=4 AND
	sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

3. **Total Revenue per Product Category**
```sql
--Q3. Calculate the total revenue generated (total_sale) for each product category across the entire dataset.
SELECT
	category,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;
```

4. **Average Age of Beauty Product Customers**
```sql
--Q4. Determine the average age of customers who have made purchases in the 'Beauty' category.
SELECT
	ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category='Beauty';
```

5. **High-Value Transactions**
```sql
--Q5. Retrieve all transactions where the total sale value exceeded ₹1000, indicating high-value purchases.
SELECT *
FROM retail_sales
WHERE total_sale>1000;
```

6. **Transactions Grouped by Gender and Category**
```sql
--Q6. Count the total number of transactions segmented by gender and category, to understand purchase patterns across demographics.
SELECT
	gender,
	category,
	COUNT(transactions_id) AS unique_transactions
FROM retail_sales
GROUP BY gender,category;
```

7. **Monthly Averages & Best Month Per Year**
```sql
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
```

8. **Top 5 Customers by Total Sales**
```sql
--Q8. List the top 5 customers who have contributed the highest cumulative sales over the entire dataset.
SELECT
	customer_id,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC LIMIT 5;
```

9. **Unique Customers per Category**
```sql
--Q9. Determine how many unique customers made purchases in each product category.
SELECT
	category,
	COUNT(DISTINCT(customer_id)) AS unique_customers
FROM retail_sales
GROUP BY category;
```

10. **Shift-Based Sales Distribution**
```sql
SELECT
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
		ELSE 'evening'
	END AS shift,
	COUNT(*) AS uniue_orders
FROM retail_sales
GROUP BY shift;
```

## Findings

- Clothing and Beauty are top-performing categories by volume and revenue.
- Peak transactions happen in Afternoon shifts.
- November tends to show high customer activity.
- Certain age groups and genders show preferences for specific categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `sql_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

##  Credits

Developed by Umashankar as part of a SQL portfolio to demonstrate real-world analytics skills.
For more projects, visit my GitHub!
