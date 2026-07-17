/*
===============================================================================
 Script Name : 01. Data Profiling.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Profiles the production dataset to understand its structure,
     completeness, uniqueness and data distribution before analysis.

 Objectives:
     - Determine dataset size
     - Identify duplicate records
     - Assess completeness
     - Examine numeric ranges
     - Validate date ranges
     - Understand categorical distributions

 NOTE:
     This script performs READ-ONLY profiling.
     No data is modified.
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Profile 1. Total Records
==============================================================================*/

SELECT
    COUNT(*) AS Total_Records
FROM dbo.ecommerce_data;
GO


/*==============================================================================
Profile 2. Duplicate Order Unique IDs
==============================================================================*/

SELECT

    order_unique_id,

    COUNT(*) AS Duplicate_Count

FROM dbo.ecommerce_data

GROUP BY
    order_unique_id

HAVING COUNT(*) > 1

ORDER BY Duplicate_Count DESC;
GO


/*==============================================================================
Profile 3. Duplicate Order + Order Item Combination
==============================================================================*/

SELECT

    order_id,
    order_item_id,

    COUNT(*) AS Duplicate_Count

FROM dbo.ecommerce_data

GROUP BY

    order_id,
    order_item_id

HAVING COUNT(*) > 1

ORDER BY Duplicate_Count DESC;
GO


/*==============================================================================
Profile 4. Column Completeness
==============================================================================*/

SELECT

    COUNT(*) AS Total_Rows,

    COUNT(order_id) AS order_id,
    COUNT(customer_id) AS customer_id,
    COUNT(product_id) AS product_id,
    COUNT(seller_id) AS seller_id,

    COUNT(order_purchase_timestamp) AS purchase_timestamp,
    COUNT(order_approved_at) AS approved_timestamp,
    COUNT(order_delivered_carrier_date) AS carrier_timestamp,
    COUNT(order_delivered_customer_date) AS delivered_timestamp,
    COUNT(order_estimated_delivery_date) AS estimated_delivery,

    COUNT(payment_type) AS payment_type,
    COUNT(payment_value) AS payment_value,

    COUNT(product_category) AS product_category

FROM dbo.ecommerce_data;
GO

/*==============================================================================
Profile 5. Missing Values
==============================================================================*/

SELECT

    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS Missing_Order_Approval,

    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS Missing_Carrier_Date,

    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS Missing_Delivery_Date,

    SUM(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END) AS Missing_Product_Category,

    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Type

FROM dbo.ecommerce_data;
GO


/*==============================================================================
Profile 6. Numeric Ranges
==============================================================================*/

SELECT

    MIN(price) AS Minimum_Price,
    MAX(price) AS Maximum_Price,

    MIN(payment_value) AS Minimum_Payment,
    MAX(payment_value) AS Maximum_Payment,

    MIN(freight_value) AS Minimum_Freight,
    MAX(freight_value) AS Maximum_Freight,

    MIN(product_weight_g) AS Minimum_Weight,
    MAX(product_weight_g) AS Maximum_Weight

FROM dbo.ecommerce_data;
GO


/*==============================================================================
Profile 7. Product Dimension Ranges
==============================================================================*/

SELECT

    MIN(product_length_cm) AS Minimum_Length,
    MAX(product_length_cm) AS Maximum_Length,

    MIN(product_height_cm) AS Minimum_Height,
    MAX(product_height_cm) AS Maximum_Height,

    MIN(product_width_cm) AS Minimum_Width,
    MAX(product_width_cm) AS Maximum_Width

FROM dbo.ecommerce_data;
GO


/*==============================================================================
Profile 8. Date Ranges
==============================================================================*/

SELECT

    MIN(order_purchase_timestamp) AS First_Order,
    MAX(order_purchase_timestamp) AS Last_Order,

    MIN(order_estimated_delivery_date) AS Earliest_Estimated_Delivery,
    MAX(order_estimated_delivery_date) AS Latest_Estimated_Delivery

FROM dbo.ecommerce_data;
GO


/*==============================================================================
Profile 9. Order Status Distribution
==============================================================================*/

SELECT

    order_status,

    COUNT(*) AS Total_Orders

FROM dbo.ecommerce_data

GROUP BY
    order_status

ORDER BY
    Total_Orders DESC;
GO


/*==============================================================================
Profile 10. Payment Type Distribution
==============================================================================*/

SELECT

    payment_type,

    COUNT(*) AS Total_Transactions

FROM dbo.ecommerce_data

GROUP BY
    payment_type

ORDER BY
    Total_Transactions DESC;
GO


/*==============================================================================
Profile 11. Product Category Distribution
==============================================================================*/

SELECT

    product_category,

    COUNT(*) AS Total_Products

FROM dbo.ecommerce_data

GROUP BY
    product_category

ORDER BY
    Total_Products DESC;
GO


/*==============================================================================
Profile 12. Customer State Distribution
==============================================================================*/

SELECT

    customer_state,

    COUNT(*) AS Total_Customers

FROM dbo.ecommerce_data

GROUP BY
    customer_state

ORDER BY
    Total_Customers DESC;
GO


/*==============================================================================
Profile 13. Seller State Distribution
==============================================================================*/

SELECT

    seller_state,

    COUNT(*) AS Total_Sellers

FROM dbo.ecommerce_data

GROUP BY
    seller_state

ORDER BY
    Total_Sellers DESC;
GO
