-- Complete baseline structure in a separate practice database.
-- This script creates empty tables; it does not load course records.
CREATE DATABASE Module06Enrollment;
USE Module06Enrollment;

-- Tables with no parent references
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

-- Tables that reference Departments
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

-- Sections requires Courses, Instructors, and Classrooms
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

-- Enrollments requires Students and Sections
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    SectionID INT NOT NULL,
    EnrollmentDate DATE NOT NULL,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID)
);
