-- ==================================================================================================================
-- 01. Cancellation & Return Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 24: Cancellation & Return Analysis

SELECT
    o.Order_Status,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    COUNT(DISTINCT o.Order_ID) * 100.0 /
        SUM(COUNT(DISTINCT o.Order_ID)) OVER ()
        AS Order_Percentage,

    SUM(od.Sales_Amount) AS Associated_Revenue,

    SUM(od.Profit_Amount) AS Associated_Profit

FROM Orders o

INNER JOIN Order_Details od
    ON o.Order_ID = od.Order_ID

WHERE o.Order_Status IN ('Cancelled', 'Returned')

GROUP BY
    o.Order_Status

ORDER BY
    Total_Orders DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 02. Delivery Performance Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 23: Delivery Performance Analysis

SELECT
    COUNT(DISTINCT Order_ID) AS Delivered_Orders,

    AVG(
        DATEDIFF(
            DAY,
            Order_Date,
            Shipping_Date
        ) * 1.0
    ) AS Average_Order_To_Ship_Days,

    AVG(
        DATEDIFF(
            DAY,
            Shipping_Date,
            Delivery_Date
        ) * 1.0
    ) AS Average_Shipping_To_Delivery_Days,

    AVG(
        DATEDIFF(
            DAY,
            Order_Date,
            Delivery_Date
        ) * 1.0
    ) AS Average_Total_Delivery_Days

FROM Orders

WHERE Order_Status = 'Delivered'

  AND Shipping_Date IS NOT NULL

  AND Delivery_Date IS NOT NULL;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 03. Operational Performance by Region
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 26: Operational Performance by Region

SELECT
    Shipping_State AS State,

    COUNT(DISTINCT Order_ID) AS Total_Orders,

    COUNT(DISTINCT CASE
        WHEN Order_Status = 'Delivered'
        THEN Order_ID
    END) AS Delivered_Orders,

    COUNT(DISTINCT CASE
        WHEN Order_Status = 'Cancelled'
        THEN Order_ID
    END) AS Cancelled_Orders,

    COUNT(DISTINCT CASE
        WHEN Order_Status = 'Returned'
        THEN Order_ID
    END) AS Returned_Orders,

    COUNT(DISTINCT CASE
        WHEN Order_Status IN ('Cancelled', 'Returned')
        THEN Order_ID
    END) * 100.0 /
        NULLIF(COUNT(DISTINCT Order_ID), 0)
        AS Cancellation_Return_Rate,

    AVG(CASE
        WHEN Order_Status = 'Delivered'
             AND Shipping_Date IS NOT NULL
             AND Delivery_Date IS NOT NULL
        THEN DATEDIFF(
            DAY,
            Order_Date,
            Delivery_Date
        ) * 1.0
    END) AS Average_Delivery_Days

FROM Orders

GROUP BY
    Shipping_State

ORDER BY
    Cancellation_Return_Rate DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 04. Order Status Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 22: Order Status Analysis

SELECT
    Order_Status,

    COUNT(DISTINCT Order_ID) AS Total_Orders,

    COUNT(DISTINCT Order_ID) * 100.0 /
        SUM(COUNT(DISTINCT Order_ID)) OVER ()
        AS Order_Percentage

FROM Orders

GROUP BY
    Order_Status

ORDER BY
    Total_Orders DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ==================================================================================================================
-- 05. Payment Method Analysis
-- ==================================================================================================================

USE Urbancart_Retail;
GO

-- Code 25: Payment Method Analysis

SELECT
    o.Payment_Method,

    COUNT(DISTINCT o.Order_ID) AS Total_Orders,

    COUNT(DISTINCT o.Customer_ID) AS Total_Customers,

    SUM(od.Sales_Amount) AS Revenue,

    SUM(od.Profit_Amount) AS Profit,

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
    o.Payment_Method

ORDER BY
    Revenue DESC;
