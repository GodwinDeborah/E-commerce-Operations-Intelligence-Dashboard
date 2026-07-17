/*
===============================================================================
 Script Name : 10. Customer Behaviour.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Customer analytics to understand purchasing behaviour,
     customer distribution and revenue contribution.

 Business Questions Answered
 ---------------------------
 1. Which states have the most customers?
 2. Which cities have the most customers?
 3. Which states generate the highest revenue?
 4. Which cities generate the highest revenue?
 5. Which states place the most orders?
 6. Which cities place the most orders?
 7. Which states have the highest average order value?
 8. Which cities have the highest average order value?
 9. Which states contribute the most marketplace revenue?
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Q1. Which states have the most customers?
==============================================================================*/

SELECT

    customer_state,
    COUNT(*) AS Total_Customers

FROM dbo.dim_customers

GROUP BY customer_state

ORDER BY Total_Customers DESC;
GO


/*==============================================================================
Q2. Which cities have the most customers?
==============================================================================*/

SELECT

    customer_city,
    COUNT(*) AS Total_Customers

FROM dbo.dim_customers

GROUP BY customer_city

ORDER BY Total_Customers DESC;
GO


/*==============================================================================
Q3. Which customer states generate the highest revenue?
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
Q4. Which customer cities generate the highest revenue?
==============================================================================*/

SELECT

    dc.customer_city,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders f

JOIN dbo.dim_customers dc
    ON f.customer_key = dc.customer_key

GROUP BY dc.customer_city

ORDER BY Total_Revenue DESC;
GO


/*==============================================================================
Q5. Which states place the most orders?
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
Q6. Which cities place the most orders?
==============================================================================*/

SELECT

    dc.customer_city,

    COUNT(DISTINCT f.order_id) AS Total_Orders

FROM dbo.fact_orders f

JOIN dbo.dim_customers dc
    ON f.customer_key = dc.customer_key

GROUP BY dc.customer_city

ORDER BY Total_Orders DESC;
GO


/*==============================================================================
Q7. Which customer states have the highest average order value?
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


/*==============================================================================
Q8. Which customer cities have the highest average order value?
==============================================================================*/

SELECT

    dc.customer_city,

    ROUND(AVG(f.payment_amount),2) AS Average_Order_Value

FROM dbo.fact_orders f

JOIN dbo.dim_customers dc
    ON f.customer_key = dc.customer_key

GROUP BY dc.customer_city

ORDER BY Average_Order_Value DESC;
GO


/*==============================================================================
Q9. Which customer states contribute the highest percentage of revenue?
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
