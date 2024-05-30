-- Drop existing tables if they exist
DROP TABLE IF EXISTS BorrowingTransactions;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS Members;

-- Create Authors table
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL
);

-- Create Members table
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    MemberName VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(255),
    MembershipDate DATE
);

-- Create Books table
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    ISBN VARCHAR(13),
    CopiesAvailable INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Create BorrowingTransactions table
CREATE TABLE BorrowingTransactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    BorrowDate DATE,
    ReturnDate DATE,
    DueDate DATE,
    Fine DECIMAL(5, 2) DEFAULT 0,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Insert sample data into Authors
INSERT INTO Authors (AuthorName)
VALUES
('George Orwell'),
('J.K. Rowling'),
('J.R.R. Tolkien');

-- Insert sample data into Members
INSERT INTO Members (MemberName, ContactInfo, MembershipDate)
VALUES
('Alice Johnson', 'alice.johnson@example.com', '2022-01-15'),
('Bob Brown', 'bob.brown@example.com', '2022-03-22');

-- Insert sample data into Books
INSERT INTO Books (Title, AuthorID, ISBN, CopiesAvailable)
VALUES
('1984', 1, '9780451524935', 5),
('Harry Potter and the Sorcerer''s Stone', 2, '9780590353427', 3),
('The Hobbit', 3, '9780618968633', 2);

-- Insert sample data into BorrowingTransactions
INSERT INTO BorrowingTransactions (MemberID, BookID, BorrowDate, ReturnDate, DueDate, Fine)
VALUES
(1, 1, '2024-05-01', '2024-05-10', '2024-05-08', 2.00),
(2, 2, '2024-05-05', NULL, '2024-05-12', 0.00);

-- Query to add new book
INSERT INTO Books (Title, AuthorID, ISBN, CopiesAvailable)
VALUES ('Animal Farm', 1, '9780451526342', 4);

-- Query to add new member
INSERT INTO Members (MemberName, ContactInfo, MembershipDate)
VALUES ('Charlie Davis', 'charlie.davis@example.com', '2024-05-25');

-- Query to track borrowing and returning of books
SELECT bt.TransactionID, m.MemberName, b.Title, bt.BorrowDate, bt.ReturnDate, bt.DueDate, bt.Fine
FROM BorrowingTransactions bt
JOIN Members m ON bt.MemberID = m.MemberID
JOIN Books b ON bt.BookID = b.BookID;

-- Query to generate overdue reports and fine calculations
SELECT m.MemberName, b.Title, bt.DueDate, DATEDIFF(CURDATE(), bt.DueDate) AS DaysOverdue, bt.Fine
FROM BorrowingTransactions bt
JOIN Members m ON bt.MemberID = m.MemberID
JOIN Books b ON bt.BookID = b.BookID
WHERE bt.ReturnDate IS NULL AND bt.DueDate < CURDATE();

-- Query to get the most borrowed books
SELECT b.Title, COUNT(bt.BookID) AS BorrowCount
FROM BorrowingTransactions bt
JOIN Books b ON bt.BookID = b.BookID
GROUP BY bt.BookID
ORDER BY BorrowCount DESC
LIMIT 5;

-- Query to get the most active members
SELECT m.MemberName, COUNT(bt.MemberID) AS BorrowCount
FROM BorrowingTransactions bt
JOIN Members m ON bt.MemberID = m.MemberID
GROUP BY bt.MemberID
ORDER BY BorrowCount DESC
LIMIT 5;
