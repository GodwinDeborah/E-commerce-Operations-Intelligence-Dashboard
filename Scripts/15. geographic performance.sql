/*
===============================================================================
 Script Name : 15. Geographic Performance.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Geographic analysis of marketplace performance to identify
     high-performing regions, customer concentration, seller concentration
     and regional growth opportunities.

 Business Questions Answered
 ---------------------------
 1. Which customer states generate the highest revenue?
 2. Which seller states generate the highest revenue?
 3. Which customer states place the most orders?
 4. Which seller states process the most orders?
 5. Which customer cities generate the highest revenue?
 6. Which seller cities generate the highest revenue?
 7. Which states contribute the most marketplace revenue?
 8. Where are customers concentrated?
 9. Where are sellers concentrated?
10. Which states have the largest customer-to-seller imbalance?
11. Which states have the highest average order value?
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Q1. Which customer states generate the highest revenue?
==============================================================================*/

SELECT

    dc.customer_state,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_customers dc
    ON f.customer_key = dc.customer_key

GROUP BY dc.customer_state

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q2. Which seller states generate the highest revenue?
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
Q3. Which customer states place the most orders?
==============================================================================*/

SELECT

    dc.customer_state,

    COUNT(DISTINCT f.order_id) AS Total_Orders

FROM dbo.fact_orders f

JOIN dbo.dim_customers dc
    ON f.customer_key = dc.customer_key

GROUP BY dc.customer_state

ORDER BY Total_Orders DESC;
GO


/*==============================================================================
Q4. Which seller states process the most orders?
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
Q5. Which customer cities generate the highest revenue?
==============================================================================*/

SELECT TOP (20)

    dc.customer_city,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_customers dc
    ON f.customer_key = dc.customer_key

GROUP BY dc.customer_city

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q6. Which seller cities generate the highest revenue?
==============================================================================*/

SELECT TOP (20)

    ds.seller_city,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_sellers ds
    ON f.seller_key = ds.seller_key

GROUP BY ds.seller_city

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q7. Which customer states contribute the highest percentage of revenue?
==============================================================================*/

WITH state_revenue AS
(
    SELECT

        dc.customer_state,

        SUM(f.payment_amount) AS Revenue

    FROM dbo.fact_orders f

    JOIN dbo.dim_customers dc
        ON f.customer_key = dc.customer_key

    GROUP BY dc.customer_state
)

SELECT

    customer_state,

    Revenue,

    ROUND
    (
        Revenue * 100.0 /
        SUM(Revenue) OVER(),
        2
    ) AS Revenue_Contribution_Percentage

FROM state_revenue

ORDER BY Revenue DESC;
GO


/*==============================================================================
Q8. Where are customers concentrated?
==============================================================================*/

SELECT

    customer_state,

    COUNT(*) AS Total_Customers,

    ROUND
    (
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS Customer_Share_Percentage

FROM dbo.dim_customers

GROUP BY customer_state

ORDER BY Total_Customers DESC;
GO


/*==============================================================================
Q9. Where are sellers concentrated?
==============================================================================*/

SELECT

    seller_state,

    COUNT(*) AS Total_Sellers,

    ROUND
    (
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS Seller_Share_Percentage

FROM dbo.dim_sellers

GROUP BY seller_state

ORDER BY Total_Sellers DESC;
GO


/*==============================================================================
Q10. Which states have the largest customer-to-seller imbalance?
==============================================================================*/

WITH customer_counts AS
(
    SELECT

        customer_state AS state,

        COUNT(*) AS total_customers

    FROM dbo.dim_customers

    GROUP BY customer_state
),

seller_counts AS
(
    SELECT

        seller_state AS state,

        COUNT(*) AS total_sellers

    FROM dbo.dim_sellers

    GROUP BY seller_state
)

SELECT

    c.state,

    c.total_customers,

    ISNULL(s.total_sellers,0) AS total_sellers,

    ROUND
    (
        c.total_customers * 1.0 /
        NULLIF(ISNULL(s.total_sellers,0),0),
        2
    ) AS customer_to_seller_ratio

FROM customer_counts c

LEFT JOIN seller_counts s
    ON c.state = s.state

ORDER BY customer_to_seller_ratio DESC;
GO


/*==============================================================================
Q11. Which states have the highest average order value?
==============================================================================*/

SELECT

    dc.customer_state,

    ROUND(AVG(f.payment_amount),2) AS Average_Order_Value

FROM dbo.fact_orders f

JOIN dbo.dim_customers dc
    ON f.customer_key = dc.customer_key

GROUP BY dc.customer_state

ORDER BY Average_Order_Value DESC;
GO
