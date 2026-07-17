/*
===============================================================================
 Script Name : 06. schema creation.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
    Creates the dimensional model (Star Schema) for reporting.
===============================================================================
*/

USE ECommerceOperationsDB;
GO

------------------------------------------------------------
-- Drop Fact Table
------------------------------------------------------------

IF OBJECT_ID('dbo.fact_orders', 'U') IS NOT NULL
    DROP TABLE dbo.fact_orders;
GO

------------------------------------------------------------
-- Drop Dimension Tables
------------------------------------------------------------

IF OBJECT_ID('dbo.dim_payments', 'U') IS NOT NULL
    DROP TABLE dbo.dim_payments;
GO

IF OBJECT_ID('dbo.dim_sellers', 'U') IS NOT NULL
    DROP TABLE dbo.dim_sellers;
GO

IF OBJECT_ID('dbo.dim_products', 'U') IS NOT NULL
    DROP TABLE dbo.dim_products;
GO

IF OBJECT_ID('dbo.dim_customers', 'U') IS NOT NULL
    DROP TABLE dbo.dim_customers;
GO

IF OBJECT_ID('dbo.dim_date', 'U') IS NOT NULL
    DROP TABLE dbo.dim_date;
GO

/******************************************************************************
    Date Dimension
******************************************************************************/

CREATE TABLE dbo.dim_date
(
    date_key INT IDENTITY(1,1) PRIMARY KEY,

    full_date DATE NOT NULL,

    day_number INT NOT NULL,

    day_name VARCHAR(20) NOT NULL,

    month_number INT NOT NULL,

    month_name VARCHAR(20) NOT NULL,

    quarter_number INT NOT NULL,

    year_number INT NOT NULL,

    month_year CHAR(7) NOT NULL
);
GO

/******************************************************************************
    Customer Dimension
******************************************************************************/

CREATE TABLE dbo.dim_customers
(
    customer_key INT IDENTITY(1,1) PRIMARY KEY,

    customer_id VARCHAR(50) NOT NULL,

    customer_unique_id VARCHAR(50) NOT NULL,

    customer_zip_code INT NOT NULL,

    customer_city VARCHAR(100) NOT NULL,

    customer_state CHAR(2) NOT NULL
);
GO

/******************************************************************************
    Product Dimension
******************************************************************************/

CREATE TABLE dbo.dim_products
(
    product_key INT IDENTITY(1,1) PRIMARY KEY,

    product_id VARCHAR(50) NOT NULL,

    product_category VARCHAR(100) NOT NULL,

    product_weight_g DECIMAL(10,2) NOT NULL,

    product_length_cm DECIMAL(10,2) NOT NULL,

    product_height_cm DECIMAL(10,2) NOT NULL,

    product_width_cm DECIMAL(10,2) NOT NULL
);
GO

/******************************************************************************
    Seller Dimension
******************************************************************************/

CREATE TABLE dbo.dim_sellers
(
    seller_key INT IDENTITY(1,1) PRIMARY KEY,

    seller_id VARCHAR(50) NOT NULL,

    seller_zip_code INT NOT NULL,

    seller_city VARCHAR(100) NOT NULL,

    seller_state CHAR(2) NOT NULL
);
GO

/******************************************************************************
    Payment Dimension
******************************************************************************/

CREATE TABLE dbo.dim_payments
(
    payment_key INT IDENTITY(1,1) PRIMARY KEY,

    payment_type VARCHAR(30) NOT NULL,

    payment_installments INT NOT NULL
);
GO

/******************************************************************************
    Fact Table
******************************************************************************/

CREATE TABLE dbo.fact_orders
(
    order_id VARCHAR(50) NOT NULL,

    order_item_id INT NOT NULL,

    order_unique_id VARCHAR(60) NOT NULL,

    date_key INT NOT NULL,

    customer_key INT NOT NULL,

    product_key INT NOT NULL,

    seller_key INT NOT NULL,

    payment_key INT NOT NULL,

    price DECIMAL(10,2) NOT NULL,

    freight_cost DECIMAL(10,2) NOT NULL,

    payment_amount DECIMAL(10,2) NOT NULL,

    purchase_timestamp DATETIME NOT NULL,

    approval_timestamp DATETIME NULL,

    carrier_dispatch_timestamp DATETIME NULL,

    delivery_timestamp DATETIME NULL,

    estimated_delivery_date DATE NULL,

    order_status VARCHAR(20) NOT NULL,

    CONSTRAINT FK_fact_orders_date
        FOREIGN KEY (date_key)
        REFERENCES dbo.dim_date(date_key),

    CONSTRAINT FK_fact_orders_customer
        FOREIGN KEY (customer_key)
        REFERENCES dbo.dim_customers(customer_key),

    CONSTRAINT FK_fact_orders_product
        FOREIGN KEY (product_key)
        REFERENCES dbo.dim_products(product_key),

    CONSTRAINT FK_fact_orders_seller
        FOREIGN KEY (seller_key)
        REFERENCES dbo.dim_sellers(seller_key),

    CONSTRAINT FK_fact_orders_payment
        FOREIGN KEY (payment_key)
        REFERENCES dbo.dim_payments(payment_key)
);
GO

PRINT 'Warehouse schema created successfully.';
