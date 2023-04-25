
CREATE SCHEMA enrol;
GO

USE University;
GO

CREATE TABLE enrol.Address (
   AddressID INT PRIMARY KEY NOT NULL IDENTITY(1,1), 
   StreetAddress VARCHAR(100) NULL, 
   City VARCHAR(50) NOT NULL, 
   State VARCHAR(50) NULL, 
);
GO

ALTER TABLE Address
ADD CONSTRAINT CHK_Address_StreetAddress CHECK (StreetAddress IS NULL);

ALTER TABLE Address
ADD CONSTRAINT CHK_Address_City CHECK (City IS NOT NULL);

ALTER TABLE Address
ADD CONSTRAINT CHK_Address_State CHECK (State IS NULL);
GO



INSERT INTO enrol.Address (StreetAddress, City, State, PostalCode, Country)
VALUES
 (NULL, 'Grybów', NULL, NULL, 'Poland')
 -- add more values based on your requirement here .......
 ;
  GO



  
CREATE TABLE enrol.Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
    DepartmentName VARCHAR(50) NOT NULL,
    DepartmentDescription VARCHAR(100) NULL,
    DepartmentCapacity INT NOT NULL,
    InsertedOn DATETIME NOT NULL DEFAULT GETDATE()
);
GO




INSERT INTO enrol.Department (DepartmentName, DepartmentDescription, DepartmentCapacity)
VALUES 
('IT','Information Technology', 60),
('EE','Electrical Engineering', 120),
('CSE', 'Computer Science Engineering', 140),
('ME', 'Mechanical Engineering', 110),
('ECE', 'Electronic and Communication Engineering', 80),
('AEIE', 'Applied Electronics and Instrumentation Engineering', 50);
GO




CREATE TABLE enrol.Lecturer (
    LecturerID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED NOT NULL,
    LecturerName VARCHAR(50) NOT NULL,
    LecturerHighestQualification VARCHAR(50) NULL,
    LecturerAge DATE NOT NULL,
    DepartmentID INT NOT NULL,
    InsertedOn DATETIME NULL
);

ALTER TABLE enrol.Lecturer
ADD CONSTRAINT FK_Department_Lecturer FOREIGN KEY (DepartmentID) REFERENCES enrol.Department(DepartmentID);
GO






INSERT INTO enrol.Lecturer(LecturerName, LecturerHighestQualification, LecturerAge, DepartmentID)
VALUES 
('Peder Bernaldez', 'M.Tech', '2010-10-10', 6)
-- add more values based on your requirement here .......
 ;

GO




CREATE TABLE enrol.Student (
  StudentID INT NOT NULL IDENTITY(1,1) PRIMARY KEY CLUSTERED,
  StudentFirstName VARCHAR(50) NOT NULL,
  StudentLastName VARCHAR(50) NULL,
  StudentDOB DATE NOT NULL,
  StudentMobile VARCHAR(20) NULL,
  StudentRollNo INT NOT NULL,
  DepartmentID INT NOT NULL FOREIGN KEY REFERENCES enrol.Department(DepartmentID),
  AddressID INT NOT NULL FOREIGN KEY REFERENCES enrol.Address(AddressID),
  InsertedOn DATETIME NOT NULL DEFAULT GETDATE()
);
GO



INSERT INTO enrol.Student(StudentFirstName, StudentLastName, StudentDOB, StudentMobile, StudentRollNo, DepartmentID, AddressID)
VALUES
('Joey', 'Ironside', '1995-11-22', '1276234258', '1', '3', '1'),
('Karlotta', 'Garraway', '1997-07-06', '2192431615', '2', '3', '24'),
('Jerry', 'Stutte', '1996-12-18', '4125425783', '3', '1', '17'),
('Yehudit', 'Rahill', '1995-01-15', '9939485406', '4', '2', '29'),
('Cele', 'Crosetto', '1998-11-24', '3622733725', '5', '3', '16'),
('Hazlett', 'Mowsdale', '1995-04-09', '1482883476', '6', '4', '23')
-- add more values based on your requirement here .......
 ;
GO


SELECT * FROM enrol.Student;

SELECT * FROM enrol.Department;

SELECT * FROM enrol.Lecturer;

SELECT * FROM enrol.Address;

SELECT CONCAT(StudentFirstName, ' ', StudentLastName) AS StudentFullName, StudentDOB, StudentMobile FROM enrol.Student;

SELECT StudentID, StudentFirstName, StudentLastName, StudentDOB, StudentMobile, StudentRollNo FROM enrol.Student WHERE AddressID = 7;

SELECT * FROM enrol.Student WHERE StudentFirstName LIKE 'B%';

SELECT * FROM enrol.Student WHERE StudentFirstName LIKE 'A%a';

SELECT COUNT(*) FROM enrol.Student WHERE DepartmentID = 6;

SELECT CONCAT(StudentFirstName, ' ', StudentLastName) AS StudentFullName, 
       YEAR(GETDATE()) - YEAR(StudentDOB) - 
         CASE WHEN MONTH(GETDATE()) < MONTH(StudentDOB) 
              OR (MONTH(GETDATE()) = MONTH(StudentDOB) AND DAY(GETDATE()) < DAY(StudentDOB))
              THEN 1 ELSE 0 END AS StudentAge, 
       StudentMobile 
FROM enrol.Student;


SELECT CONCAT(StudentFirstName, ' ', StudentLastName) AS StudentFullName, 
       YEAR(GETDATE()) - YEAR(StudentDOB) - 
         CASE WHEN MONTH(GETDATE()) < MONTH(StudentDOB) 
              OR (MONTH(GETDATE()) = MONTH(StudentDOB) AND DAY(GETDATE()) < DAY(StudentDOB))
              THEN 1 ELSE 0 END AS StudentAge, 
       StudentMobile 
FROM enrol.Student
WHERE YEAR(GETDATE()) - YEAR(StudentDOB) - 
         CASE WHEN MONTH(GETDATE()) < MONTH(StudentDOB) 
              OR (MONTH(GETDATE()) = MONTH(StudentDOB) AND DAY(GETDATE()) < DAY(StudentDOB))
              THEN 1 ELSE 0 END > 23;

SELECT CONCAT(StudentFirstName, ' ', StudentLastName) AS StudentFullName, 
       YEAR(GETDATE()) - YEAR(StudentDOB) - 
         CASE WHEN MONTH(GETDATE()) < MONTH(StudentDOB) 
              OR (MONTH(GETDATE()) = MONTH(StudentDOB) AND DAY(GETDATE()) < DAY(StudentDOB))
              THEN 1 ELSE 0 END AS StudentAge, 
       StudentMobile 
FROM enrol.Student
WHERE YEAR(GETDATE()) - YEAR(StudentDOB) - 
         CASE WHEN MONTH(GETDATE()) < MONTH(StudentDOB) 
              OR (MONTH(GETDATE()) = MONTH(StudentDOB) AND DAY(GETDATE()) < DAY(StudentDOB))
              THEN 1 ELSE 0 END IN (21, 23);


SELECT LecturerID, 
       LecturerName, 
       LecturerHighestQualification, 
       CASE 
          WHEN MONTH(GETDATE()) < MONTH(LecturerAge) 
               OR (MONTH(GETDATE()) = MONTH(LecturerAge) AND DAY(GETDATE()) < DAY(LecturerAge))
          THEN YEAR(GETDATE()) - YEAR(LecturerAge) - 1 
          ELSE YEAR(GETDATE()) - YEAR(LecturerAge) 
       END AS LecturerAge
FROM enrol.Lecturer;


SELECT LecturerID, 
       LecturerName, 
       LecturerHighestQualification, 
       CASE 
          WHEN MONTH(GETDATE()) < MONTH(LecturerAge) 
               OR (MONTH(GETDATE()) = MONTH(LecturerAge) AND DAY(GETDATE()) < DAY(LecturerAge))
          THEN YEAR(GETDATE()) - YEAR(LecturerAge) - 1 
          ELSE YEAR(GETDATE()) - YEAR(LecturerAge) 
       END AS LecturerAge
FROM enrol.Lecturer
WHERE LecturerHighestQualification IN ('MS', 'PhD');

SELECT * FROM enrol.Lecturer WHERE DepartmentID = 2;


SELECT *
FROM enrol.Lecturer
WHERE LecturerName LIKE '%R';

SELECT *
FROM enrol.Lecturer
WHERE LecturerName LIKE 'E%' OR LecturerName LIKE '%E';

SELECT UPPER(LecturerName) AS LecturerName
FROM enrol.Lecturer;

SELECT LEFT(LecturerName, 5) AS LecturerName_5Chars, LecturerID, LecturerHighestQualification
FROM enrol.Lecturer;

SELECT LecturerID, LecturerName, LecturerHighestQualification, 
DATEDIFF(year, LecturerAge, GETDATE()) AS LecturerAge
FROM enrol.Lecturer;

SELECT DepartmentID, DepartmentName, DepartmentDescription, DepartmentCapacity
FROM enrol.Department;

SELECT *
FROM enrol.Department
WHERE DepartmentName = 'ECE';

SELECT DepartmentName, DepartmentDescription, DepartmentCapacity
FROM enrol.Department
WHERE DepartmentCapacity > 60;

SELECT AddressID, StreetAddress, City, State, PostalCode, Country
FROM enrol.Address;

SELECT AddressID, StreetAddress, City, State, PostalCode, Country
FROM enrol.Address
WHERE Country = 'Poland';

SELECT *
FROM enrol.Address
WHERE State IS NULL;

SELECT *
FROM enrol.Address
WHERE PostalCode IS NOT NULL;

SELECT *
FROM enrol.Address
WHERE City = 'Honda' AND Country = 'Colombia';



SELECT DISTINCT StudentDOB FROM enrol.Student;

SELECT DISTINCT DepartmentName FROM enrol.Department;

SELECT DISTINCT Country FROM enrol.Address;

SELECT DISTINCT State FROM enrol.Address;

SELECT DISTINCT City FROM enrol.Address;

SELECT 
    LecturerID, 
    LecturerName, 
    LecturerHighestQualification,
    CASE 
        WHEN LecturerAge IS NULL THEN NULL
        ELSE YEAR(GETDATE()) - YEAR(CONVERT(date, LecturerAge, 103))
    END AS LecturerYearService
FROM enrol.Lecturer;

SELECT LecturerID, LecturerName, LecturerHighestQualification, 
       CASE
           WHEN DATEDIFF(year, LecturerAge, GETDATE()) < 5 THEN 'Beginning Level Experience'
           WHEN DATEDIFF(year, LecturerAge, GETDATE()) >= 5 AND DATEDIFF(year, LecturerAge, GETDATE()) < 10 THEN 'Mid Level Experience'
           ELSE 'Experienced'
       END AS LecturerType
FROM enrol.Lecturer;



SELECT CONCAT(StudentFirstName, ' ', StudentLastName) AS StudentName, DepartmentName
FROM enrol.Student
INNER JOIN enrol.Department ON enrol.Student.DepartmentID = enrol.Department.DepartmentID;

SELECT CONCAT(StudentFirstName, ' ', StudentLastName) AS StudentName, StreetAddress, City, State, Country
FROM enrol.Student
INNER JOIN enrol.Address ON enrol.Student.AddressID = enrol.Address.AddressID;

SELECT 
    d.DepartmentName, 
    l.LecturerName, 
    l.LecturerAge, 
    CASE 
        WHEN YEAR(GETDATE()) - YEAR(CONVERT(date, l.LecturerAge, 103)) <= 5 THEN 'Junior Lecturer'
        WHEN YEAR(GETDATE()) - YEAR(CONVERT(date, l.LecturerAge, 103)) <= 10 THEN 'Lecturer'
        ELSE 'Senior Lecturer'
    END AS LecturerType,
    l.LecturerHighestQualification,
    YEAR(GETDATE()) - YEAR(CONVERT(date, l.LecturerAge, 103)) AS LecturerYearService
FROM enrol.Department d
INNER JOIN enrol.Lecturer l ON d.DepartmentID = l.DepartmentID;

SELECT 
    CONCAT(s.StudentFirstName, ' ', s.StudentLastName) AS StudentName, 
    d.DepartmentName,
    l.LecturerName,
    l.LecturerAge,
    CASE 
        WHEN YEAR(GETDATE()) - YEAR(CONVERT(date, l.LecturerAge, 103)) <= 5 THEN 'Junior Lecturer'
        WHEN YEAR(GETDATE()) - YEAR(CONVERT(date, l.LecturerAge, 103)) <= 10 THEN 'Lecturer'
        ELSE 'Senior Lecturer'
    END AS LecturerType,
    l.LecturerHighestQualification,
    DATEDIFF(year, l.LecturerAge, GETDATE()) - 
        CASE 
            WHEN MONTH(l.LecturerAge) > MONTH(GETDATE()) OR (MONTH(l.LecturerAge) = MONTH(GETDATE()) AND DAY(l.LecturerAge) > DAY(GETDATE())) THEN 1
            ELSE 0
        END AS LecturerYearService
FROM enrol.Department d
INNER JOIN enrol.Student s ON d.DepartmentID = s.DepartmentID
INNER JOIN enrol.Lecturer l ON d.DepartmentID = l.DepartmentID;


SELECT CONCAT(StudentFirstName, ' ', StudentLastName) AS StudentName, StreetAddress, City, State, Country, DepartmentName
FROM enrol.Student
INNER JOIN enrol.Address ON enrol.Student.AddressID = enrol.Address.AddressID
INNER JOIN enrol.Department ON enrol.Student.DepartmentID = enrol.Department.DepartmentID;

SELECT 
    CONCAT(s.StudentFirstName, ' ', s.StudentLastName) AS StudentName, 
    a.StreetAddress, 
    a.City, 
    a.State, 
    a.Country, 
    d.DepartmentName, 
    l.LecturerName, 
    l.LecturerAge, 
    CASE 
        WHEN DATEDIFF(YEAR, l.LecturerAge, GETDATE()) < 5 THEN 'Junior Lecturer'
        WHEN DATEDIFF(YEAR, l.LecturerAge, GETDATE()) BETWEEN 5 AND 15 THEN 'Lecturer'
        ELSE 'Senior Lecturer'
    END AS LecturerType,
    l.LecturerHighestQualification, 
    DATEDIFF(YEAR, l.LecturerAge, GETDATE()) - 
        CASE 
            WHEN MONTH(l.LecturerAge) > MONTH(GETDATE()) OR 
                (MONTH(l.LecturerAge) = MONTH(GETDATE()) AND DAY(l.LecturerAge) > DAY(GETDATE())) 
            THEN 1 
            ELSE 0 
        END AS LecturerYearService
FROM enrol.Student s
JOIN enrol.Department d ON s.DepartmentID = d.DepartmentID
JOIN enrol.Lecturer l ON d.DepartmentID = l.DepartmentID
JOIN Address a ON s.AddressID = a.AddressID;

SELECT 
    CONCAT(s.StudentFirstName, ' ', s.StudentLastName) AS StudentName, 
    a.StreetAddress, 
    a.City, 
    a.State, 
    a.Country, 
    d.DepartmentName, 
    l.LecturerName, 
    l.LecturerAge, 
    CASE 
        WHEN DATEDIFF(YEAR, l.LecturerAge, GETDATE()) < 5 THEN 'Junior Lecturer'
        WHEN DATEDIFF(YEAR, l.LecturerAge, GETDATE()) BETWEEN 5 AND 15 THEN 'Lecturer'
        ELSE 'Senior Lecturer'
    END AS LecturerType,
    l.LecturerHighestQualification, 
    DATEDIFF(YEAR, l.LecturerAge, GETDATE()) - 
        CASE 
            WHEN MONTH(l.LecturerAge) > MONTH(GETDATE()) OR 
                (MONTH(l.LecturerAge) = MONTH(GETDATE()) AND DAY(l.LecturerAge) > DAY(GETDATE())) 
            THEN 1 
            ELSE 0 
        END AS LecturerYearService
FROM enrol.Student s
JOIN enrol.Department d ON s.DepartmentID = d.DepartmentID
JOIN enrol.Lecturer l ON d.DepartmentID = l.DepartmentID
JOIN Address a ON s.AddressID = a.AddressID
WHERE DepartmentName IN ('ME', 'ECE');

SELECT 
    CONCAT(s.StudentFirstName, ' ', s.StudentLastName) AS StudentName, 
    a.StreetAddress, 
    a.City, 
    a.State, 
    a.Country, 
    d.DepartmentName, 
    l.LecturerName, 
    l.LecturerAge, 
    CASE 
        WHEN DATEDIFF(YEAR, l.LecturerAge, GETDATE()) < 5 THEN 'Junior Lecturer'
        WHEN DATEDIFF(YEAR, l.LecturerAge, GETDATE()) BETWEEN 5 AND 15 THEN 'Lecturer'
        ELSE 'Senior Lecturer'
    END AS LecturerType,
    l.LecturerHighestQualification, 
    DATEDIFF(YEAR, l.LecturerAge, GETDATE()) - 
        CASE 
            WHEN MONTH(l.LecturerAge) > MONTH(GETDATE()) OR 
                (MONTH(l.LecturerAge) = MONTH(GETDATE()) AND DAY(l.LecturerAge) > DAY(GETDATE())) 
            THEN 1 
            ELSE 0 
        END AS LecturerYearService
FROM enrol.Student s
JOIN enrol.Department d ON s.DepartmentID = d.DepartmentID
JOIN enrol.Lecturer l ON d.DepartmentID = l.DepartmentID
JOIN Address a ON s.AddressID = a.AddressID
WHERE LecturerHighestQualification IN ('MS', 'PhD');



SELECT s.StudentID, s.StudentFirstName, s.StudentDOB, d.DepartmentName, a.StreetAddress, a.City, a.State, a.Country 
FROM enrol.Student s
INNER JOIN enrol.Department d ON s.DepartmentID = d.DepartmentID
INNER JOIN enrol.Address a ON s.AddressID = a.AddressID
WHERE a.Country = 'Thailand';


SELECT d.DepartmentName, COUNT(s.StudentID) AS NumOfStudents
FROM enrol.Student s
INNER JOIN enrol.Department d ON s.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

SELECT d.DepartmentName, COUNT(l.LecturerID) AS NumOfLecturers
FROM enrol.Lecturer l
INNER JOIN enrol.Department d ON l.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;

SELECT a.Country, COUNT(s.StudentID) AS NumOfStudents
FROM enrol.Student s
INNER JOIN enrol.Address a ON s.AddressID = a.AddressID
GROUP BY a.Country;

SELECT * INTO enrol.StudCopy FROM enrol.Student;

SELECT *
INTO enrol.DeptCopy
FROM enrol.Department
WHERE 1 = 0;


SELECT * INTO enrol.DepartmentCopy FROM enrol.Department;

SELECT *
INTO enrol.AddrCopy
FROM enrol.Address
WHERE 1 = 0;



SELECT * INTO enrol.AddrCopy FROM enrol.Address;


SELECT * INTO enrol.LecturerCopy FROM enrol.Lecturer;



DELETE FROM enrol.LecturerCopy;

DELETE FROM enrol.Student
WHERE DepartmentID = (SELECT DepartmentID FROM enrol.Department WHERE DepartmentName = 'IT');

DELETE FROM enrol.Student
WHERE AddressID IN (SELECT AddressID FROM enrol.Address WHERE Country = 'Indonesia');


DELETE FROM enrol.Student
WHERE AddressID IN (SELECT AddressID FROM enrol.Address WHERE City = 'Nanshi');

DELETE FROM enrol.Student
WHERE AddressID IN (SELECT AddressID FROM enrol.Address WHERE State = 'Bretagne');



UPDATE enrol.Student 
SET StudentMobile = '9876543210' 
WHERE DepartmentID IN (SELECT DepartmentID FROM enrol.Department WHERE DepartmentName = 'ME');

UPDATE enrol.Student 
SET DepartmentID = 3 
WHERE StudentID = 42;

UPDATE enrol.Lecturer 
SET LecturerHighestQualification = 'PHd' 
WHERE LecturerHighestQualification = 'PhD';



UPDATE enrol.Address 
SET PostalCode = '00000' 
WHERE PostalCode IS NULL;

UPDATE enrol.Student 
SET StudentLastName = 'Paul' 
WHERE StudentFirstName = 'Jerry';






