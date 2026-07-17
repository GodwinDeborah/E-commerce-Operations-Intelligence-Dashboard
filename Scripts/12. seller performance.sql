/*
===============================================================================
 Script Name : 12. Seller Performance.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Seller performance analysis used to evaluate marketplace contribution,
     operational performance and geographic distribution.

 Business Questions Answered
 ---------------------------
 1. Which sellers generate the highest revenue?
 2. Which sellers process the most orders?
 3. Which sellers have the highest average order value?
 4. Which sellers contribute the most marketplace revenue?
 5. Which seller states generate the highest revenue?
 6. Which seller cities generate the highest revenue?
 7. Which seller states process the most orders?
 8. Which sellers have the highest average freight charges?
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Q1. Which sellers generate the highest revenue?
==============================================================================*/

SELECT TOP (20)

    ds.seller_id,
    ds.seller_city,
    ds.seller_state,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

GROUP BY

    ds.seller_id,
    ds.seller_city,
    ds.seller_state

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q2. Which sellers process the most orders?
==============================================================================*/

SELECT TOP (20)

    ds.seller_id,
    ds.seller_city,
    ds.seller_state,

    COUNT(DISTINCT f.order_id) AS Total_Orders

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

GROUP BY

    ds.seller_id,
    ds.seller_city,
    ds.seller_state

ORDER BY Total_Orders DESC;
GO


/*==============================================================================
Q3. Which sellers have the highest average order value?
==============================================================================*/

SELECT TOP (20)

    ds.seller_id,
    ds.seller_city,
    ds.seller_state,

    ROUND(AVG(f.payment_amount),2) AS Average_Order_Value

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

GROUP BY

    ds.seller_id,
    ds.seller_city,
    ds.seller_state

ORDER BY Average_Order_Value DESC;
GO


/*==============================================================================
Q4. Which sellers contribute the highest percentage of marketplace revenue?
==============================================================================*/

WITH seller_revenue AS
(
    SELECT

        ds.seller_id,

        SUM(f.payment_amount) AS Revenue

    FROM dbo.fact_orders f

    JOIN dbo.dim_sellers ds
        ON f.seller_key = ds.seller_key

    GROUP BY ds.seller_id
)

SELECT

    seller_id,

    Revenue,

    ROUND
    (
        Revenue * 100.0 /
        SUM(Revenue) OVER(),
        2
    ) AS Revenue_Contribution_Percentage

FROM seller_revenue

ORDER BY Revenue DESC;
GO


/*==============================================================================
Q5. Which seller states generate the highest revenue?
==============================================================================*/

SELECT

    ds.seller_state,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

GROUP BY ds.seller_state

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q6. Which seller cities generate the highest revenue?
==============================================================================*/

SELECT

    ds.seller_city,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

GROUP BY ds.seller_city

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q7. Which seller states process the most orders?
==============================================================================*/

SELECT

    ds.seller_state,

    COUNT(DISTINCT f.order_id) AS Total_Orders

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

GROUP BY ds.seller_state

ORDER BY Total_Orders DESC;
GO


/*==============================================================================
Q8. Which sellers incur the highest average freight cost?
==============================================================================*/

SELECT TOP (20)

    ds.seller_id,
    ds.seller_city,
    ds.seller_state,

    ROUND(AVG(f.freight_cost),2) AS Average_Freight_Cost

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

GROUP BY

    ds.seller_id,
    ds.seller_city,
    ds.seller_state

ORDER BY Average_Freight_Cost DESC;
GO
