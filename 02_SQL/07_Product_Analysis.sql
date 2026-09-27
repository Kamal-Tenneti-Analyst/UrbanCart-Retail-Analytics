-- ==================================================================================================================
-- 01. Product Category Performance
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 13: Product Category Performance

SELECT
    p.Category,

    COUNT(DISTINCT p.Product_ID) AS Total_Products,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Quantity) AS Units_Sold,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) /
        NULLIF(SUM(od.Quantity), 0)
        AS Average_Selling_Price

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
-- 02. Product Profit Margin Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 15: Product Profit Margin Analysis

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Sub_Category,
    p.Brand,

    SUM(od.Quantity) AS Units_Sold,

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
    Profit_Margin_Percentage DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 03. Product Revenue & Profit Performance
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 12: Product Revenue & Profit Performance

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Sub_Category,
    p.Brand,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Quantity) AS Units_Sold,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) /
        NULLIF(SUM(od.Quantity), 0)
        AS Average_Selling_Price

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
    Revenue DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 04. Product Sales Volume Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 14: Product Sales Volume Analysis

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Sub_Category,
    p.Brand,

    SUM(od.Quantity) AS Units_Sold,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Sales_Amount) AS Revenue,

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
    Units_Sold DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 05. Top & Bottom Product Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 16: Top & Bottom Product Analysis

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
        WHEN Profit_Rank_High <= 10
            THEN 'Top 10'

        WHEN Profit_Rank_Low <= 10
            THEN 'Bottom 10'
    END AS Performance_Group

FROM Ranked_Products

WHERE Profit_Rank_High <= 10
   OR Profit_Rank_Low <= 10

ORDER BY
    Profit DESC;
