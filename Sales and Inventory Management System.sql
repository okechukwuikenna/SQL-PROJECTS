-- Drop existing tables if they exist
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Suppliers;

-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(100),
    Country VARCHAR(100),
    Phone VARCHAR(20)
);

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(100),
    Country VARCHAR(100),
    Phone VARCHAR(20),
    LoyaltyPoints INT DEFAULT 0
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    Category VARCHAR(50),
    UnitPrice DECIMAL(10, 2),
    UnitsInStock INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Create Inventory table
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Sales table
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    SaleDate DATE,
    Quantity INT,
    TotalPrice DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample data into Suppliers
INSERT INTO Suppliers (SupplierName, ContactName, Address, City, Country, Phone)
VALUES
('ABC Supplies', 'John Doe', '123 Elm St', 'Springfield', 'USA', '555-1234'),
('XYZ Wholesale', 'Jane Smith', '456 Oak St', 'Metropolis', 'USA', '555-5678');

-- Insert sample data into Products
INSERT INTO Products (ProductName, SupplierID, Category, UnitPrice, UnitsInStock)
VALUES
('Widget A', 1, 'Widgets', 19.99, 100),
('Widget B', 1, 'Widgets', 29.99, 50),
('Gadget X', 2, 'Gadgets', 99.99, 20),
('Gadget Y', 2, 'Gadgets', 149.99, 30);

-- Insert sample data into Customers
INSERT INTO Customers (CustomerName, ContactName, Address, City, Country, Phone, LoyaltyPoints)
VALUES
('Alice Johnson', 'Alice', '789 Pine St', 'Gotham', 'USA', '555-8765', 100),
('Bob Brown', 'Bob', '321 Cedar St', 'Star City', 'USA', '555-4321', 200);

-- Insert sample data into Sales
INSERT INTO Sales (CustomerID, ProductID, SaleDate, Quantity, TotalPrice)
VALUES
(1, 1, '2024-05-20', 2, 39.98),
(1, 2, '2024-05-21', 1, 29.99),
(2, 3, '2024-05-22', 3, 299.97),
(2, 4, '2024-05-23', 1, 149.99);

-- Insert sample data into Inventory
INSERT INTO Inventory (ProductID, Quantity)
VALUES
(1, 98),
(2, 49),
(3, 17),
(4, 29);

-- Query to track inventory levels
SELECT p.ProductName, i.Quantity
FROM Products p
JOIN Inventory i ON p.ProductID = i.ProductID;

-- Query to generate daily sales report
SELECT SaleDate, SUM(TotalPrice) AS DailySales
FROM Sales
GROUP BY SaleDate;

-- Query to generate weekly sales report
SELECT YEAR(SaleDate) AS Year, WEEK(SaleDate) AS Week, SUM(TotalPrice) AS WeeklySales
FROM Sales
GROUP BY YEAR(SaleDate), WEEK(SaleDate);

-- Query to generate monthly sales report
SELECT YEAR(SaleDate) AS Year, MONTH(SaleDate) AS Month, SUM(TotalPrice) AS MonthlySales
FROM Sales
GROUP BY YEAR(SaleDate), MONTH(SaleDate);

-- Query to track customer loyalty points
SELECT CustomerName, LoyaltyPoints
FROM Customers;

-- Query to manage supplier information and orders
SELECT s.SupplierName, p.ProductName, p.UnitPrice, p.UnitsInStock
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID;

