# Retail Revenue & Sales Analysis (SQL)
![SQL](https://img.shields.io/badge/SQL-Structured_Query_Language-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791?logo=postgresql&logoColor=white)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-Insights-green)

## 📌 Project Overview

This project focuses on performing a comprehensive analysis of retail sales data using SQL. The goal is to extract actionable business insights by exploring customer demographics, purchasing patterns, and profitability across various product categories.

---

## 🗄️ Database Schema

The analysis is performed on the `retail_sales` table with the following structure:

```sql
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(20),
    quantiy INT,
    price_per_unit INT,
    cogs FLOAT,
    total_sale FLOAT
);
```

---

## 🧹 Data Cleaning & Exploration

Before analysis, the dataset was checked for NULL values to ensure data integrity.

### Key Metrics Explored:

* Total transaction count
* Unique customer count
* Category diversity

---

## 📊 Key Business Questions & SQL Solutions

### 1. 💰 Category Profitability & Margins

**Objective:** Identify which product categories are the most efficient at generating profit.

```sql
SELECT 
    category,
    SUM(total_sale - cogs) AS total_profit,
    ROUND((SUM(total_sale - cogs) / SUM(total_sale) * 100)::numeric, 2) AS profit_margin_percentage
FROM retail_sales
GROUP BY category
ORDER BY profit_margin_percentage DESC;
```

---

### 2. ⏰ Operational Shift Analysis

**Objective:** Determine sales volume across different time shifts (Morning, Afternoon, Evening).

```sql
WITH Hourly_sales AS (
    SELECT *,
    CASE 
        WHEN EXTRACT(hour FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(hour FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
    FROM retail_sales 
) 
SELECT 
    shift, 
    COUNT(*) AS total_orders
FROM Hourly_sales
GROUP BY shift;
```

---

### 3. 👥 Customer Demographic Insights

**Objective:** Find the average age of customers shopping in the Beauty category.

```sql
SELECT 
    ROUND(AVG(age), 2) AS average_age 
FROM retail_sales 
WHERE category = 'Beauty';
```

---

### 4. 📈 Peak Monthly Performance

**Objective:** Identify the highest-performing month for each year.

```sql
SELECT year, month, avg_sale 
FROM ( 
    SELECT 
        EXTRACT(year FROM sale_date) AS year, 
        EXTRACT(month FROM sale_date) AS month, 
        AVG(total_sale) AS avg_sale, 
        RANK() OVER (
            PARTITION BY EXTRACT(year FROM sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1,2 
) AS t1 
WHERE rank = 1;
```

---

### 5. 📅 Weekend vs. Weekday Trends

**Objective:** Compare transaction volume and revenue between weekdays and weekends.

```sql
WITH daily_sales AS (
    SELECT *,
        CASE 
            WHEN TO_CHAR(sale_date, 'Day') IN ('Saturday ', 'Sunday ') THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type
    FROM retail_sales
)
SELECT 
    day_type,
    COUNT(*) AS total_orders,
    SUM(total_sale) AS total_revenue
FROM daily_sales
GROUP BY day_type;
```

---

## 🛠️ Technical Skills Applied

* Advanced Aggregations: `SUM`, `AVG`, `COUNT`
* Data Transformation: `CASE`, CTEs
* Window Functions: `RANK()`
* Date & Time Functions: `EXTRACT`, `TO_CHAR`
* Data Precision: Numeric casting and rounding

---

## 🔍 Project Findings

* **Profitability:** Identified top-performing product categories based on margin percentage
* **Customer Behavior:** Analyzed purchasing patterns based on demographics
* **Time Trends:** Discovered peak hours and best-performing months
* **Business Insight:** Helps optimize staffing, marketing, and inventory decisions

---

## 👩‍💻 Author

**Lipi Virmani**
🔗 [LinkedIn](https://www.linkedin.com/in/lipi-virmani)

---

## 📄 License

This project is licensed under the MIT License.
