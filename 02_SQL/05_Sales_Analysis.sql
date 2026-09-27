-- ==================================================================================================================
-- 01. Customer Revenue & Profit Contribution
-- ==================================================================================================================

USE Urbancart_Retail;
GO

SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.City,
    c.State,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Quantity) AS Units_Purchased,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0)
        AS Average_Order_Value

FROM Customers c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.City,
    c.State

ORDER BY
    Revenue DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 02. Monthly Revenue, Profit & Orders
-- ==================================================================================================================

USE Urbancart_Retail;
GO

SELECT
    YEAR(o.Order_Date) AS Order_Year,
    MONTH(o.Order_Date) AS Order_Month,

    SUM(od.Sales_Amount) AS Revenue,
    SUM(od.Profit_Amount) AS Profit,

    COUNT(DISTINCT o.Order_ID) AS Orders,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0)
        AS Average_Order_Value

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)

ORDER BY
    Order_Year,
    Order_Month;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 03. Product Category Performance
-- ==================================================================================================================

USE Urbancart_Retail;
GO

SELECT
    p.Category,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Quantity) AS Units_Sold,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0)
        AS Average_Order_Value

FROM Products p

INNER JOIN Order_Details od
    ON p.Product_ID = od.Product_ID

INNER JOIN Orders o
    ON od.Order_ID = o.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    p.Category

ORDER BY
    Revenue DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 04. Product-Level Profitability
-- ==================================================================================================================

USE Urbancart_Retail;
GO

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Sub_Category,
    p.Brand,

    SUM(od.Quantity) AS Units_Sold,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage

FROM Products p

INNER JOIN Order_Details od
    ON p.Product_ID = od.Product_ID

INNER JOIN Orders o
    ON od.Order_ID = o.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Sub_Category,
    p.Brand

ORDER BY
    Profit DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 05. Query 1 — Executive Sales KPIs
-- ==================================================================================================================

USE Urbancart_Retail;
GO

SELECT
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,
    SUM(od.Sales_Amount) AS Total_Revenue,
    SUM(od.Cost_Amount) AS Total_Cost,
    SUM(od.Profit_Amount) AS Total_Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0)
        AS Average_Order_Value

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered';

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 06. Revenue and Profit is UrbanCart Actually Generating - Sales Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

SELECT
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,
    SUM(od.Sales_Amount) AS Total_Revenue,
    SUM(od.Cost_Amount) AS Total_Cost,
    SUM(od.Profit_Amount) AS Total_Profit,
    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0) AS Profit_Margin_Percentage,
    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0) AS Average_Order_Value
FROM Orders o
JOIN Order_Details od
    ON o.Order_ID = od.Order_ID
WHERE o.Order_Status = 'Delivered';

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 07. Revenue and Profit is UrbanCart Actually Generating
-- ==================================================================================================================

USE Urbancart_Retail;
GO
 
/* This gives us our first Executive KPI set
   and those are Total Orders, Total Customers, Total Revenue, Total Cost
    Total Profit, Profit Margin, AOV*/

SELECT
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,
    SUM(od.Sales_Amount) AS Total_Revenue,
    SUM(od.Cost_Amount) AS Total_Cost,
    SUM(od.Profit_Amount) AS Total_Profit,
    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0) AS Profit_Margin_Percentage,
    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0) AS Average_Order_Value
FROM Orders o
JOIN Order_Details od
    ON o.Order_ID = od.Order_ID
WHERE o.Order_Status = 'Delivered';

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 08. Top 10 & Bottom 10 Products by Profitability
-- ==================================================================================================================

USE Urbancart_Retail;
GO

WITH Product_Performance AS
(
    SELECT
        p.Product_ID,
        p.Product_Name,
        p.Category,
        p.Sub_Category,
        p.Brand,

        SUM(od.Quantity) AS Units_Sold,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders,
        SUM(od.Sales_Amount) AS Revenue,
        SUM(od.Cost_Amount) AS Cost,
        SUM(od.Profit_Amount) AS Profit,

        SUM(od.Profit_Amount) * 100.0 /
            NULLIF(SUM(od.Sales_Amount), 0)
            AS Profit_Margin_Percentage

    FROM Products p

    INNER JOIN Order_Details od
        ON p.Product_ID = od.Product_ID

    INNER JOIN Orders o
        ON od.Order_ID = o.Order_ID

    WHERE o.Order_Status = 'Delivered'

    GROUP BY
        p.Product_ID,
        p.Product_Name,
        p.Category,
        p.Sub_Category,
        p.Brand
),

Ranked_Products AS
(
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY Profit DESC
        ) AS Profit_Rank_High,

        ROW_NUMBER() OVER (
            ORDER BY Profit ASC
        ) AS Profit_Rank_Low

    FROM Product_Performance
)

SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    Brand,
    Units_Sold,
    Total_Orders,
    Revenue,
    Cost,
    Profit,
    Profit_Margin_Percentage,

    CASE
        WHEN Profit_Rank_High <= 10 THEN 'Top 10'
        WHEN Profit_Rank_Low <= 10 THEN 'Bottom 10'
    END AS Profitability_Group

FROM Ranked_Products

WHERE Profit_Rank_High <= 10
   OR Profit_Rank_Low <= 10

ORDER BY
    Profit DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 09. Yearly Revenue, Profit & Growth
-- ==================================================================================================================

USE Urbancart_Retail;
GO

WITH Yearly_Sales AS
(
    SELECT
        YEAR(o.Order_Date) AS Order_Year,
        SUM(od.Sales_Amount) AS Revenue,
        SUM(od.Profit_Amount) AS Profit,
        COUNT(DISTINCT o.Order_ID) AS Orders
    FROM Orders o
    INNER JOIN Order_Details od
        ON o.Order_ID = od.Order_ID
    WHERE o.Order_Status = 'Delivered'
    GROUP BY YEAR(o.Order_Date)
)

SELECT
    Order_Year,
    Revenue,
    Profit,
    Orders,

    LAG(Revenue) OVER (
        ORDER BY Order_Year
    ) AS Previous_Year_Revenue,

    (Revenue -
        LAG(Revenue) OVER (
            ORDER BY Order_Year
        )
    ) * 100.0 /
    NULLIF(
        LAG(Revenue) OVER (
            ORDER BY Order_Year
        ), 0
    ) AS Revenue_Growth_Percentage

FROM Yearly_Sales

ORDER BY Order_Year;
