/*
===============================================================================
 Script Name : 14. Payment Analysis.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
    Analyze customer payment behaviour, payment preferences,
    installment usage and payment contribution to marketplace revenue.

 Business Questions Answered
----------------------------
1. Which payment methods generate the highest revenue?
2. Which payment methods are used most frequently?
3. What percentage of revenue comes from each payment method?
4. What is the average payment amount by payment method?
5. How are installment plans distributed?
6. Which installment plans generate the highest revenue?
7. What is the average payment amount by installment plan?
8. Which payment methods are most commonly used with each installment plan?
9. Which payment methods incur the highest freight costs?
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Q1. Which payment methods generate the highest revenue?
==============================================================================*/

SELECT

    dp.payment_type,
    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_payments AS dp
    ON f.payment_key = dp.payment_key

GROUP BY
    dp.payment_type

ORDER BY
    Total_Revenue DESC;
GO


/*==============================================================================
Q2. Which payment methods are used most frequently?
==============================================================================*/

SELECT

    dp.payment_type,
    COUNT(*) AS Total_Transactions

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_payments AS dp
    ON f.payment_key = dp.payment_key

GROUP BY
    dp.payment_type

ORDER BY
    Total_Transactions DESC;
GO


/*==============================================================================
Q3. What percentage of revenue comes from each payment method?
==============================================================================*/

WITH PaymentRevenue AS
(
    SELECT

        dp.payment_type,
        SUM(f.payment_amount) AS Revenue

    FROM dbo.fact_orders AS f

    INNER JOIN dbo.dim_payments AS dp
        ON f.payment_key = dp.payment_key

    GROUP BY
        dp.payment_type
)

SELECT

    payment_type,

    Revenue,

    ROUND
    (
        Revenue * 100.0 /
        SUM(Revenue) OVER(),
        2
    ) AS Revenue_Contribution_Percentage

FROM PaymentRevenue

ORDER BY Revenue DESC;
GO


/*==============================================================================
Q4. What is the average payment amount by payment method?
==============================================================================*/

SELECT

    dp.payment_type,

    ROUND
    (
        AVG(f.payment_amount),
        2
    ) AS Average_Payment_Amount

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_payments AS dp
    ON f.payment_key = dp.payment_key

GROUP BY
    dp.payment_type

ORDER BY
    Average_Payment_Amount DESC;
GO


/*==============================================================================
Q5. How are installment plans distributed?
==============================================================================*/

SELECT

    dp.payment_installments,

    COUNT(*) AS Total_Orders

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_payments AS dp
    ON f.payment_key = dp.payment_key

GROUP BY
    dp.payment_installments

ORDER BY
    dp.payment_installments;
GO


/*==============================================================================
Q6. Which installment plans generate the highest revenue?
==============================================================================*/

SELECT

    dp.payment_installments,

    SUM(f.payment_amount) AS Total_Revenue

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_payments AS dp
    ON f.payment_key = dp.payment_key

GROUP BY
    dp.payment_installments

ORDER BY
    Total_Revenue DESC;
GO


/*==============================================================================
Q7. What is the average payment amount by installment plan?
==============================================================================*/

SELECT

    dp.payment_installments,

    ROUND
    (
        AVG(f.payment_amount),
        2
    ) AS Average_Payment_Amount

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_payments AS dp
    ON f.payment_key = dp.payment_key

GROUP BY
    dp.payment_installments

ORDER BY
    dp.payment_installments;
GO


/*==============================================================================
Q8. Which payment methods are most commonly used with each installment plan?
==============================================================================*/

SELECT

    dp.payment_type,

    dp.payment_installments,

    COUNT(*) AS Total_Orders

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_payments AS dp
    ON f.payment_key = dp.payment_key

GROUP BY

    dp.payment_type,
    dp.payment_installments

ORDER BY

    dp.payment_type,
    dp.payment_installments;
GO


/*==============================================================================
Q9. Which payment methods incur the highest average freight cost?
==============================================================================*/

SELECT

    dp.payment_type,

    ROUND
    (
        AVG(f.freight_cost),
        2
    ) AS Average_Freight_Cost

FROM dbo.fact_orders AS f

INNER JOIN dbo.dim_payments AS dp
    ON f.payment_key = dp.payment_key

GROUP BY
    dp.payment_type

ORDER BY
    Average_Freight_Cost DESC;
GO
