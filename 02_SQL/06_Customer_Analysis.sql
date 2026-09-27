-- ==================================================================================================================
-- 01. Customer Purchase Frequency
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 10: Customer Purchase Frequency

WITH Customer_Order_Count AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders

    FROM Customers c

    INNER JOIN Orders o
        ON c.Customer_ID = o.Customer_ID

    WHERE o.Order_Status = 'Delivered'

    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),

Purchase_Frequency AS
(
    SELECT
        Customer_ID,
        Customer_Name,
        Total_Orders,

        CASE
            WHEN Total_Orders = 1
                THEN '1 Order'

            WHEN Total_Orders BETWEEN 2 AND 3
                THEN '2-3 Orders'

            WHEN Total_Orders BETWEEN 4 AND 5
                THEN '4-5 Orders'

            WHEN Total_Orders BETWEEN 6 AND 10
                THEN '6-10 Orders'

            WHEN Total_Orders > 10
                THEN '10+ Orders'
        END AS Purchase_Frequency_Group

    FROM Customer_Order_Count
)

SELECT
    Purchase_Frequency_Group,

    COUNT(*) AS Total_Customers,

    COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS Customer_Percentage,

    AVG(Total_Orders * 1.0) AS Average_Orders_Per_Customer

FROM Purchase_Frequency

GROUP BY
    Purchase_Frequency_Group

ORDER BY
    MIN(Total_Orders);

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 02. Customer Revenue & Profit Contribution
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 7: Customer Revenue & Profit Contribution

SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.City,
    c.State,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Quantity) AS Units_Purchased,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

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
-- 03. Customer Segment Performance
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 8: Customer Segment Performance

SELECT
    c.Customer_Segment,

    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Quantity) AS Units_Purchased,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

    SUM(od.Profit_Amount) AS Profit,

    SUM(od.Profit_Amount) * 100.0 /
        NULLIF(SUM(od.Sales_Amount), 0)
        AS Profit_Margin_Percentage,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT o.Order_ID), 0)
        AS Average_Order_Value,

    SUM(od.Sales_Amount) /
        NULLIF(COUNT(DISTINCT c.Customer_ID), 0)
        AS Revenue_Per_Customer

FROM Customers c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status = 'Delivered'

GROUP BY
    c.Customer_Segment

ORDER BY
    Revenue DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 04. High-Value Customer Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 11: High-Value Customer Analysis

WITH Customer_Performance AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        c.Customer_Segment,
        c.City,
        c.State,

        COUNT(DISTINCT o.Order_ID) AS Total_Orders,

        SUM(od.Quantity) AS Units_Purchased,

        SUM(od.Sales_Amount) AS Revenue,

        SUM(od.Cost_Amount) AS Cost,

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
),

Ranked_Customers AS
(
    SELECT
        *,
        
        ROW_NUMBER() OVER (
            ORDER BY Revenue DESC
        ) AS Revenue_Rank,

        ROW_NUMBER() OVER (
            ORDER BY Profit DESC
        ) AS Profit_Rank

    FROM Customer_Performance
)

SELECT
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    City,
    State,
    Total_Orders,
    Units_Purchased,
    Revenue,
    Cost,
    Profit,
    Profit_Margin_Percentage,
    Average_Order_Value,
    Revenue_Rank,
    Profit_Rank

FROM Ranked_Customers

WHERE Revenue_Rank <= 10
   OR Profit_Rank <= 10

ORDER BY
    Revenue DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 05. Repeat vs One-Time Customers
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 9: Repeat vs One-Time Customers

WITH Customer_Order_Count AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders

    FROM Customers c

    INNER JOIN Orders o
        ON c.Customer_ID = o.Customer_ID

    WHERE o.Order_Status = 'Delivered'

    GROUP BY
        c.Customer_ID,
        c.Customer_Name
),

Customer_Type AS
(
    SELECT
        Customer_ID,
        Customer_Name,
        Total_Orders,

        CASE
            WHEN Total_Orders = 1
                THEN 'One-Time Customer'

            WHEN Total_Orders > 1
                THEN 'Repeat Customer'
        END AS Customer_Type

    FROM Customer_Order_Count
)

SELECT
    Customer_Type,

    COUNT(*) AS Total_Customers,

    COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS Customer_Percentage

FROM Customer_Type

GROUP BY
    Customer_Type

ORDER BY
    Total_Customers DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 06. ustomer Revenue & Profit Contribution
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 7: Customer Revenue & Profit Contribution

SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.City,
    c.State,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    SUM(od.Quantity) AS Units_Purchased,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Cost_Amount) AS Cost,

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
