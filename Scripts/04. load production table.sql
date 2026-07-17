/*
===============================================================================
 Script Name : 04. load production table.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode
 Description : Loads data from the staging table into the
               production table.
===============================================================================
*/

USE ECommerceOperationsDB;
GO

--=============================================================================
-- Load Production Table
--=============================================================================

INSERT INTO dbo.ecommerce_data
(
    order_id,
    order_item_id,

    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,

    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,

    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix,

    payment_type,
    payment_sequential,
    payment_installments,
    price,
    freight_value,
    payment_value,

    shipping_limit_date,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    day_of_purchase,
    month_of_purchase,
    year_of_purchase,
    month_year_of_purchase,

    order_status,
    order_unique_id
)

SELECT

    ---------------------------------------------------------------------------
    -- Order Information
    ---------------------------------------------------------------------------

    order_id,
    TRY_CONVERT(INT, order_item_id),

    ---------------------------------------------------------------------------
    -- Customer Information
    ---------------------------------------------------------------------------

    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,

    ---------------------------------------------------------------------------
    -- Product Information
    ---------------------------------------------------------------------------

    product_id,
    product_category_name,
    TRY_CONVERT(INT, product_name_lenght),
    TRY_CONVERT(INT, product_description_lenght),
    TRY_CONVERT(INT, product_photos_qty),
    TRY_CONVERT(INT, product_weight_g),
    TRY_CONVERT(DECIMAL(10,2), product_length_cm),
    TRY_CONVERT(DECIMAL(10,2), product_height_cm),
    TRY_CONVERT(DECIMAL(10,2), product_width_cm),

    ---------------------------------------------------------------------------
    -- Seller Information
    ---------------------------------------------------------------------------

    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix,

    ---------------------------------------------------------------------------
    -- Payment Information
    ---------------------------------------------------------------------------

    payment_type,
    TRY_CONVERT(INT, payment_sequential),
    TRY_CONVERT(INT, payment_installments),
    TRY_CONVERT(DECIMAL(10,2), price),
    TRY_CONVERT(DECIMAL(10,2), freight_value),
    TRY_CONVERT(DECIMAL(10,2), payment_value),

    ---------------------------------------------------------------------------
    -- Order Dates
    ---------------------------------------------------------------------------

    TRY_CONVERT(DATETIME, shipping_limit_date),
    TRY_CONVERT(DATETIME, order_purchase_timestamp),
    TRY_CONVERT(DATETIME, order_approved_at),
    TRY_CONVERT(DATETIME, order_delivered_carrier_date),
    TRY_CONVERT(DATETIME, order_delivered_customer_date),
    TRY_CONVERT(DATETIME, order_estimated_delivery_date),

    ---------------------------------------------------------------------------
    -- Date Helper Columns
    ---------------------------------------------------------------------------

    day_of_purchase,
    month_of_purchase,
    TRY_CONVERT(INT, year_of_purchase),
    [month/year_of_purchase],

    ---------------------------------------------------------------------------
    -- Order Status
    ---------------------------------------------------------------------------

    order_status,
    order_unique_id

FROM dbo.stg_ecommerce_data;
GO

--=============================================================================
-- Verify Data Load
--=============================================================================

SELECT COUNT(*) AS Total_Records
FROM dbo.ecommerce_data;
GO

--=============================================================================
-- Preview Loaded Data
--=============================================================================

SELECT TOP (10) *
FROM dbo.ecommerce_data;
GO
