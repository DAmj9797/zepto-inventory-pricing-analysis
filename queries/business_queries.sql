-- ============================================
-- BUSINESS INSIGHTS & STRATEGY QUERIES
-- ============================================


-- Q1. Find the top 10 best-value products based on the discount percentage
SELECT TOP 10
    name,
    mrp,
    discountPercent
FROM zepto
WHERE discountPercent IS NOT NULL
  AND discountPercent > 0
ORDER BY discountPercent DESC;


--Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT
    name,
    mrp
FROM zepto
WHERE outOfStock = 1
  AND mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT 
    category,
    SUM(discountedSellingPrice * availableQuantity) AS total_estimated_revenue
FROM zepto
WHERE discountedSellingPrice IS NOT NULL
  AND availableQuantity IS NOT NULL
GROUP BY category
ORDER BY total_estimated_revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%
SELECT DISTINCT
    name,
    mrp,
    discountPercent
FROM zepto
WHERE mrp > 500
  AND discountPercent IS NOT NULL
  AND discountPercent < 10
ORDER BY mrp DESC, discountPercent ASC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage
SELECT TOP 5
    category,
    ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
WHERE discountPercent IS NOT NULL
GROUP BY category
ORDER BY avg_discount DESC;

-- Q6. Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT
    name,
    weightInGms,
    discountedSellingPrice,
    ROUND(discountedSellingPrice * 1.0 / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC;

--Q7.Group the products into categories like Low, Medium, Bulk
SELECT 
    weight_category,
    COUNT(*) AS product_count
FROM (
    SELECT 
        CASE 
            WHEN weightInGms < 1000 THEN 'Low'
            WHEN weightInGms < 5000 THEN 'Medium'
            ELSE 'Bulk'
        END AS weight_category
    FROM dbo.zepto
    WHERE weightInGms IS NOT NULL
) t
GROUP BY weight_category
ORDER BY product_count DESC;

--Q8.What is the Total Inventory Weight Per Category 
SELECT 
    category,
    SUM(weightInGms * availableQuantity) AS total_inventory_weight
FROM zepto
WHERE weightInGms IS NOT NULL
  AND availableQuantity IS NOT NULL
GROUP BY category
ORDER BY total_inventory_weight DESC;

--Q9.Low Stock Alert
SELECT 
    name,
    category,
    availableQuantity
FROM zepto
WHERE availableQuantity < 10
  AND outOfStock = 0;

  --Q10. Dead Inventory
  SELECT 
    name,
    category,
    availableQuantity,
    discountPercent
FROM zepto
WHERE availableQuantity > 100
  AND discountPercent < 5;

--Q11. Top 3 Products per Category
WITH ranked AS (
    SELECT 
        category,
        name,
        discountedSellingPrice,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY discountedSellingPrice DESC
        ) AS rn
    FROM zepto
)
SELECT *
FROM ranked
WHERE rn <= 3;


-- Q13. Revenue loss due to out-of-stock items
SELECT 
    category,
    SUM(mrp * quantity) AS potential_revenue_loss
FROM dbo.zepto
WHERE outOfStock = 1
GROUP BY category
ORDER BY potential_revenue_loss DESC;

-- Q14. Top 10 revenue-generating products
SELECT TOP 10
    name,
    category,
    discountedSellingPrice,
    availableQuantity,
    (discountedSellingPrice * availableQuantity) AS total_revenue
FROM dbo.zepto
ORDER BY total_revenue DESC;


-- Q15. Calculate discount amount per product
SELECT 
    name,
    mrp,
    discountedSellingPrice,
    (mrp - discountedSellingPrice) AS discount_value
FROM dbo.zepto
ORDER BY discount_value DESC;
