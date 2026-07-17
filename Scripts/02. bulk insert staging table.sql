/*
===============================================================================
 Script Name : 02. Bulk Insert Staging Table.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode
 Description : Loads the CSV dataset into the staging table using SQL Server's BULK INSERT command. 
===============================================================================
*/

USE ECommerceOperationsDB;
GO

/*
===============================================================================
 Bulk Load the Dataset into Staging Table
===============================================================================
*/

BULK INSERT dbo.stg_ecommerce_data
FROM 'C:\ add your file path'
WITH
(
    FORMAT = 'CSV',                     -- Specifies CSV file format
    FIRSTROW = 2,                       -- Skip the header row
    CODEPAGE = '65001',                 -- UTF-8 encoding
    KEEPNULLS,                          -- Preserve NULL values from the source file
    TABLOCK,                            -- Acquire a table-level lock for faster loading
    MAXERRORS = 100,                    -- Stop import if more than 100 errors occur
    ERRORFILE = 'C:\ add your file path'
                                        -- Stores rows that fail during import
);
GO

/*
===============================================================================
 Verify Successful Load
===============================================================================
*/

SELECT COUNT(*) AS Total_Records
FROM dbo.stg_ecommerce_data;
GO
