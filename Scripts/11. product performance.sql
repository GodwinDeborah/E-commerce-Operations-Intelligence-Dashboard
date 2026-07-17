/*
===============================================================================
 Script Name : 11. Product Performance.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Product performance analysis to evaluate category performance,
     pricing, product characteristics and marketplace contribution.

 Business Questions Answered
 ---------------------------
 1. Which product categories generate the highest revenue?
 2. Which product categories receive the most orders?
 3. Which product categories have the highest average selling price?
 4. Which categories contribute the most marketplace revenue?
 5. Which products generate the highest revenue?
 6. Which products are ordered most frequently?
 7. Which product categories have the heaviest average products?
 8. Which product categories have the largest average product dimensions?
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Q1. Which product categories generate the highest revenue?
==============================================================================*/

SELECT

    dp.product_category,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_products dp
    ON f.product_key = dp.product_key

GROUP BY dp.product_category

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q2. Which product categories receive the most orders?
==============================================================================*/

SELECT

    dp.product_category,

    COUNT(*) AS Total_Orders

FROM dbo.fact_orders f

JOIN dbo.dim_products dp
    ON f.product_key = dp.product_key

GROUP BY dp.product_category

ORDER BY Total_Orders DESC;
GO


/*==============================================================================
Q3. Which product categories have the highest average selling price?
==============================================================================*/

SELECT

    dp.product_category,

    ROUND(AVG(f.price),2) AS Average_Price

FROM dbo.fact_orders f

JOIN dbo.dim_products dp
    ON f.product_key = dp.product_key

GROUP BY dp.product_category

ORDER BY Average_Price DESC;
GO


/*==============================================================================
Q4. Which product categories contribute the highest percentage of revenue?
==============================================================================*/

WITH category_revenue AS
(
    SELECT

        dp.product_category,

        SUM(f.payment_amount) AS Revenue

    FROM dbo.fact_orders f

    JOIN dbo.dim_products dp
        ON f.product_key = dp.product_key

    GROUP BY dp.product_category
)

SELECT

    product_category,

    Revenue,

    ROUND
    (
        Revenue * 100.0 /
        SUM(Revenue) OVER(),
        2
    ) AS Revenue_Contribution_Percentage

FROM category_revenue

ORDER BY Revenue DESC;
GO


/*==============================================================================
Q5. Which individual products generate the highest revenue?
==============================================================================*/

SELECT TOP (20)

    dp.product_id,

    dp.product_category,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_products dp
    ON f.product_key = dp.product_key

GROUP BY

    dp.product_id,
    dp.product_category

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q6. Which products are ordered most frequently?
==============================================================================*/

SELECT TOP (20)

    dp.product_id,

    dp.product_category,

    COUNT(*) AS Orders

FROM dbo.fact_orders f

JOIN dbo.dim_products dp
    ON f.product_key = dp.product_key

GROUP BY

    dp.product_id,
    dp.product_category

ORDER BY Orders DESC;
GO


/*==============================================================================
Q7. Which product categories have the highest average product weight?
==============================================================================*/

SELECT

    dp.product_category,

    ROUND(AVG(dp.product_weight_g),2) AS Average_Weight_Grams

FROM dbo.dim_products dp

GROUP BY dp.product_category

ORDER BY Average_Weight_Grams DESC;
GO


/*==============================================================================
Q8. Which product categories have the largest average dimensions?
==============================================================================*/

SELECT

    product_category,

    ROUND(AVG(product_length_cm),2) AS Avg_Length_cm,

    ROUND(AVG(product_width_cm),2) AS Avg_Width_cm,

    ROUND(AVG(product_height_cm),2) AS Avg_Height_cm

FROM dbo.dim_products

GROUP BY product_category

ORDER BY Avg_Length_cm DESC;
GO


/*==============================================================================
Q9. Which product categories generate the highest freight costs?
==============================================================================*/

SELECT

    dp.product_category,

    ROUND(AVG(f.freight_cost),2) AS Average_Freight_Cost

FROM dbo.fact_orders f

JOIN dbo.dim_products dp
    ON f.product_key = dp.product_key

GROUP BY dp.product_category

ORDER BY Average_Freight_Cost DESC;
GO
