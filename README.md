# Supply Chain Analytics

## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Insights](#insights)
- [Conclusion](#conclusion)


### Project Overview  
#### Problem Statement
The organization faces several challenges in its supply chain operations, including inadequate stock visibility, which limits insight into current inventory levels and reorder requirements. Additionally, inconsistent supplier performance, marked by varying lead times, disrupts production schedules. The lack of real-time procurement tracking further delays financial insights, hindering timely and effective decision-making.
#### Project Goal
This project analyzes stock levels, supplier performance, and revenue trends to support inventory optimization. It focuses on improving stock management, selecting reliable suppliers, and tracking revenue to enable informed, data-driven decisions

### Data Sources
[Orders.csv](https://github.com/LMjuju10/Supply-Chain-analytics/blob/main/Orders.csv)    
[Products.csv](https://github.com/LMjuju10/Supply-Chain-analytics/blob/main/Products.csv)   
[Suppliers.csv]( https://github.com/LMjuju10/Supply-Chain-analytics/blob/main/Suppliers.csv)     

### Tools 
- Excel
- SQL server (Data analysis)
- Power BI (Creating a report)


### Exploratory Data Analysis
EDA explored the sales data to answer key questions such as
- Which stock items are currently below their reorder levels?
- Who are the top-performing suppliers based on the shortest lead times?
- How have total order quantities changed over time?
- What patterns in lead time and stock trends can help predict optimal reorder timing?


### Data Analysis

Some queries that were done during the data analysis Process

```Sql

-- Analyzing total order quantities over time


ALTER TABLE Suppliers ADD COLUMN OrderQty_To_Date INT;

SELECT Order_ID, 
       Quantity_Ordered, 
       SUM(Quantity_Ordered) OVER (ORDER BY Order_ID) AS Running_Total
FROM Suppliers;

UPDATE Suppliers s
JOIN (
    SELECT Order_ID, 
           SUM(Quantity_Ordered) OVER (ORDER BY Order_ID) AS Running_Total
    FROM Suppliers
) AS temp ON s.Order_ID = temp.Order_ID
SET s.OrderQty_To_Date = temp.Running_Total;

-- Predicting when to reorder based on Leadtime and stocks

SELECT 
    P.Product_ID,
    P.ProductName,
    P.Stock_Level,
    P.Reorder_Level,
    P.Lead_Time_Days,
    O.Company AS Preferred_Supplier,
    CASE
        WHEN P.Stock_Level <= P.Reorder_Level THEN "Reorder Now"
        ELSE "Safe"
    END AS Order_Status
FROM Products P
JOIN Orders O 
    ON P.Supplier_ID = O.Supplier_ID
WHERE P.Lead_Time_Days = (
    SELECT MIN(P.Lead_Time_Days) 
    FROM Products P 
    WHERE P.Product_ID = P.Product_ID
);
```

### Insights

The dashboard consists of a snapshot of critical metrics including stock status and total revenue  

 ![Supply chain insight](https://github.com/user-attachments/assets/f073eaac-6376-44bd-9471-91bc59365fd3)



The analysis results are summarized as follows:
1. Top 5 products requiring immediate reordering identified.Balanced inventory levels reduce carrying costs while ensuring availability.
2. Trends over time,revealing a consistent inventory supply. There was a spike in the first week of January which could indicate a temporary spike in ordering to meet a specific peak demand.

### Conclusion
- The analysis reveals critical insights into stock levels, supplier performance, and revenue trends.
- Future steps may include building supplier relationships with some suppliers whom products have never been ordered from.

