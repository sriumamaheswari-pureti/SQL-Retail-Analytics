

# 🛒 SQL Retail Analytics Mini Project

## 📌 Project Overview

This project focuses on performing **end-to-end data analysis using SQL** on a retail dataset.
The goal is to simulate real-world business scenarios by solving **manager-driven requirements** and generating actionable insights.



## 🗂️ Database Schema

The project consists of the following tables:

* **Customers** → Customer details
* **Stores** → Store information
* **Products** → Product categories
* **Sales** → Transactional data

📊 Total Records: **1000+ sales transactions**



## ⚙️ Project Workflow

### 1️⃣ Data Understanding

* Analyzed overall business performance
* Calculated KPIs:

  * Total Revenue
  * Total Transactions
  * Average Order Value (AOV)
  * Quantity Sold



### 2️⃣ Data Cleaning

* Handled missing values using:

  * `NVL()`
  * `COALESCE()`
* Created cleaned dataset for accurate analysis
* Calculated **net revenue (amount - discount)**



### 3️⃣ Filtering & Conditional Analysis

* Applied filters using:

  * `WHERE`
  * `BETWEEN`
  * `IN`, `NOT IN`
* Extracted insights based on:

  * Sales range
  * Store/category filters
  * Date conditions



### 4️⃣ Aggregation & Grouping

* Used:

  * `GROUP BY`
  * `HAVING`
* Analyzed:

  * Revenue per store
  * Revenue per category
  * Customer-wise spending
  * Daily & monthly sales



### 5️⃣ Customer Segmentation (CASE WHEN)

* Segmented customers into:

  * High / Medium / Low spenders
* Classified:

  * Transactions (Big / Small)
  * Sales buckets
  * Store performance tiers



### 6️⃣ Joins (Multi-Table Analysis)

* Used:

  * `INNER JOIN`
  * `LEFT JOIN`
* Combined multiple tables to analyze:

  * Customer + Store + Product insights
  * Cross-category purchases
  * Store-wise customer count



### 7️⃣ Window Functions (Advanced Analytics)

* Applied:

  * `RANK()`
  * `DENSE_RANK()`
  * `LAG()` / `LEAD()`
  * Running totals

* Performed:

  * Customer ranking
  * Sales growth analysis
  * Moving averages



 8️⃣ NTILE (Customer Segmentation)

* Divided customers into segments:

  * Top 25%
  * Mid-level
  * Bottom customers
* Created **marketing-ready customer groups**



 9️⃣ Time-Series Analysis

* Used date functions:

  * `EXTRACT()`
  * `SYSDATE`
* Analyzed:

  * Daily & monthly trends
  * Sales growth over time
  * Recent vs historical performance



 📈 Key Insights

* Identified **top-performing stores and categories**
* Analyzed **customer behavior and spending patterns**
* Measured **impact of discounts on revenue**
* Tracked **sales trends and growth patterns**
* Created **customer segments for business decisions**



 🧠 Skills Demonstrated

* SQL Query Writing
* Data Cleaning & Transformation
* Analytical Thinking
* Business Problem Solving
* Data Aggregation & Segmentation
* Advanced SQL (Window Functions)



## 🚀 Key Takeaway

This project demonstrates how SQL can be used not just for querying data, but for:

> **solving real-world business problems and generating actionable insights**

---

## 🛠️ Tools Used

* SQL (Oracle SQL)

---


💡 *This project is part of my continuous learning journey in Data Analytics.*


