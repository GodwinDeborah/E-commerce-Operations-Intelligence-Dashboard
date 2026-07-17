/*
===============================================================================
 Script Name : 09. Executive Overview.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Executive-level analysis that provides a high-level overview of
     marketplace performance across sales, orders, customers,
     products and operational metrics.

 Business Questions Answered
 ---------------------------
 1. How much revenue has the marketplace generated?
 2. How many unique orders have been processed?
 3. What is the average order value?
 4. What is the average freight cost per order?
 5. How many customers, sellers and products exist?
 6. How has revenue changed over time?
 7. How has order volume changed over time?
 8. Which months generated the highest revenue?
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Q1. How much revenue has the marketplace generated?
==============================================================================*/

SELECT
    SUM(payment_amount) AS Total_Revenue
FROM dbo.fact_orders;
GO

/*==============================================================================
Q2. How many unique orders have been processed?
==============================================================================*/

SELECT
    COUNT(DISTINCT order_id) AS Total_Orders
FROM dbo.fact_orders;
GO

/*==============================================================================
Q3. What is the average order value?
==============================================================================*/

SELECT
    ROUND(AVG(payment_amount),2) AS Average_Order_Value
FROM dbo.fact_orders;
GO

/*==============================================================================
Q4. What is the average freight cost per order?
==============================================================================*/

SELECT
    ROUND(AVG(freight_cost),2) AS Average_Freight_Cost
FROM dbo.fact_orders;
GO

/*==============================================================================
Q5. How many unique customers does the marketplace serve?
==============================================================================*/

SELECT
    COUNT(*) AS Total_Customers
FROM dbo.dim_customers;
GO

/*==============================================================================
Q6. How many active sellers are on the marketplace?
==============================================================================*/

SELECT
    COUNT(*) AS Total_Sellers
FROM dbo.dim_sellers;
GO

/*==============================================================================
Q7. How many unique products are sold?
==============================================================================*/

SELECT
    COUNT(*) AS Total_Products
FROM dbo.dim_products;
GO

/*==============================================================================
Q8. How has marketplace revenue changed over time?
==============================================================================*/

SELECT

    d.year_number,
    d.month_number,
    d.month_name,

    SUM(f.payment_amount) AS Monthly_Revenue

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_date AS d
    ON f.date_key = d.date_key

GROUP BY

    d.year_number,
    d.month_number,
    d.month_name

ORDER BY

    d.year_number,
    d.month_number;
GO

/*==============================================================================
Q9. How has marketplace order volume changed over time?
==============================================================================*/

SELECT

    d.year_number,
    d.month_number,
    d.month_name,

    COUNT(DISTINCT f.order_id) AS Monthly_Orders

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_date AS d
    ON f.date_key = d.date_key

GROUP BY

    d.year_number,
    d.month_number,
    d.month_name

ORDER BY

    d.year_number,
    d.month_number;
GO

/*==============================================================================
Q10. Which months generated the highest revenue?
==============================================================================*/

SELECT

    d.year_number,
    d.month_name,

    SUM(f.payment_amount) AS Revenue

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_date AS d
    ON f.date_key = d.date_key

GROUP BY

    d.year_number,
    d.month_name

ORDER BY

    Revenue DESC;
GO

/*==============================================================================
Q11. Which months processed the most orders?
==============================================================================*/

SELECT

    d.year_number,
    d.month_name,

    COUNT(DISTINCT f.order_id) AS Orders_Processed

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_date AS d
    ON f.date_key = d.date_key

GROUP BY

    d.year_number,
    d.month_name

ORDER BY

    Orders_Processed DESC;
GO

/*==============================================================================
Q12. Executive KPI Summary
==============================================================================*/

SELECT

    COUNT(DISTINCT order_id)          AS Total_Orders,
    COUNT(DISTINCT customer_key)      AS Total_Customers,
    COUNT(DISTINCT seller_key)        AS Total_Sellers,
    COUNT(DISTINCT product_key)       AS Total_Products,

    SUM(payment_amount)               AS Total_Revenue,

    SUM(price)                        AS Total_Product_Sales,

    SUM(freight_cost)                 AS Total_Freight,

    ROUND(AVG(payment_amount),2)      AS Average_Order_Value,

    ROUND(AVG(freight_cost),2)        AS Average_Freight

FROM dbo.fact_orders;
GO
