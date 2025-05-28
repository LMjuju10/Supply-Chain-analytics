/*Part 1: Database Design & SQL Queries (MySQL)
Create a database called supply_chain_db in MySQL*/

CREATE DATABASE Supply_Chain_db;

USE Supply_Chain_db;

/*Design and implement tables (products, suppliers, orders)
Insert at least 100 rows per table (Use provided data)*/

-- Checking stock levels and flagging items below reorder levels--


ALTER TABLE Products ADD COLUMN Stock_Status VARCHAR(10);

SET SQL_SAFE_UPDATES = 0;

UPDATE Products
SET Stock_Status = 
    CASE 
        WHEN Stock_Level < ReorderLevel THEN "Trigger"
        ELSE "Safe"
    END;
    
DELIMITER $$

CREATE TRIGGER update_stock_status
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    SET NEW.Stock_Status = 
        CASE 
            WHEN NEW.Stock_Level < NEW.Reorder_Level THEN "Trigger"
            ELSE "Safe"
        END;
END$$

DELIMITER ;
        
-- Finding the top suppliers with the shortest lead times

SELECT Supplier_ID,
AVG(Lead_Time_Days) AS AvgLeadTime_Days
FROM Products
GROUP BY Supplier_ID
ORDER BY AvgLeadTime_Days;

-- Analyzing total order quantities over time


ALTER TABLE Suppliers ADD COLUMN OrderQty_To_Date INT;

SELECT Order_ID, 
       Quantity_Ordered, 
       SUM(Quantity_Ordered) OVER (ORDER BY Order_ID) AS Running_Total
FROM Suppliers;

SET SQL_SAFE_UPDATES = 0;

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




