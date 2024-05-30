-- Drop existing tables if they exist
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Users;

-- Create Users table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    RegistrationDate DATE,
    Country VARCHAR(50)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    StockQuantity INT
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create OrderDetails table (to capture details of each order)
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Reviews table
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    UserID INT,
    ReviewDate DATE,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Load data from CSV files
-- Ensure that the files are placed in the correct directory and accessible to MySQL server

-- LOAD DATA INFILE '/path/to/users.csv'
-- INTO TABLE Users
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- LOAD DATA INFILE '/path/to/products.csv'
-- INTO TABLE Products
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- LOAD DATA INFILE '/path/to/orders.csv'
-- INTO TABLE Orders
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- LOAD DATA INFILE '/path/to/orderdetails.csv'
-- INTO TABLE OrderDetails
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- LOAD DATA INFILE '/path/to/reviews.csv'
-- INTO TABLE Reviews
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- Example data insertion for demonstration purposes
INSERT INTO Users (UserName, Email, RegistrationDate, Country)
VALUES
('Alice Johnson', 'alice.j@example.com', '2022-01-15', 'USA'),
('Bob Brown', 'bob.b@example.com', '2022-02-10', 'UK'),
('Charlie Davis', 'charlie.d@example.com', '2022-03-05', 'Canada');

INSERT INTO Products (ProductName, Category, Price, StockQuantity)
VALUES
('Widget A', 'Widgets', 19.99, 100),
('Widget B', 'Widgets', 29.99, 50),
('Gadget X', 'Gadgets', 99.99, 20);

INSERT INTO Orders (UserID, OrderDate, TotalAmount)
VALUES
(1, '2023-01-01', 39.98),
(2, '2023-01-15', 29.99),
(3, '2023-02-20', 99.99);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
VALUES
(1, 1, 2, 19.99),
(2, 2, 1, 29.99),
(3, 3, 1, 99.99);

INSERT INTO Reviews (ProductID, UserID, ReviewDate, Rating, Comment)
VALUES
(1, 1, '2023-01-10', 4, 'Good quality!'),
(2, 2, '2023-01-20', 5, 'Excellent product!'),
(3, 3, '2023-02-25', 3, 'Average.');

-- Query to analyze sales trends
SELECT OrderDate, SUM(TotalAmount) AS DailySales
FROM Orders
GROUP BY OrderDate
ORDER BY OrderDate;

-- Query to analyze customer behavior
SELECT u.UserName, u.Email, COUNT(o.OrderID) AS TotalOrders, SUM(o.TotalAmount) AS TotalSpent
FROM Users u
JOIN Orders o ON u.UserID = o.UserID
GROUP BY u.UserID
ORDER BY TotalSpent DESC;

-- Query to generate reports on product performance
SELECT p.ProductName, COUNT(od.OrderID) AS TotalOrders, SUM(od.Quantity) AS TotalQuantitySold, SUM(od.Price * od.Quantity) AS TotalRevenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID
ORDER BY TotalRevenue DESC;

-- Query to generate customer segmentation
SELECT u.Country, COUNT(u.UserID) AS TotalCustomers, SUM(o.TotalAmount) AS TotalRevenue
FROM Users u
JOIN Orders o ON u.UserID = o.UserID
GROUP BY u.Country
ORDER BY TotalRevenue DESC;

-- Query to implement recommendations for improving sales
-- Recommend top 5 products based on sales
SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantitySold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID
ORDER BY TotalQuantitySold DESC
LIMIT 5;

-- Recommend top 5 customers based on total spending
SELECT u.UserName, u.Email, SUM(o.TotalAmount) AS TotalSpent
FROM Users u
JOIN Orders o ON u.UserID = o.UserID
GROUP BY u.UserID
ORDER BY TotalSpent DESC
LIMIT 5;

-- Query to recommend potential sales regions based on customer segmentation
SELECT u.Country, COUNT(u.UserID) AS TotalCustomers, SUM(o.TotalAmount) AS TotalRevenue
FROM Users u
JOIN Orders o ON u.UserID = o.UserID
GROUP BY u.Country
ORDER BY TotalRevenue DESC
LIMIT 5;
