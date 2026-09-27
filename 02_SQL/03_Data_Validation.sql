
01.KPI 
  
select 
	sum(Sales_Amount) as Total_Revenue,
	sum(Profit_Amount) as Total_Profit,
	count(Distinct Order_ID) as Total_Orders,
	sum(Sales_Amount)/ Count(Distinct Order_ID) as AOV,
	SUM(Profit_Amount) * 100.0 /
    NULLIF(SUM(Sales_Amount), 0) AS Profit_Margin_Percentage
from Order_Details;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
02.Montly Sales 
  
use Urbancart_Retail;
go 

SELECT
    YEAR(o.Order_Date) AS Order_Year,
    MONTH(o.Order_Date) AS Order_Month,
    SUM(od.Sales_Amount) AS Revenue,
    SUM(od.Profit_Amount) AS Profit,
    COUNT(DISTINCT o.Order_ID) AS Orders
FROM Orders o
JOIN Order_Details od
    ON o.Order_ID = od.Order_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)
ORDER BY
    Order_Year,
    Order_Month;


----------------------------------------------------------------------------------------------------------------------------------------------------------------

03.Step 1A — Check all table row counts  003.sql
  
USE Urbancart_Retail;
GO

SELECT 'Customers' AS Table_Name, COUNT(*) AS Row_Count
FROM Customers

UNION ALL

SELECT 'Products', COUNT(*)
FROM Products

UNION ALL

SELECT 'Orders', COUNT(*)
FROM Orders

UNION ALL

SELECT 'Order_Details', COUNT(*)
FROM Order_Details

UNION ALL

SELECT 'Date_Dimension', COUNT(*)
FROM Date_Dimension;


----------------------------------------------------------------------------------------------------------------------------------------------------------------
04. Step 1B — Check duplicate IDs 004.sql

-- Customers
SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


-- Products
SELECT Product_ID, COUNT(*) AS Duplicate_Count
FROM Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;


-- Orders
SELECT Order_ID, COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- Order Details
SELECT Order_Detail_ID, COUNT(*) AS Duplicate_Count
FROM Order_Details
GROUP BY Order_Detail_ID
HAVING COUNT(*) > 1;
----------------------------------------------------------------------------------------------------------------------------------------------------------------


05. Step 1C — Check NULL values in important columns 005.sql

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
    SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) AS Null_Customer_Name,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN Customer_Segment IS NULL THEN 1 ELSE 0 END) AS Null_Segment
FROM Customers;


----------------------------------------------------------------------------------------------------------------------------------------------------------------

06.Step 1C — Check NULL values in important columns for Customers 005.sql

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Null_Order_Date,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS Null_Payment_Method,
    SUM(CASE WHEN Order_Status IS NULL THEN 1 ELSE 0 END) AS Null_Order_Status
FROM Orders;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

07.Step 1C — Check NULL values in important columns for Products 005.sql

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) AS Null_Product_Name,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Null_Category,
    SUM(CASE WHEN Cost_Price IS NULL THEN 1 ELSE 0 END) AS Null_Cost,
    SUM(CASE WHEN Selling_Price IS NULL THEN 1 ELSE 0 END) AS Null_Selling_Price
FROM Products;


----------------------------------------------------------------------------------------------------------------------------------------------------------------
08.Step 1D — Check orphan records 006.sql
SELECT COUNT(*) AS Orphan_Orders
FROM Orders o
LEFT JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;


----------------------------------------------------------------------------------------------------------------------------------------------------------------
09.Step 1D — Check orphan records for Orders without an Order 006.sql

SELECT COUNT(*) AS Orphan_Order_Details
FROM Order_Details od
LEFT JOIN Orders o
    ON od.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
10.Step 1D — Check orphan records for Orders without an Product 006.sql

SELECT COUNT(*) AS Orphan_Product_References
FROM Order_Details od
LEFT JOIN Products p
    ON od.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;
