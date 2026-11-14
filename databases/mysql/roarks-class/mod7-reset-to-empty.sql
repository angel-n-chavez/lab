-- Module 7: Reset to Empty Tables
-- WARNING: This permanently deletes Module07Demo and all its practice data.
-- Run the entire file to recreate its seven tables WITHOUT loading records.
-- CollegeCourseEnrollment and other databases are not changed.
-- Stop on any SQL error before continuing with the lesson.
-- Use this starting state for Adding Rows with INSERT.

DROP DATABASE IF EXISTS Module07Demo;
CREATE DATABASE Module07Demo;
USE Module07Demo;
SELECT DATABASE() AS PracticeDatabase;

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

-- Verify: seven tables, each with zero rows.
SHOW TABLES;

SELECT 'Departments' AS TableName, COUNT(*) AS RowCount FROM Departments
UNION ALL SELECT 'Students', COUNT(*) FROM Students
UNION ALL SELECT 'Classrooms', COUNT(*) FROM Classrooms
UNION ALL SELECT 'Instructors', COUNT(*) FROM Instructors
UNION ALL SELECT 'Courses', COUNT(*) FROM Courses
UNION ALL SELECT 'Sections', COUNT(*) FROM Sections
UNION ALL SELECT 'Enrollments', COUNT(*) FROM Enrollments;

-- Recording checkpoint: column headings with no student rows.
SELECT StudentID, FirstName, LastName, Email, Major
FROM Students
ORDER BY StudentID;

