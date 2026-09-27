-- ==================================================================================================================
-- 01. Business Performance Summary
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 30: Business Performance Summary

SELECT

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,

    SUM(od.Quantity) AS Total_Units_Sold,

    SUM(od.Sales_Amount) AS Total_Revenue,

    SUM(od.Cost_Amount) AS Total_Cost,

    SUM(od.Profit_Amount) AS Total_Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0)
        AS Average_Order_Value,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Customer_ID), 0)
        AS Revenue_Per_Customer

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered';

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 02. Customer & Product Contribution Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 28: Customer & Product Contribution Analysis

WITH Customer_Contribution AS
(
    SELECT
        'Customer' AS Contribution_Type,

        CAST(c.Customer_ID AS VARCHAR(50)) AS Entity_ID,

        c.Customer_Name AS Entity_Name,

        SUM(od.Sales_Amount) AS Revenue,

        SUM(od.Profit_Amount) AS Profit

    FROM Customers c

    INNER JOIN Orders o
        ON c.Customer_ID = o.Customer_ID

    INNER JOIN Order_Details od
        ON o.Order_ID = od.Order_ID

    WHERE o.Order_Status = 'Delivered'

    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),

Product_Contribution AS
(
    SELECT
        'Product' AS Contribution_Type,

        CAST(p.Product_ID AS VARCHAR(50)) AS Entity_ID,

        p.Product_Name AS Entity_Name,

        SUM(od.Sales_Amount) AS Revenue,

        SUM(od.Profit_Amount) AS Profit

    FROM Products p

    INNER JOIN Order_Details od
        ON p.Product_ID = od.Product_ID

    INNER JOIN Orders o
        ON od.Order_ID = o.Order_ID

    WHERE o.Order_Status = 'Delivered'

    GROUP BY
        p.Product_ID,
        p.Product_Name
),

Combined_Contribution AS
(
    SELECT * FROM Customer_Contribution

    UNION ALL

    SELECT * FROM Product_Contribution
),

Ranked_Contribution AS
(
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY Contribution_Type
            ORDER BY Revenue DESC
        ) AS Revenue_Rank

    FROM Combined_Contribution
)

SELECT
    Contribution_Type,
    Entity_ID,
    Entity_Name,
    Revenue,
    Profit,
    Revenue_Rank

FROM Ranked_Contribution

WHERE Revenue_Rank <= 10

ORDER BY
    Contribution_Type,
    Revenue_Rank;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 03. Key Business Findings
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 31: Key Business Findings

SELECT
    'Overall Business Performance' AS Finding_Area,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered';


SELECT
    'Top Revenue Category' AS Finding_Area,

    TOP 1
    p.Category,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit

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


SELECT
    'Top Profit Category' AS Finding_Area,

    TOP 1
    p.Category,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit

FROM Products p

INNER JOIN Order_Details od
    ON p.Product_ID = od.Product_ID

INNER JOIN Orders o
    ON od.Order_ID = o.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    p.Category

ORDER BY
    Profit DESC;


SELECT
    'Top Revenue State' AS Finding_Area,

    TOP 1
    o.Shipping_State AS State,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit

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
-- 04. Revenue & Profit Driver Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 27: Revenue & Profit Driver Analysis

SELECT
    p.Category,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) * 100.0 /
        NULLIF(
            SUM(SUM(od.Sales_Amount)) OVER (),
            0
        ) AS Revenue_Contribution_Percentage,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(
            SUM(SUM(od.Profit_Amount)) OVER (),
            0
        ) AS Profit_Contribution_Percentage

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
-- 05. Revenue vs Profitability Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 29: Revenue vs Profitability Analysis

SELECT
    p.Category,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    CASE
        WHEN
            SUM(od.Sales_Amount) >=
            (
                SELECT AVG(Category_Revenue)
                FROM
                (
                    SELECT
                        SUM(od2.Sales_Amount) AS Category_Revenue
                    FROM Products p2
                    INNER JOIN Order_Details od2
                        ON p2.Product_ID = od2.Product_ID
                    INNER JOIN Orders o2
                        ON od2.Order_ID = o2.Order_ID
                    WHERE o2.Order_Status = 'Delivered'
                    GROUP BY p2.Category
                ) AS Revenue_Average
            )
        AND
            SUM(od.Profit_Amount) * 100.0 /
            NULLIF(SUM(od.Sales_Amount), 0) >=
            (
                SELECT AVG(Category_Margin)
                FROM
                (
                    SELECT
                        SUM(od3.Profit_Amount) * 100.0 /
                        NULLIF(SUM(od3.Sales_Amount), 0)
                        AS Category_Margin
                    FROM Products p3
                    INNER JOIN Order_Details od3
                        ON p3.Product_ID = od3.Product_ID
                    INNER JOIN Orders o3
                        ON od3.Order_ID = o3.Order_ID
                    WHERE o3.Order_Status = 'Delivered'
                    GROUP BY p3.Category
                ) AS Margin_Average
            )
            THEN 'High Revenue - High Margin'

        WHEN
            SUM(od.Sales_Amount) >=
            (
                SELECT AVG(Category_Revenue)
                FROM
                (
                    SELECT
                        SUM(od4.Sales_Amount) AS Category_Revenue
                    FROM Products p4
                    INNER JOIN Order_Details od4
                        ON p4.Product_ID = od4.Product_ID
                    INNER JOIN Orders o4
                        ON od4.Order_ID = o4.Order_ID
                    WHERE o4.Order_Status = 'Delivered'
                    GROUP BY p4.Category
                ) AS Revenue_Average_2
            )
            THEN 'High Revenue - Lower Margin'

        ELSE 'Lower Revenue'
    END AS Performance_Group

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
