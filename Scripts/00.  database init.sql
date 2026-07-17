/*
===============================================================================
 Script Name : 00. database init.sql
 Project     : E-Commerce Operations Intelligence Dashboard
 Author      : Godwin Deborah Onoriode
 Description : Creates the project database and sets it as the active database.
===============================================================================
*/

--=============================================================================
-- Drop database if it already exists (Development Only)
--=============================================================================

IF DB_ID('ECommerceOperationsDB') IS NOT NULL
BEGIN
    ALTER DATABASE ECommerceOperationsDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ECommerceOperationsDB;
END;
GO

--=============================================================================
-- Create Database
--=============================================================================

CREATE DATABASE ECommerceOperationsDB;
GO

--=============================================================================
-- Use Database
--=============================================================================

USE ECommerceOperationsDB;
GO

--=============================================================================
-- Verify Database
--=============================================================================

SELECT
    DB_NAME() AS Current_Database;
GO
