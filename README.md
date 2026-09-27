UrbanCart-Retail-Analytics

Retail sales and customer analytics project built with SQL Server, Power BI &amp; DAX, using a synthetic dataset generated with GenAI for portfolio and analytical demonstration.



# UrbanCart Retail — Sales & Customer Analytics

## 📊 Project Overview

UrbanCart Retail is an end-to-end retail analytics portfolio project focused on analyzing sales performance, customer behavior, product performance, regional performance, and operational metrics.

The project demonstrates a complete analytics workflow using **SQL Server, Power BI, and DAX**, transforming transactional data into business insights and actionable recommendations.

### Analytics Workflow

**Data Validation → EDA → SQL Analysis → KPI Development → Data Modeling → Power BI Dashboard → Business Insights → Recommendations**

> **Dataset Disclaimer:** The dataset used in this project is synthetic and was generated with the assistance of Generative AI (GenAI). It does not represent actual UrbanCart customer, sales, or operational data. The dataset was created solely for portfolio, learning, and analytical demonstration purposes.

---

# 🎯 Business Objective

The objective of this project is to analyze retail business performance and identify insights across:

- Sales performance
- Customer behavior
- Product performance
- Regional performance
- Order operations
- Delivery performance
- Payment behavior
- Profitability

The analysis focuses on understanding business performance, identifying areas requiring further investigation, and developing data-driven recommendations.

---

# 🛠️ Tools & Technologies

- **SQL Server**
- **SQL**
- **Power BI**
- **DAX**
- **CSV**
- **GitHub**

---

# 📁 Dataset

The project uses a synthetic retail dataset generated with the assistance of GenAI.

The dataset contains approximately:

| Table | Records |
|---|---:|
| Customers | 20,000 |
| Products | 2,000 |
| Orders | 100,000 |
| Order Details | approximately 3,00,000 |
| Date Dimension | 1,461 |

## Tables

### Customers

Contains customer information including:

- Customer ID
- Gender
- Age
- City
- State
- Customer Segment
- Join Date

### Products

Contains product information including:

- Product ID
- Product Name
- Category
- Sub-Category
- Brand
- Cost Price
- Selling Price

### Orders

Contains order-level information including:

- Order ID
- Customer ID
- Order Date
- Shipping Date
- Delivery Date
- Payment Method
- Order Status
- Shipping City
- Shipping State

### Order Details

Contains product-level transaction information including:

- Order ID
- Product ID
- Quantity
- Unit Price
- Discount
- Sales Amount
- Cost Amount
- Profit Amount

### Date Dimension

Contains calendar attributes used for time-based analysis:

- Date
- Day
- Week
- Month
- Quarter
- Year

---

# 🔗 Data Model

The Power BI data model connects the tables using the following relationships:

```text
Customers
    │
    │ 1 : *
    ▼
Orders
    │
    │ 1 : *
    ▼
Order_Details
    ▲
    │
    │ * : 1
Products


Date_Dimension
    │
    │ 1 : *
    ▼
Orders
