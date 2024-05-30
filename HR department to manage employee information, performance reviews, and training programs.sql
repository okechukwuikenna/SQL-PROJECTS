-- Drop existing tables if they exist
DROP TABLE IF EXISTS PerformanceReviews;
DROP TABLE IF EXISTS TrainingSessions;
DROP TABLE IF EXISTS EmployeeTrainings;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    JobTitle VARCHAR(100),
    Salary DECIMAL(10, 2),
    DateOfHire DATE,
    LastPromotionDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create PerformanceReviews table
CREATE TABLE PerformanceReviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    ReviewDate DATE,
    ReviewerName VARCHAR(100),
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comments TEXT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Create TrainingSessions table
CREATE TABLE TrainingSessions (
    TrainingID INT AUTO_INCREMENT PRIMARY KEY,
    TrainingName VARCHAR(100) NOT NULL,
    TrainingDate DATE,
    TrainerName VARCHAR(100)
);

-- Create EmployeeTrainings table (to track which employees attended which trainings)
CREATE TABLE EmployeeTrainings (
    EmployeeTrainingID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    TrainingID INT,
    AttendanceDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (TrainingID) REFERENCES TrainingSessions(TrainingID)
);

-- Insert sample data into Departments
INSERT INTO Departments (DepartmentName)
VALUES
('Human Resources'),
('Sales'),
('Development'),
('Marketing');

-- Insert sample data into Employees
INSERT INTO Employees (FirstName, LastName, DepartmentID, JobTitle, Salary, DateOfHire, LastPromotionDate)
VALUES
('John', 'Doe', 1, 'HR Manager', 60000, '2020-01-15', '2023-01-01'),
('Jane', 'Smith', 2, 'Sales Associate', 45000, '2021-06-01', NULL),
('Alice', 'Johnson', 3, 'Software Engineer', 80000, '2019-09-23', '2022-09-01'),
('Bob', 'Brown', 4, 'Marketing Specialist', 50000, '2022-03-15', NULL);

-- Insert sample data into PerformanceReviews
INSERT INTO PerformanceReviews (EmployeeID, ReviewDate, ReviewerName, Rating, Comments)
VALUES
(1, '2023-01-01', 'CEO', 5, 'Excellent leadership and organizational skills.'),
(2, '2023-02-15', 'Sales Manager', 4, 'Good performance, needs improvement in customer relations.'),
(3, '2023-03-20', 'CTO', 5, 'Outstanding technical skills and teamwork.'),
(4, '2023-04-10', 'Marketing Manager', 3, 'Average performance, needs to improve strategic planning.');

-- Insert sample data into TrainingSessions
INSERT INTO TrainingSessions (TrainingName, TrainingDate, TrainerName)
VALUES
('Leadership Training', '2023-05-10', 'Dr. Leadership'),
('Sales Techniques', '2023-06-15', 'Mr. SalesGuru'),
('Advanced Python', '2023-07-20', 'Ms. Pythonista'),
('Digital Marketing', '2023-08-25', 'Mr. DigiMark');

-- Insert sample data into EmployeeTrainings
INSERT INTO EmployeeTrainings (EmployeeID, TrainingID, AttendanceDate)
VALUES
(1, 1, '2023-05-10'),
(2, 2, '2023-06-15'),
(3, 3, '2023-07-20'),
(4, 4, '2023-08-25');

-- Query to track employee performance over time
SELECT e.FirstName, e.LastName, pr.ReviewDate, pr.Rating, pr.Comments
FROM Employees e
JOIN PerformanceReviews pr ON e.EmployeeID = pr.EmployeeID
ORDER BY e.EmployeeID, pr.ReviewDate;

-- Query to generate reports on employee attendance and training completion
SELECT e.FirstName, e.LastName, ts.TrainingName, et.AttendanceDate
FROM EmployeeTrainings et
JOIN Employees e ON et.EmployeeID = e.EmployeeID
JOIN TrainingSessions ts ON et.TrainingID = ts.TrainingID
ORDER BY e.EmployeeID, et.AttendanceDate;

-- Query to calculate salary increments based on performance metrics
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, AVG(pr.Rating) AS AverageRating,
       CASE
           WHEN AVG(pr.Rating) >= 4.5 THEN e.Salary * 0.10
           WHEN AVG(pr.Rating) BETWEEN 3.5 AND 4.4 THEN e.Salary * 0.05
           ELSE 0
       END AS IncrementAmount,
       e.Salary + 
       CASE
           WHEN AVG(pr.Rating) >= 4.5 THEN e.Salary * 0.10
           WHEN AVG(pr.Rating) BETWEEN 3.5 AND 4.4 THEN e.Salary * 0.05
           ELSE 0
       END AS NewSalary
FROM Employees e
JOIN PerformanceReviews pr ON e.EmployeeID = pr.EmployeeID
GROUP BY e.EmployeeID;

-- Query to manage promotions and department transfers
UPDATE Employees
SET JobTitle = 'Senior HR Manager', LastPromotionDate = CURDATE()
WHERE EmployeeID = 1;

UPDATE Employees
SET DepartmentID = 2
WHERE EmployeeID = 3;
