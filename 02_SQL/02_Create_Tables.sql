
--To create the table for Products using the products data set--

USE Urbancart_Retail;
GO

CREATE TABLE Products
(
    Product_ID          INT             NOT NULL,
    Product_Name        VARCHAR(150)    NOT NULL,
    Category            VARCHAR(100)    NOT NULL,
    Sub_Category        VARCHAR(100)    NOT NULL,
    Brand               VARCHAR(100)    NOT NULL,
    Cost_Price          DECIMAL(10,2)   NOT NULL,
    Selling_Price       DECIMAL(10,2)   NOT NULL,

    CONSTRAINT PK_Products
        PRIMARY KEY (Product_ID),

    CONSTRAINT CK_Products_CostPrice
        CHECK (Cost_Price > 0),

    CONSTRAINT CK_Products_SellingPrice
        CHECK (Selling_Price > 0)
);



--- For creating the Order_details

use Urbancart_Retail;
go

CREATE TABLE Order_Details
(
    Order_Detail_ID     BIGINT          NOT NULL,
    Order_ID            BIGINT          NOT NULL,
    Product_ID          INT             NOT NULL,
    Quantity            INT             NOT NULL,
    Unit_Price          DECIMAL(10,2)   NOT NULL,
    Discount_Percent    DECIMAL(5,2)    NOT NULL,
    Discount_Amount     DECIMAL(12,2)   NOT NULL,
    Sales_Amount        DECIMAL(12,2)   NOT NULL,
    Cost_Amount         DECIMAL(12,2)   NOT NULL,
    Profit_Amount       DECIMAL(12,2)   NOT NULL,

    CONSTRAINT PK_Order_Details
        PRIMARY KEY (Order_Detail_ID),

    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID),

    CONSTRAINT FK_OrderDetails_Products
        FOREIGN KEY (Product_ID)
        REFERENCES Products(Product_ID),

    CONSTRAINT CK_OrderDetails_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_OrderDetails_UnitPrice
        CHECK (Unit_Price > 0),

    CONSTRAINT CK_OrderDetails_Discount
        CHECK
        (
            Discount_Percent >= 0
            AND Discount_Percent <= 100
        ),

    CONSTRAINT CK_OrderDetails_DiscountAmount
        CHECK (Discount_Amount >= 0),

    CONSTRAINT CK_OrderDetails_SalesAmount
        CHECK (Sales_Amount >= 0),

    CONSTRAINT CK_OrderDetails_CostAmount
        CHECK (Cost_Amount >= 0)
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------


---To create the Orders table

use Urbancart_Retail;
go

CREATE TABLE Orders
(
    Order_ID            BIGINT          NOT NULL,
    Customer_ID         INT             NOT NULL,
    Order_Date          DATE            NOT NULL,
    Shipping_Date       DATE            NULL,
    Delivery_Date       DATE            NULL,
    Payment_Method      VARCHAR(30)     NOT NULL,
    Order_Status        VARCHAR(30)     NOT NULL,
    Shipping_City       VARCHAR(50)     NOT NULL,
    Shipping_State      VARCHAR(50)     NOT NULL,

    CONSTRAINT PK_Orders
        PRIMARY KEY (Order_ID),

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID),

    CONSTRAINT CK_Orders_Payment
        CHECK (Payment_Method IN
        ('UPI', 'Credit Card', 'Debit Card',
         'Net Banking', 'Cash on Delivery',
         'Wallet')),

    CONSTRAINT CK_Orders_Status
        CHECK (Order_Status IN
        ('Delivered', 'Cancelled', 'Returned')),

    CONSTRAINT CK_Orders_ShippingDate
        CHECK
        (
            Shipping_Date IS NULL
            OR Shipping_Date >= Order_Date
        ),

    CONSTRAINT CK_Orders_DeliveryDate
        CHECK
        (
            Delivery_Date IS NULL
            OR Shipping_Date IS NULL
            OR Delivery_Date >= Shipping_Date
        )
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------


---To create the date_dimensiions to calculate the analysis


use Urbancart_Retail;
go

CREATE TABLE Date_Dimension
(
    Date_ID             INT             NOT NULL,
    Full_Date           DATE            NOT NULL,
    Day_Number          INT             NOT NULL,
    Day_Name            VARCHAR(20)     NOT NULL,
    Week_Number         INT             NOT NULL,
    Month_Number        INT             NOT NULL,
    Month_Name          VARCHAR(20)     NOT NULL,
    Quarter_Number      INT             NOT NULL,
    Quarter_Name        VARCHAR(10)     NOT NULL,
    Year_Number         INT             NOT NULL,

    CONSTRAINT PK_Date_Dimension
        PRIMARY KEY (Date_ID),

    CONSTRAINT UQ_Date_Dimension_FullDate
        UNIQUE (Full_Date),

    CONSTRAINT CK_Date_Dimension_Day
        CHECK (Day_Number BETWEEN 1 AND 31),

    CONSTRAINT CK_Date_Dimension_Month
        CHECK (Month_Number BETWEEN 1 AND 12),

    CONSTRAINT CK_Date_Dimension_Quarter
        CHECK (Quarter_Number BETWEEN 1 AND 4)
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------


--- To create the Customers table


use Urbancart_Retail;
go

CREATE TABLE Customers
(
    Customer_ID        INT             NOT NULL,
    Customer_Name      VARCHAR(100)    NOT NULL,
    Gender             VARCHAR(20)     NULL,
    Age                INT             NULL,
    City               VARCHAR(50)     NOT NULL,
    State              VARCHAR(50)     NOT NULL,
    Customer_Segment   VARCHAR(30)     NOT NULL,
    Join_Date           DATE            NOT NULL,

    CONSTRAINT PK_Customers
        PRIMARY KEY (Customer_ID),

    CONSTRAINT CK_Customers_Age
        CHECK (Age BETWEEN 18 AND 100),

    CONSTRAINT CK_Customers_Gender
        CHECK (Gender IN ('Male', 'Female', 'Other')),

    CONSTRAINT CK_Customers_Segment
        CHECK (Customer_Segment IN
        ('New', 'Regular', 'Premium'))
);
