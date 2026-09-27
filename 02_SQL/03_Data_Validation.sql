
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






