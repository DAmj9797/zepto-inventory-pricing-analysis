-- ============================================
-- DATA CLEANING & PREPARATION
-- ============================================

-- Drop existing table if exists
IF OBJECT_ID('zepto', 'U') IS NOT NULL
    DROP TABLE zepto;

-- Create clean table
CREATE TABLE zepto (
    sku_id INT,
    name VARCHAR(255),
    category VARCHAR(100),
    mrp FLOAT,
    discountedSellingPrice FLOAT,
    discountPercent FLOAT,
    availableQuantity INT,
    weightInGms INT,
    outOfStock BIT
);

-- Insert data from raw table
INSERT INTO zepto
SELECT * FROM zepto_v2;

-- ============================================
-- DATA QUALITY CHECKS
-- ============================================

-- Check for NULL values
SELECT *
FROM zepto
WHERE name IS NULL 
   OR category IS NULL 
   OR mrp IS NULL 
   OR discountedSellingPrice IS NULL;

-- Check invalid pricing
SELECT *
FROM zepto
WHERE mrp <= 0 OR discountedSellingPrice <= 0;

-- ============================================
-- DATA CLEANING
-- ============================================

-- Remove NULL critical rows
DELETE FROM zepto
WHERE name IS NULL OR category IS NULL;

-- Remove invalid pricing rows
DELETE FROM zepto
WHERE mrp <= 0 OR discountedSellingPrice <= 0;

-- Convert paise to rupees
UPDATE zepto
SET 
    mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- Remove duplicates (based on product name)
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY name ORDER BY sku_id) AS rn
    FROM zepto
)
DELETE FROM cte WHERE rn > 1;

-- Final cleaned dataset preview
SELECT TOP 20 * FROM zepto;