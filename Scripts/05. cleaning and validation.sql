/*
===============================================================================
 Script Name : 05. data cleaning and validation.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description :
    Cleans the production table based on issues identified during
    the data profiling phase.
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*==============================================================================
  STEP 1: Trim Leading and Trailing Spaces
==============================================================================*/

UPDATE dbo.ecommerce_data
SET
    customer_city = TRIM(customer_city),
    seller_city = TRIM(seller_city),
    product_category_name = TRIM(product_category_name),
    payment_type = TRIM(payment_type),
    order_status = TRIM(order_status);

PRINT 'Text trimming completed.';
GO


/*==============================================================================
  STEP 2: Standardize Text Values
==============================================================================*/

UPDATE dbo.ecommerce_data
SET
    customer_city = LOWER(customer_city),
    seller_city = LOWER(seller_city),
    product_category_name = LOWER(product_category_name),
    payment_type = LOWER(payment_type),
    order_status = LOWER(order_status);

PRINT 'Text standardization completed.';
GO


/*==============================================================================
  STEP 3: Regenerate Month-Year Column
  Excel converted the original values to serial numbers.
==============================================================================*/

UPDATE dbo.ecommerce_data
SET month_year_of_purchase =
    FORMAT(order_purchase_timestamp, 'yyyy-MM');

PRINT 'Month-Year column regenerated.';
GO


/*==============================================================================
  STEP 4: Remove Exact Duplicate Order Items

  Data profiling identified:
      • 3,169 duplicate business keys
      • 4,750 redundant duplicate rows

  Business Key:
      order_id + order_item_id

  One record is retained for each unique order item.
==============================================================================*/

WITH DuplicateRows AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY order_id, order_item_id
               ORDER BY order_unique_id
           ) AS rn
    FROM dbo.ecommerce_data
)

DELETE
FROM DuplicateRows
WHERE rn > 1;

PRINT 'Duplicate records removed.';
GO
