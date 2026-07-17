/*
===============================================================================
 Script Name : 03. ETL Validation.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Validates the Extract, Transform and Load (ETL) process by ensuring
     that the star schema has been loaded correctly and that referential
     integrity has been maintained.

 Objectives:
     - Validate row counts
     - Verify dimension loads
     - Verify fact table load
     - Detect orphan records
     - Detect NULL foreign keys
     - Validate business key uniqueness

 NOTE:
     This script performs READ-ONLY validation.
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Validation 1. Source vs Fact Table Row Count
==============================================================================*/

SELECT
    (SELECT COUNT(*) FROM dbo.ecommerce_data) AS Source_Rows,
    (SELECT COUNT(*) FROM dbo.fact_orders) AS Fact_Rows;
GO


/*==============================================================================
Validation 2. Customer Dimension Row Count
==============================================================================*/

SELECT
    (SELECT COUNT(DISTINCT customer_id) FROM dbo.ecommerce_data) AS Source_Customers,
    (SELECT COUNT(*) FROM dbo.dim_customers) AS Dimension_Customers;
GO


/*==============================================================================
Validation 3. Product Dimension Row Count
==============================================================================*/

SELECT
    (SELECT COUNT(DISTINCT product_id) FROM dbo.ecommerce_data) AS Source_Products,
    (SELECT COUNT(*) FROM dbo.dim_products) AS Dimension_Products;
GO


/*==============================================================================
Validation 4. Seller Dimension Row Count
==============================================================================*/

SELECT
    (SELECT COUNT(DISTINCT seller_id) FROM dbo.ecommerce_data) AS Source_Sellers,
    (SELECT COUNT(*) FROM dbo.dim_sellers) AS Dimension_Sellers;
GO


/*==============================================================================
Validation 5. Payment Dimension Row Count
==============================================================================*/

SELECT
(
    SELECT COUNT(*)
    FROM
    (
        SELECT DISTINCT
            payment_type,
            payment_installments
        FROM dbo.ecommerce_data
    ) p
) AS Source_Payment_Records,

(SELECT COUNT(*) FROM dbo.dim_payments) AS Dimension_Payments;
GO


/*==============================================================================
Validation 6. Date Dimension Row Count
==============================================================================*/

SELECT
    (SELECT COUNT(*) FROM dbo.dim_date) AS Dimension_Dates;
GO


/*==============================================================================
Validation 7. NULL Foreign Keys in Fact Table
==============================================================================*/

SELECT

    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS Missing_Customer_Key,

    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END) AS Missing_Product_Key,

    SUM(CASE WHEN seller_key IS NULL THEN 1 ELSE 0 END) AS Missing_Seller_Key,

    SUM(CASE WHEN payment_key IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Key,

    SUM(CASE WHEN date_key IS NULL THEN 1 ELSE 0 END) AS Missing_Date_Key

FROM dbo.fact_orders;
GO


/*==============================================================================
Validation 8. Orphan Customer Keys
==============================================================================*/

SELECT *

FROM dbo.fact_orders f

LEFT JOIN dbo.dim_customers c
    ON f.customer_key = c.customer_key

WHERE c.customer_key IS NULL;
GO


/*==============================================================================
Validation 9. Orphan Product Keys
==============================================================================*/

SELECT *

FROM dbo.fact_orders f

LEFT JOIN dbo.dim_products p
    ON f.product_key = p.product_key

WHERE p.product_key IS NULL;
GO


/*==============================================================================
Validation 10. Orphan Seller Keys
==============================================================================*/

SELECT *

FROM dbo.fact_orders f

LEFT JOIN dbo.dim_sellers s
    ON f.seller_key = s.seller_key

WHERE s.seller_key IS NULL;
GO


/*==============================================================================
Validation 11. Orphan Payment Keys
==============================================================================*/

SELECT *

FROM dbo.fact_orders f

LEFT JOIN dbo.dim_payments p
    ON f.payment_key = p.payment_key

WHERE p.payment_key IS NULL;
GO


/*==============================================================================
Validation 12. Orphan Date Keys
==============================================================================*/

SELECT *

FROM dbo.fact_orders f

LEFT JOIN dbo.dim_date d
    ON f.date_key = d.date_key

WHERE d.date_key IS NULL;
GO


/*==============================================================================
Validation 13. Duplicate Customer IDs
==============================================================================*/

SELECT

    customer_id,

    COUNT(*) AS Duplicate_Count

FROM dbo.dim_customers

GROUP BY customer_id

HAVING COUNT(*) > 1;
GO


/*==============================================================================
Validation 14. Duplicate Product IDs
==============================================================================*/

SELECT

    product_id,

    COUNT(*) AS Duplicate_Count

FROM dbo.dim_products

GROUP BY product_id

HAVING COUNT(*) > 1;
GO


/*==============================================================================
Validation 15. Duplicate Seller IDs
==============================================================================*/

SELECT

    seller_id,

    COUNT(*) AS Duplicate_Count

FROM dbo.dim_sellers

GROUP BY seller_id

HAVING COUNT(*) > 1;
GO


/*==============================================================================
Validation 16. Duplicate Payment Records
==============================================================================*/

SELECT

    payment_type,
    payment_installments,

    COUNT(*) AS Duplicate_Count

FROM dbo.dim_payments

GROUP BY

    payment_type,
    payment_installments

HAVING COUNT(*) > 1;
GO


/*==============================================================================
Validation 17. Duplicate Date Records
==============================================================================*/

SELECT

    full_date,

    COUNT(*) AS Duplicate_Count

FROM dbo.dim_date

GROUP BY full_date

HAVING COUNT(*) > 1;
GO


/*==============================================================================
Validation 18. Duplicate Fact Records
==============================================================================*/

SELECT

    order_id,
    order_item_id,

    COUNT(*) AS Duplicate_Count

FROM dbo.fact_orders

GROUP BY

    order_id,
    order_item_id

HAVING COUNT(*) > 1;
GO


/*==============================================================================
Validation 19. Revenue Reconciliation
==============================================================================*/

SELECT

    (SELECT SUM(payment_value)
     FROM dbo.ecommerce_data) AS Source_Revenue,

    (SELECT SUM(payment_amount)
     FROM dbo.fact_orders) AS Fact_Revenue;
GO


/*==============================================================================
Validation 20. Freight Reconciliation
==============================================================================*/

SELECT

    (SELECT SUM(freight_value)
     FROM dbo.ecommerce_data) AS Source_Freight,

    (SELECT SUM(freight_cost)
     FROM dbo.fact_orders) AS Fact_Freight;
GO
