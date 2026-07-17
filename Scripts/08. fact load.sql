/*
===============================================================================
 Script Name : 08. fact load.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
    Loads the fact table by mapping business keys from the production table
    to surrogate keys in the dimension tables.
===============================================================================
*/

USE ECommerceOperationsDB;
GO

SET NOCOUNT ON;

------------------------------------------------------------
-- Load Fact Table
------------------------------------------------------------

INSERT INTO dbo.fact_orders
(
    order_id,
    order_item_id,
    order_unique_id,

    date_key,
    customer_key,
    product_key,
    seller_key,
    payment_key,

    price,
    freight_cost,
    payment_amount,

    purchase_timestamp,
    approval_timestamp,
    carrier_dispatch_timestamp,
    delivery_timestamp,
    estimated_delivery_date,

    order_status
)

SELECT

    e.order_id,

    e.order_item_id,

    e.order_unique_id,

    d.date_key,

    c.customer_key,

    p.product_key,

    s.seller_key,

    pay.payment_key,

    e.price,

    e.freight_value,

    e.payment_value,

    e.order_purchase_timestamp,

    e.order_approved_at,

    e.order_delivered_carrier_date,

    e.order_delivered_customer_date,

    e.order_estimated_delivery_date,

    e.order_status

FROM dbo.ecommerce_data AS e

------------------------------------------------------------
-- Date Dimension
------------------------------------------------------------

INNER JOIN dbo.dim_date AS d
ON CAST(e.order_purchase_timestamp AS DATE) = d.full_date

------------------------------------------------------------
-- Customer Dimension
------------------------------------------------------------

INNER JOIN dbo.dim_customers AS c
ON e.customer_id = c.customer_id

------------------------------------------------------------
-- Product Dimension
------------------------------------------------------------

INNER JOIN dbo.dim_products AS p
ON  e.product_id = p.product_id
AND e.product_category_name = p.product_category
AND e.product_weight_g = p.product_weight_g
AND e.product_length_cm = p.product_length_cm
AND e.product_height_cm = p.product_height_cm
AND e.product_width_cm = p.product_width_cm

------------------------------------------------------------
-- Seller Dimension
------------------------------------------------------------

INNER JOIN dbo.dim_sellers AS s
ON  e.seller_id = s.seller_id
AND e.seller_zip_code_prefix = s.seller_zip_code
AND e.seller_city = s.seller_city
AND e.seller_state = s.seller_state

------------------------------------------------------------
-- Payment Dimension
------------------------------------------------------------

INNER JOIN dbo.dim_payments AS pay
ON  e.payment_type = pay.payment_type
AND e.payment_installments = pay.payment_installments;

PRINT 'fact_orders loaded successfully.';
GO

------------------------------------------------------------
-- Load Summary
------------------------------------------------------------

SELECT
    COUNT(*) AS Fact_Record_Count
FROM dbo.fact_orders;
GO
