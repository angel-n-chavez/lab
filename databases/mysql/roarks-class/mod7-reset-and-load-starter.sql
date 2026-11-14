-- Module 7: Reset and Load Starter Database
-- WARNING: Running this entire file permanently deletes Module07Demo,
-- including all changes made during practice, and restores the starting data.
-- Only Module07Demo is reset. CollegeCourseEnrollment and other databases
-- are not changed. Run the whole file to restart; stop on any SQL error.
-- This loads the INSERT examples too; begin maintenance with 03-Correct-Email.sql.
-- Do not rerun 02-Load-Starting-Rows.sql after this starter.

DROP DATABASE IF EXISTS Module07Demo;
CREATE DATABASE Module07Demo;
USE Module07Demo;
SELECT DATABASE() AS PracticeDatabase;

-- STEP 1: Create the seven empty tables.

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Major VARCHAR(100)
);

CREATE TABLE Classrooms (
    ClassroomID INT PRIMARY KEY,
    Building VARCHAR(100) NOT NULL,
    RoomNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseCode VARCHAR(20) NOT NULL UNIQUE,
    CourseTitle VARCHAR(100) NOT NULL,
    CreditHours INT NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Sections (
    SectionID INT PRIMARY KEY,
    CourseID INT NOT NULL,
    InstructorID INT NOT NULL,
    ClassroomID INT NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    MeetingDays VARCHAR(20) NOT NULL,
    StartTime TIME NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
    FOREIGN KEY (ClassroomID) REFERENCES Classrooms(ClassroomID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID)
);

-- STEP 2: Load the original fictional practice records.

INSERT INTO Students
    (StudentID, FirstName, LastName, Email, Major)
VALUES
    (71001, 'Maya', 'Ortiz', 'maya.ortiz@example.com', NULL);


INSERT INTO Students
    (StudentID, FirstName, LastName, Email, Major)
VALUES
    (71002, 'Leo', 'Park', 'leo.park@example.com', 'Information Systems'),
    (71999, 'Test', 'Record', 'test.record@example.com', NULL);


SELECT StudentID, FirstName, LastName, Email, Major
FROM Students
ORDER BY StudentID;


INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (701, 'Information Systems');

INSERT INTO Classrooms (ClassroomID, Building, RoomNumber, Capacity)
VALUES (701, 'Technology Hall', '201', 30);

INSERT INTO Instructors
    (InstructorID, FirstName, LastName, Email, DepartmentID)
VALUES (70101, 'Avery', 'Chen', 'avery.chen@example.com', 701);

INSERT INTO Courses
    (CourseID, CourseCode, CourseTitle, CreditHours, DepartmentID)
VALUES
    (7101, 'DB 110', 'Introduction to Databases', 3, 701),
    (7102, 'CIS 101', 'Introduction to Information Systems', 3, 701);

INSERT INTO Sections
    (SectionID, CourseID, InstructorID, ClassroomID,
     Semester, MeetingDays, StartTime)
VALUES
    (75001, 7101, 70101, 701, 'Fall 2026', 'MWF', '09:00:00'),
    (75002, 7102, 70101, 701, 'Fall 2026', 'TR', '10:30:00');


SELECT StudentID, FirstName, LastName
FROM Students
WHERE StudentID = 71001;

SELECT SectionID, CourseID, Semester, MeetingDays, StartTime
FROM Sections
ORDER BY SectionID;


INSERT INTO Enrollments
    (EnrollmentID, StudentID, SectionID, EnrollmentDate, Grade)
VALUES
    (79001, 71001, 75001, '2026-08-24', NULL),
    (79002, 71001, 75002, '2026-08-24', NULL);

SELECT EnrollmentID, StudentID, SectionID, EnrollmentDate, Grade
FROM Enrollments
ORDER BY EnrollmentID;


-- STEP 3: Verify the restored starting counts (12 rows total).
SELECT 'Departments' AS TableName, COUNT(*) AS RowCount FROM Departments
UNION ALL SELECT 'Students', COUNT(*) FROM Students
UNION ALL SELECT 'Classrooms', COUNT(*) FROM Classrooms
UNION ALL SELECT 'Instructors', COUNT(*) FROM Instructors
UNION ALL SELECT 'Courses', COUNT(*) FROM Courses
UNION ALL SELECT 'Sections', COUNT(*) FROM Sections
UNION ALL SELECT 'Enrollments', COUNT(*) FROM Enrollments;
-- Expected: Departments 1; Students 3; Classrooms 1; Instructors 1;
-- Courses 2; Sections 2; Enrollments 2.
