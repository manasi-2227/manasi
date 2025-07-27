drop table if exists zepto;

create table zepto(
sku_id serial PRIMARY  KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC (8,2),
discountpercent Numeric(5,2),
availablequantity INTEGER,
discountedsellingprice NUMERIC(8,2),
Weightingrams INTEGER,
outofstock BOOLEAN,
quantity INTEGER
);

--data exploration--

--count of rows--
SELECT COUNT(*) FROM zepto

--sample data--
SELECT *FROM ZEPTO
LIMIT 10;

--NULL VALUES--
SELECT * FROM ZEPTO
WHERE 
name IS NULL 
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingPrice IS NULL
OR
weightingrams IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category 
FROM zepto
ORDER BY category;

--products inn stock vs out of stock--

SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

--product names present multiple times--
SELECT name, COUNT(sku_id) as "number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning--

--product with price = 0--
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

--deleting row--
DELETE FROM zepto
WHERE mrp = 0;

--connvert paise to rupee--

UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;


SELECT mrp, discountedsellingprice FROM zepto

--top 10 best value product based on discount percentage--
SELECT DISTINCT name, mrp, discountpercent 
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--what are the products with high mrp but out of stock--

SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = true  and mrp >300
ORDER BY mrp DESC;

--calculate estimated revenue from each category--

SELECT category,
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;


--find all products where mrp is greater than rs.500 and discount is less than 10%--

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 and discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

--IDENTIFY THE TOP 5 CATEGORIES OFFERING THE HEIGHT AVERAGE DISCOUNT PERCENT--
SELECT category,
ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--find price per gram for products above 100g and sort by best value--

SELECT DISTINCT name, weightingrams, discountedsellingprice, 
ROUND (discountedsellingprice/weightingrams,2) AS price_per_gram
FROM zepto
WHERE weightingrams>=100
ORDER BY price_per_gram;

--group the products  in categories like low, medium, bulks---

SELECT DISTINCT name, weightingrams,
CASE  WHEN weightingrams < 1000 THEN 'Low'
    WHEN weightingrams < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
	FROM zepto;

--TOTAL INTRAVETORY WEIGHT PER CATEGORY--

SELECT category,
SUM(weightingrams * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY  total_weight;

