-- ============================================
-- EXPLORATORY DATA ANALYSIS (EDA)
-- ============================================

-- Total records
SELECT COUNT(*) AS total_products FROM zepto;

-- Unique categories
SELECT DISTINCT category FROM zepto;

-- Stock availability distribution
SELECT 
    CASE 
        WHEN outOfStock = 0 THEN 'In Stock'
        ELSE 'Out of Stock'
    END AS stock_status,
    COUNT(*) AS product_count
FROM zepto
GROUP BY outOfStock;

-- Duplicate product check
SELECT name, COUNT(*) AS count
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1;

-- Price range analysis
SELECT 
    MIN(discountedSellingPrice) AS min_price,
    MAX(discountedSellingPrice) AS max_price,
    AVG(discountedSellingPrice) AS avg_price
FROM zepto;

-- Discount analysis
SELECT 
    MIN(discountPercent) AS min_discount,
    MAX(discountPercent) AS max_discount,
    AVG(discountPercent) AS avg_discount
FROM zepto;

-- Weight segmentation
SELECT 
    CASE 
        WHEN weightInGms < 500 THEN 'Low Weight'
        WHEN weightInGms BETWEEN 500 AND 2000 THEN 'Medium Weight'
        ELSE 'High Weight'
    END AS weight_category,
    COUNT(*) AS product_count
FROM zepto
GROUP BY 
    CASE 
        WHEN weightInGms < 500 THEN 'Low Weight'
        WHEN weightInGms BETWEEN 500 AND 2000 THEN 'Medium Weight'
        ELSE 'High Weight'
    END;

-- Total inventory weight
SELECT 
    SUM(weightInGms * availableQuantity) AS total_inventory_weight
FROM zepto;

-- Price per gram analysis
SELECT 
    name,
    discountedSellingPrice / weightInGms AS price_per_gram
FROM zepto
WHERE weightInGms > 0;
