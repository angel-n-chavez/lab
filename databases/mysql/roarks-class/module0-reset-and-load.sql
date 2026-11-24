-- Module 9: rerunnable practice database setup
-- WARNING: Every run deletes Module09Practice and all changes made in it.
-- Recreates the seven tables and the original 44 sample rows.
-- Does not target CollegeCourseEnrollment or other module databases.
-- Run this entire file in MySQL Workbench. Stop on any error.

DROP DATABASE IF EXISTS Module09Practice;
CREATE DATABASE Module09Practice;


USE Module09Practice;

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

CREATE TABLE Classrooms (
    ClassroomID INT PRIMARY KEY,
    Building VARCHAR(100) NOT NULL,
    RoomNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL
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

USE Module09Practice;

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
    (731, 'Information Systems'),
    (732, 'Accounting'),
    (733, 'Mathematics');

INSERT INTO Students (StudentID, FirstName, LastName, Email, Major) VALUES
    (73001, 'Amina', 'Shah', 'amina.shah@example.com', 'Information Systems'),
    (73002, 'Ian', 'Bell', 'ian.bell@example.com', 'Accounting'),
    (73003, 'Sofia', 'Ng', 'sofia.ng@example.com', 'Mathematics'),
    (73004, 'Mateo', 'Diaz', 'mateo.diaz@example.com', 'Information Systems'),
    (73005, 'Ruby', 'Fox', 'ruby.fox@example.com', 'Accounting'),
    (73006, 'Eli', 'Grant', 'eli.grant@example.com', NULL),
    (73007, 'Tessa', 'Cole', 'tessa.cole@example.com', 'Mathematics'),
    (73008, 'Dev', 'Patel', 'dev.patel@example.com', NULL);

INSERT INTO Classrooms (ClassroomID, Building, RoomNumber, Capacity) VALUES
    (731, 'Technology Hall', '201', 30),
    (732, 'Business Center', '115', 30),
    (733, 'Science Hall', '310', 35);

INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID) VALUES
    (73111, 'Morgan', 'Lee', 'morgan.lee@example.com', 731),
    (73112, 'Casey', 'Wells', 'casey.wells@example.com', 732),
    (73113, 'Rowan', 'Price', 'rowan.price@example.com', 733),
    (73114, 'Alexis', 'Lane', 'alexis.lane@example.com', NULL);

INSERT INTO Courses (CourseID, CourseCode, CourseTitle, CreditHours, DepartmentID) VALUES
    (73101, 'DB 110', 'Introduction to Databases', 3, 731),
    (73102, 'CIS 101', 'Introduction to Information Systems', 3, 731),
    (73201, 'ACC 101', 'Financial Accounting', 3, 732),
    (73301, 'MAT 120', 'College Algebra', 3, 733),
    (73302, 'STA 101', 'Introduction to Statistics', 3, 733);

INSERT INTO Sections (SectionID, CourseID, InstructorID, ClassroomID, Semester, MeetingDays, StartTime) VALUES
    (73501, 73101, 73111, 731, 'Fall 2026', 'TR', '10:30:00'),
    (73502, 73102, 73111, 731, 'Fall 2026', 'MWF', '09:00:00'),
    (73503, 73201, 73112, 732, 'Fall 2026', 'MWF', '11:00:00'),
    (73504, 73301, 73113, 733, 'Fall 2026', 'TR', '13:00:00'),
    (73505, 73302, 73113, 733, 'Fall 2026', 'MWF', '10:00:00'),
    (73506, 73101, 73111, 731, 'Fall 2026', 'TR', '14:00:00'),
    (83501, 73101, 73111, 731, 'Spring 2027', 'TR', '10:30:00'),
    (83502, 73201, 73112, 732, 'Fall 2026', 'TR', '10:30:00');

INSERT INTO Enrollments (EnrollmentID, StudentID, SectionID, EnrollmentDate, Grade) VALUES
    (73901, 73001, 73501, '2026-08-20', NULL),
    (73902, 73001, 73502, '2026-08-20', NULL),
    (73903, 73002, 73503, '2026-08-21', NULL),
    (73904, 73002, 73504, '2026-08-21', NULL),
    (73905, 73003, 73504, '2026-08-21', NULL),
    (73906, 73003, 73505, '2026-08-21', NULL),
    (73907, 73004, 73501, '2026-08-22', NULL),
    (73908, 73004, 73505, '2026-08-22', NULL),
    (73909, 73005, 73502, '2026-08-22', NULL),
    (73910, 73005, 73503, '2026-08-22', NULL),
    (73911, 73006, 73504, '2026-08-23', NULL),
    (73912, 73007, 73505, '2026-08-23', NULL);

INSERT INTO Courses (CourseID, CourseCode, CourseTitle, CreditHours, DepartmentID) VALUES
    (93103, 'DB 120', 'Database Applications', 3, 731);

