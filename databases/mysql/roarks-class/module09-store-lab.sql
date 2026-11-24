-- Stop if the database already exists or any statement fails.
-- Do not delete an existing database or rerun the data load.

-- Section 1: Create the practice database. Run this statement by itself.
CREATE DATABASE Module09StoreLab;

-- Section 2: Create the tables only after Section 1 succeeds.
USE Module09StoreLab;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    QuantitySold INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

-- Section 3: Load the sample data once.
INSERT INTO Module09StoreLab.Products (ProductID, ProductName) VALUES
    (701, 'Notebook'),
    (702, 'Water Bottle'),
    (703, 'Desk Lamp'),
    (704, 'Pencil Case');

INSERT INTO Module09StoreLab.Sales (SaleID, ProductID, QuantitySold) VALUES
    (1, 701, 2),
    (2, 701, 1),
    (3, 702, 3),
    (4, 703, 1);

-- Section 4: Verify setup. Each query should return four rows.
SELECT * FROM Module09StoreLab.Products ORDER BY ProductID;
SELECT * FROM Module09StoreLab.Sales ORDER BY SaleID;
