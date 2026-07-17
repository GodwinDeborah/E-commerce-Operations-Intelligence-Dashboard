/*
===============================================================================
 Script Name : 02. Data Quality Checks.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
     Validates the quality of the cleaned production dataset before
     loading the star schema.

 Objectives:
     - Verify record counts
     - Detect duplicate business keys
     - Check for missing values
     - Validate numeric values
     - Validate date logic
     - Validate categorical fields

 NOTE:
     This script performs READ-ONLY validation.
     No data is modified.
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
Check 1. Total Records
==============================================================================*/

SELECT
    COUNT(*) AS Total_Records
FROM dbo.ecommerce_data;
GO


/*==============================================================================
Check 2. Duplicate Business Keys
==============================================================================*/

SELECT

    order_unique_id,

    COUNT(*) AS Duplicate_Count

FROM dbo.ecommerce_data

GROUP BY
    order_unique_id

HAVING COUNT(*) > 1;
GO


/*==============================================================================
Check 3. Duplicate Composite Business Key
==============================================================================*/

SELECT

    order_id,
    order_item_id,

    COUNT(*) AS Duplicate_Count

FROM dbo.ecommerce_data

GROUP BY

    order_id,
    order_item_id

HAVING COUNT(*) > 1;
GO


/*==============================================================================
Check 4. Missing Critical Keys
==============================================================================*/

SELECT

    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS Missing_Customer,

    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS Missing_Seller,

    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS Missing_Product,

    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS Missing_Order

FROM dbo.ecommerce_data;
GO


/*==============================================================================
Check 5. Missing Payment Information
==============================================================================*/

SELECT

    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Type,

    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS Missing_Installments,

    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Value

FROM dbo.ecommerce_data;
GO


/*==============================================================================
Check 6. Missing Date Values
==============================================================================*/

SELECT

    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS Missing_Purchase_Date,

    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS Missing_Estimated_Date

FROM dbo.ecommerce_data;
GO


/*==============================================================================
Check 7. Invalid Prices
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE price < 0;
GO


/*==============================================================================
Check 8. Invalid Freight Charges
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE freight_value < 0;
GO


/*==============================================================================
Check 9. Invalid Payment Values
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE payment_value < 0;
GO


/*==============================================================================
Check 10. Invalid Product Weight
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE product_weight_g <= 0;
GO


/*==============================================================================
Check 11. Invalid Product Dimensions
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE

    product_length_cm <= 0

    OR product_width_cm <= 0

    OR product_height_cm <= 0;
GO


/*==============================================================================
Check 12. Delivery Before Purchase
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE order_delivered_customer_date < order_purchase_timestamp;
GO


/*==============================================================================
Check 13. Approval Before Purchase
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE order_approved_at < order_purchase_timestamp;
GO


/*==============================================================================
Check 14. Carrier Pickup Before Approval
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE order_delivered_carrier_date < order_approved_at;
GO


/*==============================================================================
Check 15. Estimated Delivery Before Purchase
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE order_estimated_delivery_date < order_purchase_timestamp;
GO


/*==============================================================================
Check 16. Blank Text Values
==============================================================================*/

SELECT *

FROM dbo.ecommerce_data

WHERE

    TRIM(customer_city) = ''

    OR TRIM(seller_city) = ''

    OR TRIM(product_category) = ''

    OR TRIM(payment_type) = ''

    OR TRIM(order_status) = '';
GO


/*==============================================================================
Check 17. Invalid Customer State Codes
==============================================================================*/

SELECT DISTINCT
    customer_state

FROM dbo.ecommerce_data

WHERE LEN(customer_state) <> 2;
GO


/*==============================================================================
Check 18. Invalid Seller State Codes
==============================================================================*/

SELECT DISTINCT
    seller_state

FROM dbo.ecommerce_data

WHERE LEN(seller_state) <> 2;
GO


/*==============================================================================
Check 19. Distinct Order Status Values
==============================================================================*/

SELECT DISTINCT
    order_status

FROM dbo.ecommerce_data

ORDER BY order_status;
GO


/*==============================================================================
Check 20. Distinct Payment Types
==============================================================================*/

SELECT DISTINCT
    payment_type

FROM dbo.ecommerce_data

ORDER BY payment_type;
GO
