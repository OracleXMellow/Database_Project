-- Database creation along with files
CREATE DATABASE MikesSneakerOutlet
ON PRIMARY 
( 
	NAME = MikesSneakerOutlet_data,
	FILENAME = 'C:\Data\MikesSneakerOutlet_data.mdf',
	SIZE = 100MB, 
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10% 
)

LOG ON 
( 
	NAME = MikesSneakerOutlet_LOG, 
	FILENAME = 'C:\Data\MikesSneakerOutlet_log.ldf', 
	SIZE = 10MB, 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 500MB 
);

GO

-- Database usage
USE MikesSneakerOutlet;
GO

-- Including the scondary filegroup and it's respective file
ALTER DATABASE MikesSneakerOutlet
ADD FILEGROUP Secondary;

GO

ALTER DATABASE MikesSneakerOutlet
ADD FILE
(
	NAME = MikesSneakerOutlet_data2,
	FILENAME = 'C:\Data\MikesSneakerOutlet_data2.ndf',
	SIZE = 5MB, 
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10% 
)
TO FILEGROUP Secondary;

GO

-- TABLE CREATION SCRIPTS

-- Customer table creation
CREATE TABLE Customer 
( 
	CustomerID CHAR(5) PRIMARY KEY, 
	CustomerName VARCHAR(60) NOT NULL, 
	Address VARCHAR(60), 
	Phone CHAR(24) UNIQUE
);

GO

-- Supplier table creation
CREATE TABLE Supplier 
( 
	SupplierID CHAR(5) PRIMARY KEY, 
	SupplierName VARCHAR(40) NOT NULL, 
	Location VARCHAR(60) DEFAULT 'Cape Town', 
	PhoneNumber CHAR(24) UNIQUE
);

GO

-- Distributor table creation
CREATE TABLE Distributor 
( 
	DistributorID CHAR(5) NOT NULL PRIMARY KEY, 
	DistributorName VARCHAR(40) NOT NULL, 
	DistributorSurname VARCHAR(40) NOT NULL, 
	Address VARCHAR (60), 
	PhoneNumber CHAR (24) UNIQUE, 
	YearJoined DATETIME DEFAULT GETDATE(), 
	CustomerID CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID) 
);

GO

-- Product table creation
CREATE TABLE Product 
( 
	ProductID CHAR(5) PRIMARY KEY, 
	ProdctName VARCHAR(40) NOT NULL, 
	ProductType VARCHAR(40) NOT NULL, 
	ProductPrice MONEY NOT NULL, 
	SupplierID CHAR(5) FOREIGN KEY REFERENCES Supplier(SupplierID) 
);

GO

-- SneakerOrder table creation
CREATE TABLE SneakerOrder 
( 
	OrderID INT IDENTITY(1001,1) PRIMARY KEY, 
	CustomerID CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID ), 
	OrderDate DATETIME NULL, 
	SupplierID CHAR(5) FOREIGN KEY REFERENCES Supplier(SupplierID), 
	DistributorID CHAR(5) FOREIGN KEY REFERENCES Distributor(DistributorID), 
	ProductID CHAR(5) FOREIGN KEY REFERENCES Product(ProductID) 
);

GO

-- Employee table creation
CREATE TABLE Employee 
( 
	EmployeeID CHAR(5) NOT NULL PRIMARY KEY, 
	EmployeeName VARCHAR(40) NOT NULL, 
	EmployeeSurname VARCHAR(40) NOT NULL, 
	JobDescription VARCHAR(40) DEFAULT 'Salesman', 
	Salary MONEY DEFAULT 2000.00, 
	PhoneNumber CHAR(10) UNIQUE
);

GO

-- Sales table creation
CREATE TABLE Sale 
( 
	SaleNumber INT IDENTITY(10,10) PRIMARY KEY, 
	Price MONEY, 
	CustomerID CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID), 
	EmployeeID CHAR(5)FOREIGN KEY REFERENCES Employee(EmployeeID), 
	ProductID CHAR(5) FOREIGN KEY REFERENCES Product(ProductID) 
);

GO

-- OrderDetails table creation
CREATE TABLE OrderDetails 
( 
	OrderID INT FOREIGN KEY REFERENCES SneakerOrder(OrderID), 
	OrderPrice MONEY, 
	Discount REAL NOT NULL, 
	ProductID CHAR(5) FOREIGN KEY REFERENCES Product(ProductID) 
);

GO

-- Invoice table creation
CREATE TABLE Invoice 
( 
	InvoiceID INT IDENTITY(5001,2)  PRIMARY KEY, 
	InvoiceDate DATETIME DEFAULT GETDATE(), 
	CustomerID CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID ), 
	DistributorID CHAR(5)FOREIGN KEY REFERENCES Distributor(DistributorID) 
);

GO

-- PopUpStand table creation
CREATE TABLE PopUpStand 
( 
	StandID INT IDENTITY(1,1) PRIMARY KEY, 
	Location VARCHAR(20), 
	EmployeeID CHAR(5)FOREIGN KEY REFERENCES Employee(EmployeeID), 
	ProductID CHAR(5) FOREIGN KEY REFERENCES Product(ProductID) 
);
 
GO

-- INDEXES

CREATE NONCLUSTERED INDEX IN_Name
ON Customer(CustomerName);

CREATE NONCLUSTERED INDEX IN_Product
ON Product(ProdctName, ProductType);

GO

-- DATA INSERTION SCRIPTS

-- Inserting data for customers
INSERT INTO Customer 
	(CustomerID, CustomerName, Address, Phone) 
VALUES 
	('C0001', 'Emma Johnson', '123 Street, City A', '123-456-7890'),
	('C0002', 'Michael Smith', '456 Avenue, City B', '234-567-8901'),
	('C0003', 'Olivia Williams', '789 Road, City C', '345-678-9012'),
	('C0004', 'Ethan Brown', '111 Lane, City D', '456-789-0123'),
	('C0005', 'Ava Jones', '222 Drive, City E', '567-890-1234'),
	('C0006', 'William Davis', '333 Boulevard, City F', '678-901-2345'),
	('C0007', 'Sophia Miller', '444 Place, City G', '789-012-3456'),
	('C0008', 'James Wilson', '555 Court, City H', '890-123-4567'),
	('C0009', 'Isabella Moore', '666 Terrace, City I', '901-234-5678'),
	('C0010', 'Benjamin Taylor', '777 Circle, City J', '022-325-6729'),
	('C0011', 'Mia Anderson', '888 Park, City K', '143-453-7890'),
	('C0012', 'Jacob Thomas', '999 Square, City L', '262-567-8901'),
	('C0013', 'Charlotte Jackson', '101 Route, City M', '345-611-9012'),
	('C0014', 'Alexander White', '112 Path, City N', '456-789-0155'),
	('C0015', 'Amelia Harris', '123 Lane, City O', '567-790-1334'),
	('C0016', 'Daniel Martin', '234 Street, City P', '078-911-2345'),
	('C0017', 'Matthew Garcia', '345 Avenue, City Q', '098-012-3456'),
	('C0018', 'Olivia Martin', '456 Road, City R', '980-123-4567'),
	('C0019', 'Evelyn Martinez', '567 Drive, City S', '901-324-5678'),
	('C0020', 'Logan Robinson', '678 Boulevard, City T', '012-345-0123'),
	('C0021', 'Abigail Clark', '789 Place, City U', '135-791-1131'),
	('C0022', 'Lucas Rodriguez', '890 Court, City V', '246-810-1214'),
	('C0023', 'Emily Lewis', '901 Terrace, City W', '357-911-1315'),
	('C0024', 'Jackson Lee', '012 Circle, City X', '468-101-1131'),
	('C0025', 'Aria Walker', '123 Park, City Y', '579-111-3151');

GO
-- Inserting data for suppliers
INSERT INTO Supplier 
	(SupplierID, SupplierName, Location, PhoneNumber) 
VALUES 
	('S0001', 'Warehouse 1', 'Cape Town', '123-456-7890'),
	('S0002', 'Warehouse 2', 'Cape Town', '234-567-8901'),
	('S0003', 'Warehouse 3', 'Cape Town', '345-678-9012');

GO
-- Inserting data for distributors
INSERT INTO Distributor 
	(DistributorID, DistributorName, DistributorSurname, Address, PhoneNumber, CustomerID) 
VALUES 
	('D0001', 'John', 'Doe', '123 Maple Street, Anytown, SA', '123-456-7890', 'C0001'),
	('D0002', 'Jane', 'Smith', '456 Oak Ave, Springfield, SA', '234-567-8901', 'C0002'),
	('D0003', 'Michael', 'Johnson', '789 Elm Ct, Riverdale, SA', '345-678-9012', 'C0003'),
	('D0004', 'Sarah', 'Williams', '101 Pine Ln, Lakeside, SA', '456-789-0123', 'C0004'),
	('D0005', 'Robert', 'Jones', '234 Cedar Rd, Meadowview, SA', '567-890-1234', 'C0005'),
	('D0006', 'Jennifer', 'Brown', '567 Walnut Ave, Hillside, SA', '678-901-2345', 'C0006'),
	('D0007', 'William', 'Davis', '890 Birch St, Forest Hills, SA', '789-012-3456', 'C0007'),
	('D0008', 'Jessica', 'Miller', '111 Spruce Ct, Woodland, SA', '890-123-4567', 'C0008'),
	('D0009', 'David', 'Wilson', '222 Ash Ln, Brookside, SA', '901-234-5678', 'C0009'),
	('D0010', 'Amanda', 'Moore', '333 Redwood Ave, Cliffside, SA', '012-345-6789', 'C0010'),
	('D0011', 'James', 'Taylor', '444 Birchwood Rd, Ridgeway, SA', '555-123-4561', 'C0011'),
	('D0012', 'Megan', 'Anderson', '555 Willow Ct, Seaside, SA', '555-234-5672', 'C0012'),
	('D0013', 'Matthew', 'Thomas', '666 Sycamore Ln, Oceanview, SA', '555-345-6783', 'C0013'),
	('D0014', 'Emily', 'Jackson', '777 Cedarwood Ave, Lakewood, SA', '555-456-7894', 'C0014'),
	('D0015', 'Daniel', 'White', '888 Pinecrest Rd, Sunnyside, SA', '555-567-8915', 'C0015'),
	('D0016', 'Nicole', 'Harris', '999 Maplewood Ct, Hilltop, SA', '555-789-1237', 'C0016'),
	('D0017', 'Oliver', 'Martin', '123 Oakwood Ave, Greenfield, SA', '555-890-2348', 'C0017'),
	('D0018', 'Olivia', 'Johnson', '234 Walnut Ln, Meadowbrook, SA', '555-901-3459', 'C0018'),
	('D0019', 'Christopher', 'Thompson', '345 Birchwood Ct, Riverfront, SA', '555-012-4560', 'C0019'),
	('D0020', 'Ashley', 'Garcia', '456 Spruce Ave, Lakeshore, SA', '555-234-6782', 'C0020'),
	('D0021', 'Joseph', 'Martinez', '567 Cedar Ln, Riverside, SA', '555-456-8914', 'C0021'),
	('D0022', 'Samantha', 'Robinson', '678 Redwood St, Lakeview, SA', '555-678-1236', 'C0022'),
	('D0023', 'Andrew', 'Clark', '789 Sycamore Ct, Hillcrest, SA', '555-890-3458', 'C0023'),
	('D0024', 'Lauren', 'Rodriguez', '890 Pine Rd, Woodside, SA', '555-012-5670', 'C0024'),
	('D0025', 'Ryan', 'Lewis', '901 Elm Ave, Oakdale, SA', '555-456-9124', 'C0025');

GO
-- Inserting data for products
INSERT INTO Product 
	(ProductID, ProdctName, ProductType, ProductPrice, SupplierID) 
VALUES 
	('P0001', 'Sneaker 1', 'Sports', 150.00, 'S0001'),
	('P0002', 'Sneaker 2', 'Casual', 100.00, 'S0001'),
	('P0003', 'Sneaker 3', 'Formal', 200.00, 'S0002'),
	('P0004', 'Sneaker 4', 'Sports', 180.00, 'S0002'),
	('P0005', 'Sneaker 5', 'Casual', 120.00, 'S0003'),
	('P0006', 'Sneaker 6', 'Formal', 250.00, 'S0003'),
	('P0007', 'Sneaker 7', 'Sports', 160.00, 'S0001'),
	('P0008', 'Sneaker 8', 'Casual', 110.00, 'S0002'),
	('P0009', 'Sneaker 9', 'Formal', 220.00, 'S0003'),
	('P0010', 'Sneaker 10', 'Sports', 190.00, 'S0001'),
	('P0011', 'Sneaker 11', 'Casual', 130.00, 'S0002'),
	('P0012', 'Sneaker 12', 'Formal', 240.00, 'S0003'),
	('P0013', 'Sneaker 13', 'Sports', 170.00, 'S0001'),
	('P0014', 'Sneaker 14', 'Casual', 115.00, 'S0002'),
	('P0015', 'Sneaker 15', 'Formal', 260.00, 'S0003'),
	('P0016', 'Sneaker 16', 'Sports', 175.00, 'S0001'),
	('P0017', 'Sneaker 17', 'Casual', 118.00, 'S0002'),
	('P0018', 'Sneaker 18', 'Formal', 265.00, 'S0003'),
	('P0019', 'Sneaker 19', 'Sports', 180.00, 'S0001'),
	('P0020', 'Sneaker 20', 'Casual', 120.00, 'S0002'),
	('P0021', 'Sneaker 21', 'Formal', 270.00, 'S0003'),
	('P0022', 'Sneaker 22', 'Sports', 185.00, 'S0001'),
	('P0023', 'Sneaker 23', 'Casual', 125.00, 'S0002'),
	('P0024', 'Sneaker 24', 'Formal', 280.00, 'S0003'),
	('P0025', 'Sneaker 25', 'Sports', 190.00, 'S0001');

GO
-- Inserting data for sneaker orders
INSERT INTO SneakerOrder 
	(CustomerID, OrderDate, SupplierID, DistributorID, ProductID) 
VALUES 
	('C0001', '2020-10-20 10:30:00', 'S0001', 'D0001', 'P0001'),
	('C0002', '2023-01-21 11:45:00', 'S0002', 'D0002', 'P0002'),
	('C0003', '2019-04-28 09:15:00', 'S0003', 'D0003', 'P0003'),
	('C0004', '2017-11-11 12:00:00', 'S0001', 'D0004', 'P0004'),
	('C0005', '2022-06-13 14:30:00', 'S0002', 'D0005', 'P0005'),
	('C0006', '2021-09-08 10:00:00', 'S0003', 'D0006', 'P0006'),
	('C0007', '2018-02-26 09:45:00', 'S0001', 'D0007', 'P0007'),
	('C0008', '2019-12-23 11:00:00', 'S0002', 'D0008', 'P0008'),
	('C0009', '2021-03-03 13:15:00', 'S0003', 'D0009', 'P0009'),
	('C0010', '2022-09-29 15:30:00', 'S0001', 'D0010', 'P0010'),
	('C0011', '2021-12-05 10:30:00', 'S0002', 'D0011', 'P0011'),
	('C0012', '2023-10-14 12:45:00', 'S0003', 'D0012', 'P0012'),
	('C0013', '2017-10-20 10:30:00', 'S0001', 'D0013', 'P0013'),
	('C0014', '2017-08-21 11:45:00', 'S0002', 'D0014', 'P0014'),
	('C0015', '2023-01-22 09:15:00', 'S0003', 'D0015', 'P0015'),
	('C0016', '2017-10-23 12:00:00', 'S0001', 'D0016', 'P0016'),
	('C0017', '2023-02-24 14:30:00', 'S0002', 'D0017', 'P0017'),
	('C0018', '2023-04-25 10:00:00', 'S0003', 'D0018', 'P0018'),
	('C0019', '2023-09-26 09:45:00', 'S0001', 'D0019', 'P0019'),
	('C0020', '2022-04-27 11:00:00', 'S0002', 'D0020', 'P0020'),
	('C0021', '2021-01-28 13:15:00', 'S0003', 'D0021', 'P0021'),
	('C0022', '2018-02-24 15:30:00', 'S0001', 'D0022', 'P0022'),
	('C0023', '2022-10-29 10:30:00', 'S0002', 'D0023', 'P0023'),
	('C0024', '2021-05-26 12:45:00', 'S0003', 'D0024', 'P0024'),
	('C0025', '2017-05-31 12:45:00', 'S0003', 'D0025', 'P0025');

GO
-- Inserting data for employees
INSERT INTO Employee 
	(EmployeeID, EmployeeName, EmployeeSurname, PhoneNumber) 
VALUES 
	('E0001', 'John', 'Doe', '1234567890'),
	('E0002', 'Jane', 'Smith', '2345678901'),
	('E0003', 'Michael', 'Johnson', '3456789012');

GO
-- Inserting data for sales
INSERT INTO Sale 
	(Price, CustomerID, EmployeeID, ProductID) 
VALUES 
	(100.00, 'C0001', 'E0001', 'P0001'),
	(120.00, 'C0002', 'E0002', 'P0002'),
	(150.00, 'C0003', 'E0003', 'P0003'),
	(180.00, 'C0004', 'E0001', 'P0004'),
	(110.00, 'C0005', 'E0002', 'P0005'),
	(130.00, 'C0006', 'E0003', 'P0006'),
	(160.00, 'C0007', 'E0001', 'P0007'),
	(140.00, 'C0008', 'E0002', 'P0008'),
	(170.00, 'C0009', 'E0003', 'P0009'),
	(200.00, 'C0010', 'E0001', 'P0010'),
	(190.00, 'C0011', 'E0002', 'P0011'),
	(220.00, 'C0012', 'E0003', 'P0012'),
	(230.00, 'C0013', 'E0001', 'P0013'),
	(240.00, 'C0014', 'E0002', 'P0014'),
	(250.00, 'C0015', 'E0003', 'P0015'),
	(260.00, 'C0016', 'E0001', 'P0016'),
	(270.00, 'C0017', 'E0002', 'P0017'),
	(280.00, 'C0018', 'E0003', 'P0018'),
	(290.00, 'C0019', 'E0001', 'P0019'),
	(300.00, 'C0020', 'E0002', 'P0020'),
	(310.00, 'C0021', 'E0003', 'P0021'),
	(320.00, 'C0022', 'E0001', 'P0022'),
	(330.00, 'C0023', 'E0002', 'P0023'),
	(340.00, 'C0024', 'E0003', 'P0024'),
	(350.00, 'C0025', 'E0001', 'P0025');

GO
-- Inserting data for order details
INSERT INTO 
	OrderDetails (OrderID, OrderPrice, Discount, ProductID) 
VALUES 
	(1001, 100.00, 0.1, 'P0001'),
	(1002, 120.00, 0.2, 'P0002'),
	(1003, 150.00, 0.15, 'P0003'),
	(1004, 180.00, 0.12, 'P0004'),
	(1005, 110.00, 0.18, 'P0005'),
	(1006, 130.00, 0.25, 'P0006'),
	(1007, 160.00, 0.2, 'P0007'),
	(1008, 140.00, 0.1, 'P0008'),
	(1009, 170.00, 0.15, 'P0009'),
	(1010, 200.00, 0.12, 'P0010'),
	(1011, 190.00, 0.18, 'P0011'),
	(1012, 220.00, 0.25, 'P0012'),
	(1013, 230.00, 0.2, 'P0013'),
	(1014, 240.00, 0.1, 'P0014'),
	(1015, 250.00, 0.15, 'P0015'),
	(1016, 260.00, 0.12, 'P0016'),
	(1017, 270.00, 0.18, 'P0017'),
	(1018, 280.00, 0.25, 'P0018'),
	(1019, 290.00, 0.2, 'P0019'),
	(1020, 300.00, 0.1, 'P0020'),
	(1021, 310.00, 0.15, 'P0021'),
	(1022, 320.00, 0.12, 'P0022'),
	(1023, 330.00, 0.18, 'P0023'),
	(1024, 340.00, 0.25, 'P0024'),
	(1025, 350.00, 0.2, 'P0025');

GO
-- Inserting data for invoices
INSERT INTO Invoice 
	(CustomerID, DistributorID) 
VALUES 
	('C0001', 'D0001'),
	('C0002', 'D0002'),
	('C0003', 'D0003'),
	('C0004', 'D0004'),
	('C0005', 'D0005'),
	('C0006', 'D0006'),
	('C0007', 'D0007'),
	('C0008', 'D0008'),
	('C0009', 'D0009'),
	('C0010', 'D0010'),
	('C0011', 'D0011'),
	('C0012', 'D0012'),
	('C0013', 'D0013'),
	('C0014', 'D0014'),
	('C0015', 'D0015'),
	('C0016', 'D0016'),
	('C0017', 'D0017'),
	('C0018', 'D0018'),
	('C0019', 'D0019'),
	('C0020', 'D0020'),
	('C0021', 'D0021'),
	('C0022', 'D0022'),
	('C0023', 'D0023'),
	('C0024', 'D0024'),
	('C0025', 'D0025');

GO
-- Inserting data for pop-up stands
INSERT INTO PopUpStand 
	(Location, EmployeeID, ProductID) 
VALUES 
	('Braamfointentein', 'E0001', 'P0001'),
	('Pretoria', 'E0002', 'P0002'),
	('Cape Town', 'E0003', 'P0003');

GO

-- QUERIES

-- Retrieve the customer name, employee name, and sale price for all sales.
SELECT C.CustomerName, CONCAT(E.EmployeeName, ' ', E.EmployeeSurname) 'EmployeeName', CONCAT('R', S.Price) 'SalePrice'
FROM Customer C 
	INNER JOIN Sale S
		ON C.CustomerID=S.CustomerID
	INNER JOIN Employee E
		ON S.EmployeeID=E.EmployeeID;

GO
-- List the names of the customers and their corresponding order dates for orders placed in 2023.
WITH CTE_CustomerDates 
(CustomerName, YearDate) 
AS 
(
	SELECT C.CustomerName, YEAR(SO.OrderDate)
	FROM Customer C
		INNER JOIN SneakerOrder SO
			ON C.CustomerID=SO.CustomerID
	WHERE YEAR(SO.OrderDate) = 2023
)

SELECT *
FROM CTE_CustomerDates;

GO
-- Display the names of the customers, their order dates, and the product names they ordered.
SELECT C.CustomerName, SO.OrderDate, P.ProdctName
FROM Customer C
	INNER JOIN SneakerOrder SO
		ON C.CustomerID=SO.CustomerID
	INNER JOIN Product P
		ON P.ProductID=SO.ProductID;

GO
-- Provide the names of the employees, the products they sold, and the corresponding sale prices.
WITH CTE_Employees 
	(EmployeeName, Products, SalePrices) 
AS 
(
	SELECT E.EmployeeName, P.ProdctName, S.Price
	FROM Employee E
		INNER JOIN Sale S
			ON E.EmployeeID=S.EmployeeID
		INNER JOIN Product P
			ON P.ProductID=S.ProductID
)

SELECT *
FROM CTE_Employees;

GO
-- Find the CustomerName, CustomerID, and the number of orders each customer has made.
SELECT 
    C.CustomerID, C.CustomerName, 
    (SELECT COUNT(SO.OrderID) 
     FROM SneakerOrder SO 
     WHERE C.CustomerID = SO.CustomerID) AS 'Number of Orders'
FROM 
    Customer C
ORDER BY C.CustomerName;

GO
-- VIEWS

-- Create a view that displays customer names and their corresponding phone numbers.
CREATE VIEW vwCustomerPhoneNumbers 
AS
	SELECT CustomerName, Phone
	FROM Customer;

GO
-- Create a view that displays the order details, including the order IDs and product names.
CREATE VIEW vwOrderDetails 
AS
	SELECT OD.OrderID, OD.OrderPrice, OD.Discount, OD.ProductID, P.ProdctName
	FROM Product P
		INNER JOIN OrderDetails OD
			ON P.ProductID=OD.ProductID;

GO
-- Create a view that presents the invoice details, including the customer names and distributor names.
CREATE VIEW vwInvoiceDetails 
AS
	SELECT I.InvoiceID, I.InvoiceDate, C.CustomerName, CONCAT(D.DistributorName, ' ', D.DistributorSurname) 'DistributorName'
	FROM Customer C
		INNER JOIN Invoice I
			ON C.CustomerID=I.CustomerID
		INNER JOIN Distributor D
			ON C.CustomerID=D.CustomerID;

GO
-- Create a view that combines the sales data with the customer names and employee names.
CREATE VIEW vwSales 
AS
	SELECT S.SaleNumber, S.Price, C.CustomerName, CONCAT(E.EmployeeName, ' ', E.EmployeeSurname) 'EmployeeName'
	FROM Customer C
		INNER JOIN Sale S
			ON C.CustomerID=S.CustomerID
		INNER JOIN Employee E
			ON E.EmployeeID=S.EmployeeID;

GO
-- Create a view that combines the sneaker order information with the customer names and the supplier names.
CREATE VIEW vwSneakerOrder 
AS
	SELECT SO.OrderID, SO.CustomerID, C.CustomerName, SO.OrderDate, SO.SupplierID, S.SupplierName, SO.ProductID
	FROM Customer C
		INNER JOIN SneakerOrder SO
			ON C.CustomerID=SO.CustomerID
		INNER JOIN Supplier S
			ON S.SupplierID=SO.SupplierID;

GO

-- STORED PROCEDURES

-- Write the deivery details for the customers that shall be used by distributors.
CREATE PROC spDeliveryDetails
	@customerId CHAR(5)
AS
BEGIN
	DECLARE @customerName VARCHAR(40),
			@address VARCHAR(60),
			@phone CHAR(24)
	BEGIN TRY
		BEGIN TRANSACTION
			SELECT @customerName = CustomerName, @address = Address, @phone = Phone
			FROM Customer
			WHERE CustomerID=@customerId

			PRINT '--------------------------------'
			PRINT 'TO: ' + @customerName
			PRINT '--------------------------------'
			PRINT @address
			PRINT @phone
		COMMIT TRANSACTION
		PRINT 'Transaction was successfully committed.'
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		PRINT 'Transaction was unsuccessful and ultimately, has been rolled back.'
		PRINT ERROR_MESSAGE() 
	END CATCH
END;
-- execution statement
EXECUTE spDeliveryDetails 'C0001';

GO
-- Stored procedure that takes in parameters and inserts a new record into the Customer table.
CREATE PROC spCreateNewCustomer
	@customerId CHAR(5),
	@customerName VARCHAR(60),
	@address VARCHAR(60),
	@phone CHAR(24)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO Customer
				(CustomerID, CustomerName, Address, Phone)
			VALUES
				(@customerId, @customerName, @address, @phone)
		COMMIT TRANSACTION
		PRINT 'Transaction was successfully committed.'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Transaction was unsuccessful and ultimately, has been rolled back.'
		PRINT ERROR_MESSAGE() 
	END CATCH
END;
-- execution statement
EXECUTE spCreateNewCustomer @customerId = 'C0026', 
							@customerName = 'Maboku Seimla', 
							@address = '50 Dam Lane, Pretoria', 
							@phone = '079-148-9452'

GO
-- This procedure should update the Product table with the new price for the specified product.
CREATE PROC spUpdateProductPrice
	@productId CHAR(5),
	@productPrice MONEY
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE Product
			SET ProductPrice = @productPrice
			WHERE ProductID = @productId
		COMMIT TRANSACTION
		PRINT 'Transaction was successfully committed.'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT ERROR_MESSAGE()
		PRINT 'Transaction was unsuccessful and ultimately, has been rolled back.'
	END CATCH
END;

-- execution statement
EXECUTE spUpdateProductPrice @productId = 'P0001',
							 @productPrice = '200';

GO





