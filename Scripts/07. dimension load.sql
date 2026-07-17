/*
===============================================================================
 Script Name : 07. dimension load.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode

 Description:
    Loads the dimension tables from the cleaned production table.
===============================================================================
*/


USE ECommerceOperationsDB;
GO

SET NOCOUNT ON;

------------------------------------------------------------
-- Load Date Dimension
------------------------------------------------------------

DECLARE @StartDate DATE;
DECLARE @EndDate DATE;

SELECT
    @StartDate = MIN(CAST(order_purchase_timestamp AS DATE)),
    @EndDate   = MAX(order_estimated_delivery_date)
FROM dbo.ecommerce_data;

;WITH Calendar AS
(
    SELECT @StartDate AS calendar_date

    UNION ALL

    SELECT DATEADD(DAY,1,calendar_date)
    FROM Calendar
    WHERE calendar_date < @EndDate
)

INSERT INTO dbo.dim_date
(
    full_date,
    day_number,
    day_name,
    month_number,
    month_name,
    quarter_number,
    year_number,
    month_year
)

SELECT

    calendar_date,
    DAY(calendar_date),
    DATENAME(WEEKDAY,calendar_date),
    MONTH(calendar_date),
    DATENAME(MONTH,calendar_date),
    DATEPART(QUARTER,calendar_date),
    YEAR(calendar_date),
    FORMAT(calendar_date,'yyyy-MM')

FROM Calendar

OPTION (MAXRECURSION 1000);

PRINT 'dim_date loaded successfully.';

------------------------------------------------------------
-- Load Customer Dimension
------------------------------------------------------------

INSERT INTO dbo.dim_customers
(
    customer_id,
    customer_unique_id,
    customer_zip_code,
    customer_city,
    customer_state
)

SELECT DISTINCT

    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state

FROM dbo.ecommerce_data;

PRINT 'dim_customers loaded successfully.';

------------------------------------------------------------
-- Load Product Dimension
------------------------------------------------------------

INSERT INTO dbo.dim_products
(
    product_id,
    product_category,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)

SELECT DISTINCT

    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

FROM dbo.ecommerce_data;

PRINT 'dim_products loaded successfully.';

------------------------------------------------------------
-- Load Seller Dimension
------------------------------------------------------------

INSERT INTO dbo.dim_sellers
(
    seller_id,
    seller_zip_code,
    seller_city,
    seller_state
)

SELECT DISTINCT

    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state

FROM dbo.ecommerce_data;

PRINT 'dim_sellers loaded successfully.';

------------------------------------------------------------
-- Load Payment Dimension
------------------------------------------------------------

INSERT INTO dbo.dim_payments
(
    payment_type,
    payment_installments
)

SELECT DISTINCT

    payment_type,
    payment_installments

FROM dbo.ecommerce_data;

PRINT 'dim_payments loaded successfully.';

------------------------------------------------------------
-- Load Summary
------------------------------------------------------------

PRINT '========================================';
PRINT 'Dimension Tables Loaded Successfully';
PRINT '========================================';

SELECT
    'dim_date' AS table_name,
    COUNT(*) AS record_count
FROM dbo.dim_date

UNION ALL

SELECT
    'dim_customers',
    COUNT(*)
FROM dbo.dim_customers

UNION ALL

SELECT
    'dim_products',
    COUNT(*)
FROM dbo.dim_products

UNION ALL

SELECT
    'dim_sellers',
    COUNT(*)
FROM dbo.dim_sellers

UNION ALL

SELECT
    'dim_payments',
    COUNT(*)
FROM dbo.dim_payments;
GO
