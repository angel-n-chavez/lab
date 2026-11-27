-- Module 10: Video Game Catalog Report
-- Stop if the database already exists or any statement fails.
-- Do not delete an existing database or rerun the data load.

-- Run this statement by itself.
CREATE DATABASE Module10GameLab;

-- STEP 2: Run only after Section 1 succeeds.
USE Module10GameLab;
CREATE TABLE Games (
    GameID INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Genre VARCHAR(40) NOT NULL,
    Price DECIMAL(5,2) NOT NULL
);

-- STEP 3: Load the catalog once.
INSERT INTO Module10GameLab.Games (GameID, Title, Genre, Price) VALUES
    (1001, 'Star Harbor', 'Adventure', 19.99),
    (1002, 'Dungeon Echo', 'Adventure', 29.99),
    (1003, 'River Quest', 'Adventure', 9.99),
    (1004, 'Turbo Trails', 'Racing', 14.99),
    (1005, 'Drift City', 'Racing', 24.99),
    (1006, 'Star Circuit', 'Racing', 34.99),
    (1007, 'Pixel Garden', 'Simulation', 9.99),
    (1008, 'Moon Workshop', 'Simulation', 19.99),
    (1009, 'Cloud Cafe', 'Simulation', 14.99),
    (1010, 'Crystal Blocks', 'Puzzle', 4.99),
    (1011, 'Logic Lab', 'Puzzle', 9.99),
    (1012, 'Hidden Paths', 'Puzzle', 14.99);
