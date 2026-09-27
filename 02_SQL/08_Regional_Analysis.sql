-- ==================================================================================================================
-- 01. City Revenue & Profit Performance
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 18: City Revenue & Profit Performance

SELECT
    o.Shipping_State AS State,
    o.Shipping_City AS City,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,

    SUM(od.Quantity) AS Units_Sold,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    o.Shipping_State,
    o.Shipping_City

ORDER BY
    Revenue DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 02. Regional Profit Margin Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 19: Regional Profit Margin Analysis

SELECT
    o.Shipping_State AS State,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    o.Shipping_State

ORDER BY
    Profit_Margin_Percentage DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 03. State Order & Customer Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 20: State Order & Customer Analysis

SELECT
    o.Shipping_State AS State,

    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Quantity) AS Units_Sold,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0)
        AS Average_Order_Value,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Customer_ID), 0)
        AS Revenue_Per_Customer

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    o.Shipping_State

ORDER BY
    Revenue DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 04. State Revenue & Profit Performance
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 18: City Revenue & Profit Performance

SELECT
    o.Shipping_State AS State,
    o.Shipping_City AS City,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,

    SUM(od.Quantity) AS Units_Sold,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    o.Shipping_State,
    o.Shipping_City

ORDER BY
    Revenue DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 05. Top & Bottom Performing Regions
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 21: Top & Bottom Performing Regions

WITH Regional_Performance AS
(
    SELECT
        o.Shipping_State AS State,

        COUNT(DISTINCT o.Order_ID) AS Total_Orders,

        COUNT(DISTINCT o.Customer_ID) AS Total_Customers,

        SUM(od.Quantity) AS Units_Sold,

        SUM(od.Sales_Amount) AS Revenue,

        SUM(od.Cost_Amount) AS Cost,

        SUM(od.Profit_Amount) AS Profit,

        SUM(od.Profit_Amount) * 100.0 /
            NULLIF(SUM(od.Sales_Amount), 0)
            AS Profit_Margin_Percentage

    FROM Orders o

    INNER JOIN Order_Details od
        ON o.Order_ID = od.Order_ID

    WHERE o.Order_Status = 'Delivered'

    GROUP BY
        o.Shipping_State
),

Ranked_Regions AS
(
    SELECT
        *,
        
        ROW_NUMBER() OVER (
            ORDER BY Profit DESC
        ) AS Profit_Rank_High,

        ROW_NUMBER() OVER (
            ORDER BY Profit ASC
        ) AS Profit_Rank_Low

    FROM Regional_Performance
)

SELECT
    State,
    Total_Orders,
    Total_Customers,
    Units_Sold,
    Revenue,
    Cost,
    Profit,
    Profit_Margin_Percentage,

    CASE
        WHEN Profit_Rank_High <= 5
            THEN 'Top 5'

        WHEN Profit_Rank_Low <= 5
            THEN 'Bottom 5'
    END AS Performance_Group

FROM Ranked_Regions

WHERE Profit_Rank_High <= 5
   OR Profit_Rank_Low <= 5

ORDER BY
    Profit DESC;
