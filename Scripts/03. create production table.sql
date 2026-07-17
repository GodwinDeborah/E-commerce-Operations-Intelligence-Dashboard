/*
===============================================================================
 Script Name : 03. create production table.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode
 Description : Creates the production table using appropriate SQL data types.
===============================================================================
*/

USE ECommerceOperationsDB;
GO

--=============================================================================
-- Drop Production Table
--=============================================================================

IF OBJECT_ID('dbo.ecommerce_data', 'U') IS NOT NULL
    DROP TABLE dbo.ecommerce_data;
GO

--=============================================================================
-- Create Production Table
--=============================================================================

CREATE TABLE dbo.ecommerce_data
(
    ---------------------------------------------------------------------------
    -- Order Information
    ---------------------------------------------------------------------------

    order_id                          VARCHAR(50),
    order_item_id                     INT,

    ---------------------------------------------------------------------------
    -- Customer Information
    ---------------------------------------------------------------------------

    customer_id                       VARCHAR(50),
    customer_unique_id                VARCHAR(50),
    customer_zip_code_prefix          VARCHAR(10),
    customer_city                     VARCHAR(100),
    customer_state                    CHAR(2),

    ---------------------------------------------------------------------------
    -- Product Information
    ---------------------------------------------------------------------------

    product_id                        VARCHAR(50),
    product_category_name             VARCHAR(100),
    product_name_lenght               INT,
    product_description_lenght        INT,
    product_photos_qty                INT,
    product_weight_g                  INT,
    product_length_cm                 DECIMAL(10,2),
    product_height_cm                 DECIMAL(10,2),
    product_width_cm                  DECIMAL(10,2),

    ---------------------------------------------------------------------------
    -- Seller Information
    ---------------------------------------------------------------------------

    seller_id                         VARCHAR(50),
    seller_city                       VARCHAR(100),
    seller_state                      CHAR(2),
    seller_zip_code_prefix            VARCHAR(10),

    ---------------------------------------------------------------------------
    -- Payment Information
    ---------------------------------------------------------------------------

    payment_type                      VARCHAR(30),
    payment_sequential                INT,
    payment_installments              INT,
    price                             DECIMAL(10,2),
    freight_value                     DECIMAL(10,2),
    payment_value                     DECIMAL(10,2),

    ---------------------------------------------------------------------------
    -- Order Dates
    ---------------------------------------------------------------------------

    shipping_limit_date               DATETIME,
    order_purchase_timestamp          DATETIME,
    order_approved_at                 DATETIME,
    order_delivered_carrier_date      DATETIME,
    order_delivered_customer_date     DATETIME,
    order_estimated_delivery_date     DATETIME,

    ---------------------------------------------------------------------------
    -- Date Helper Columns
    ---------------------------------------------------------------------------

    day_of_purchase                   VARCHAR(20),
    month_of_purchase                 VARCHAR(20),
    year_of_purchase                  INT,
    month_year_of_purchase            VARCHAR(20),

    ---------------------------------------------------------------------------
    -- Order Status
    ---------------------------------------------------------------------------

    order_status                      VARCHAR(20),
    order_unique_id                   VARCHAR(50)
);
GO

--=============================================================================
-- Verify Table Creation
--=============================================================================

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'ecommerce_data';
GO
