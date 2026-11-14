-- College Course Enrollment System
-- Official course setup script
-- Introduced in Module 1

CREATE DATABASE IF NOT EXISTS CollegeCourseEnrollment;
USE CollegeCourseEnrollment;

CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Major VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE IF NOT EXISTS Courses (
    CourseID INT PRIMARY KEY,
    CourseCode VARCHAR(20) NOT NULL UNIQUE,
    CourseTitle VARCHAR(100) NOT NULL,
    CreditHours INT NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE IF NOT EXISTS Classrooms (
    ClassroomID INT PRIMARY KEY,
    Building VARCHAR(100) NOT NULL,
    RoomNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Sections (
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

CREATE TABLE IF NOT EXISTS Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID)
);

INSERT IGNORE INTO Departments (DepartmentID, DepartmentName) VALUES
    (1, 'Information Systems'),
    (2, 'Accounting'),
    (3, 'Mathematics');

INSERT INTO Students (StudentID, FirstName, LastName, Email, Major) VALUES
    (20261547, 'Sam', 'Read', 'sam.read@meerkat.edu', 'Information Systems'),
    (20261892, 'Cecilia', 'Gushiken', 'cecilia.gushiken@meerkat.edu', 'Accounting'),
    (20262103, 'Kathy', 'Chaney', 'kathy.chaney@meerkat.edu', 'Mathematics'),
    (20262418, 'Noah', 'Williams', 'noah.williams@meerkat.edu', 'Information Systems'),
    (20262735, 'John', 'Smith', 'john.smith@meerkat.edu', 'Accounting')
ON DUPLICATE KEY UPDATE
    FirstName = VALUES(FirstName),
    LastName = VALUES(LastName),
    Email = VALUES(Email),
    Major = VALUES(Major);

INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID) VALUES
    (101, 'Kevin', 'Roark', 'kevin.roark@meerkat.edu', 1),
    (102, 'Mark', 'Chen', 'mark.chen@meerkat.edu', 2),
    (103, 'Alex', 'Thompson', 'alex.thompson@meerkat.edu', 3)
ON DUPLICATE KEY UPDATE
    FirstName = VALUES(FirstName),
    LastName = VALUES(LastName),
    Email = VALUES(Email),
    DepartmentID = VALUES(DepartmentID);

INSERT IGNORE INTO Courses (CourseID, CourseCode, CourseTitle, CreditHours, DepartmentID) VALUES
    (1001, 'CIS 101', 'Introduction to Information Systems', 3, 1),
    (1002, 'DB 110', 'Introduction to Databases', 3, 1),
    (2001, 'ACC 101', 'Financial Accounting', 3, 2),
    (3001, 'MAT 120', 'College Algebra', 3, 3);

INSERT IGNORE INTO Classrooms (ClassroomID, Building, RoomNumber, Capacity) VALUES
    (1, 'Technology Hall', '201', 30),
    (2, 'Business Center', '115', 30),
    (3, 'Science Hall', '310', 35);

INSERT IGNORE INTO Sections (SectionID, CourseID, InstructorID, ClassroomID, Semester, MeetingDays, StartTime) VALUES
    (5001, 1001, 101, 1, 'Fall 2026', 'MWF', '09:00:00'),
    (5002, 1002, 101, 1, 'Fall 2026', 'TR', '10:30:00'),
    (5003, 2001, 102, 2, 'Fall 2026', 'MWF', '11:00:00'),
    (5004, 3001, 103, 3, 'Fall 2026', 'TR', '13:00:00');

INSERT IGNORE INTO Enrollments (EnrollmentID, StudentID, SectionID, EnrollmentDate, Grade) VALUES
    (9001, 20261547, 5001, '2026-08-20', NULL),
    (9002, 20261547, 5002, '2026-08-20', NULL),
    (9003, 20261892, 5003, '2026-08-21', NULL),
    (9004, 20262103, 5004, '2026-08-22', NULL),
    (9005, 20262418, 5001, '2026-08-22', NULL),
    (9006, 20262735, 5003, '2026-08-23', NULL);

SELECT 'College Course Enrollment System is ready!' AS message;
