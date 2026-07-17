/*
===============================================================================
 Script Name : 01. create staging table.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode
 Description : Creates the staging table used to load the cleaned CSV dataset.
               All columns are stored as VARCHAR to prevent data type errors
               during import.
===============================================================================
*/

--=============================================================================
-- Drop staging table if it already exists
--=============================================================================

IF OBJECT_ID('dbo.stg_ecommerce_data', 'U') IS NOT NULL
    DROP TABLE dbo.stg_ecommerce_data;
GO

--=============================================================================
-- Create Staging Table
--===========================================================================

CREATE TABLE dbo.stg_ecommerce_data
(
    order_id                          VARCHAR(100),
    order_item_id                     VARCHAR(20),

    customer_id                       VARCHAR(100),
    customer_unique_id                VARCHAR(100),
    customer_zip_code_prefix          VARCHAR(20),
    customer_city                     VARCHAR(100),
    customer_state                    VARCHAR(10),

    product_id                        VARCHAR(100),
    product_category_name             VARCHAR(100),
    product_name_lenght               VARCHAR(20),
    product_description_lenght        VARCHAR(20),
    product_photos_qty                VARCHAR(20),
    product_weight_g                  VARCHAR(20),
    product_length_cm                 VARCHAR(20),
    product_height_cm                 VARCHAR(20),
    product_width_cm                  VARCHAR(20),

    seller_id                         VARCHAR(100),
    seller_city                       VARCHAR(100),
    seller_state                      VARCHAR(10),
    seller_zip_code_prefix            VARCHAR(20),

    payment_type                      VARCHAR(50),
    payment_sequential                VARCHAR(20),
    payment_installments              VARCHAR(20),

    price                             VARCHAR(20),
    freight_value                     VARCHAR(20),
    payment_value                     VARCHAR(20),

    shipping_limit_date               VARCHAR(50),
    order_purchase_timestamp          VARCHAR(50),
    order_approved_at                 VARCHAR(50),
    order_delivered_carrier_date      VARCHAR(50),
    order_delivered_customer_date     VARCHAR(50),
    order_estimated_delivery_date     VARCHAR(50),

    day_of_purchase                   VARCHAR(20),
    month_of_purchase                 VARCHAR(20),
    year_of_purchase                  VARCHAR(10),
    [month/year_of_purchase]          VARCHAR(20),

    order_status                      VARCHAR(50),
    order_unique_id                   VARCHAR(100)
);
GO
