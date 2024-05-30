-- Drop existing tables if they exist
DROP TABLE IF EXISTS MedicalRecords;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;

-- Create Patients table
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    Gender VARCHAR(10),
    ContactInfo VARCHAR(255),
    Address TEXT
);

-- Create Doctors table
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100),
    ContactInfo VARCHAR(255)
);

-- Create Appointments table
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME,
    Status VARCHAR(50),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Create MedicalRecords table
CREATE TABLE MedicalRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    VisitDate DATE,
    Diagnosis TEXT,
    Treatment TEXT,
    Prescription TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Insert sample data into Patients
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, ContactInfo, Address)
VALUES
('John', 'Doe', '1980-01-01', 'Male', 'john.doe@example.com', '123 Elm Street'),
('Jane', 'Smith', '1990-02-15', 'Female', 'jane.smith@example.com', '456 Oak Avenue');

-- Insert sample data into Doctors
INSERT INTO Doctors (FirstName, LastName, Specialization, ContactInfo)
VALUES
('Alice', 'Johnson', 'Cardiology', 'alice.johnson@hospital.com'),
('Bob', 'Brown', 'Dermatology', 'bob.brown@hospital.com');

-- Insert sample data into Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Status)
VALUES
(1, 1, '2024-05-10 09:00:00', 'Scheduled'),
(2, 2, '2024-05-11 10:00:00', 'Completed');

-- Insert sample data into MedicalRecords
INSERT INTO MedicalRecords (PatientID, DoctorID, VisitDate, Diagnosis, Treatment, Prescription)
VALUES
(1, 1, '2024-05-10', 'Hypertension', 'Lifestyle changes', 'Amlodipine'),
(2, 2, '2024-05-11', 'Acne', 'Topical treatment', 'Benzoyl peroxide');

-- Query to track patient visits and medical history
SELECT p.FirstName, p.LastName, mr.VisitDate, d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName, mr.Diagnosis, mr.Treatment, mr.Prescription
FROM MedicalRecords mr
JOIN Patients p ON mr.PatientID = p.PatientID
JOIN Doctors d ON mr.DoctorID = d.DoctorID
ORDER BY mr.VisitDate;

-- Query to generate reports on patient demographics
SELECT Gender, COUNT(*) AS Total
FROM Patients
GROUP BY Gender;

-- Query to generate reports on treatment outcomes
SELECT mr.Diagnosis, COUNT(*) AS TotalPatients, COUNT(CASE WHEN mr.Treatment IS NOT NULL THEN 1 END) AS Treated
FROM MedicalRecords mr
GROUP BY mr.Diagnosis;

-- Query to manage appointments (e.g., list upcoming appointments)
SELECT p.FirstName, p.LastName, d.FirstName AS DoctorFirstName, d.LastName AS DoctorLastName, a.AppointmentDate, a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE a.Status = 'Scheduled'
ORDER BY a.AppointmentDate;

-- Query to reschedule an appointment
UPDATE Appointments
SET AppointmentDate = '2024-06-15 11:00:00'
WHERE AppointmentID = 1;

-- Query to cancel an appointment
UPDATE Appointments
SET Status = 'Cancelled'
WHERE AppointmentID = 2;

-- Ensure data privacy and security with appropriate access controls
-- Create a new user with limited privileges
CREATE USER 'healthcare_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE ON healthcare_db.* TO 'healthcare_user'@'localhost';
FLUSH PRIVILEGES;
