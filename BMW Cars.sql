
CREATE DATABASE BMW_CARS
use BMW_CARS

--1)
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incrementing primary key
    Name NVARCHAR(100) NOT NULL,               -- Customer name
    Email NVARCHAR(100) UNIQUE NOT NULL,       -- Customer email (unique)
    Phone NVARCHAR(15),                        -- Customer phone number
    Address NVARCHAR(255),                     -- Customer address
    DateOfBirth DATE,                          -- Customer date of birth
    CreatedAt DATETIME DEFAULT GETDATE()       -- Timestamp of when the customer was added
);

SELECT * FROM Customers

CREATE PROCEDURE InsertCustomer
    @CustomerName NVARCHAR(100),
    @CustomerEmail NVARCHAR(100),
    @CustomerPhone NVARCHAR(15),
    @CustomerAddress NVARCHAR(255),
    @CustomerDateOfBirth DATE
AS
BEGIN
    BEGIN TRY
        -- Insert customer into Customers table
        INSERT INTO Customers (Name, Email, Phone, Address, DateOfBirth)
        VALUES (@CustomerName, @CustomerEmail, @CustomerPhone, @CustomerAddress, @CustomerDateOfBirth);
        
        -- Optionally, return a success message
        PRINT 'Customer inserted successfully.';
    END TRY
    BEGIN CATCH
        -- In case of error, reset the identity to the last valid value for the Customers table
        DECLARE @MaxID INT;
        SELECT @MaxID = MAX(CustomerID) FROM Customers;
        DBCC CHECKIDENT ('Customers', RESEED, @MaxID);
        
        -- Optionally, handle error and return message
        PRINT 'Error occurred. Identity reset for Customer table.';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH
END;
 


--RUN InsertCustomer SP

EXEC InsertCustomer 
    @CustomerName = 'John Doe', 
    @CustomerEmail = 'johndoe@example.com', 
    @CustomerPhone = '1234567890', 
    @CustomerAddress = '1234 Elm St', 
    @CustomerDateOfBirth = '1985-04-25';


	EXEC InsertCustomer 
    @CustomerName = 'Rama Rao', 
    @CustomerEmail = 'RR@example.com', 
    @CustomerPhone = '2834567890', 
    @CustomerAddress = '213234 DEElm St', 
    @CustomerDateOfBirth = '1985-04-25';

	SELECT * FROM Customers
	insert into customers (name,email,phone,address,DateOfBirth) values('Tom Races','TR@gmail.com',14301401,'1244-wwe-KT','1990-01-10');

	SELECT * FROM Customers

	--2)

	CREATE TABLE Cars (
    CarID INT IDENTITY(1,1) PRIMARY KEY,        -- Auto-incrementing primary key
    Make NVARCHAR(100) NOT NULL,                 -- Car make (e.g., Toyota, Honda)
    Model NVARCHAR(100) NOT NULL,                -- Car model (e.g., Corolla, Civic)
    Year INT NOT NULL,                           -- Year of manufacture
    Price DECIMAL(18,2) NOT NULL,                -- Price of the car
    EngineType NVARCHAR(50) NOT NULL,            -- Type of engine (e.g., Petrol, Diesel, Electric)
    StockQuantity INT NOT NULL                   -- Quantity of cars available in stock
);


	CREATE PROCEDURE InsertCar
    @Make NVARCHAR(100),
    @Model NVARCHAR(100),
    @Year INT,
    @Price DECIMAL(18,2),
    @EngineType NVARCHAR(50),
    @StockQuantity INT
AS
BEGIN
    BEGIN TRY
        -- Insert car into Cars table
        INSERT INTO Cars (Make, Model, Year, Price, EngineType, StockQuantity)
        VALUES (@Make, @Model, @Year, @Price, @EngineType, @StockQuantity);
        
        -- Optionally, return a success message
        PRINT 'Car inserted successfully.';
    END TRY
    BEGIN CATCH
        -- Handle error and print error message
        PRINT 'Error occurred while inserting the car.';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        
        -- Reset the identity to the last valid value for the Cars table
        DECLARE @MaxID INT;
        SELECT @MaxID = MAX(CarID) FROM Cars;
        DBCC CHECKIDENT ('Cars', RESEED, @MaxID);

        PRINT 'Identity reset for Cars table.';
    END CATCH
END;

-- insertCar

EXEC InsertCar 
    @Make = 'Toyota', 
    @Model = 'Corolla', 
    @Year = 2024, 
    @Price = 25000.00, 
    @EngineType = 'Petrol', 
    @StockQuantity = 10;


	EXEC InsertCar 
    @Make = 'Honda', 
    @Model = 'Civic', 
    @Year = 2023, 
    @Price = 22000.00, 
    @EngineType = 'Diesel', 
    @StockQuantity = 15;


select * from cars;


--3)


CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,         -- Auto-incrementing primary key
    CustomerID INT,                               -- Foreign Key referencing Customers
    CarID INT,                                    -- Foreign Key referencing Cars
    SaleDate DATETIME DEFAULT GETDATE(),          -- Date and time of sale
    PaymentMethod NVARCHAR(50),                   -- Payment method (e.g., Credit, Cash)
    Amount DECIMAL(18,2),                         -- Sale amount
    CONSTRAINT FK_Sales_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Sales_Cars FOREIGN KEY (CarID) REFERENCES Cars(CarID)
);

select * from sales;


CREATE PROCEDURE InsertSale
    @CustomerID INT,
    @CarID INT,
    @SaleDate DATETIME,
    @PaymentMethod NVARCHAR(50),
    @Amount DECIMAL(18,2)
AS
BEGIN
    BEGIN TRY
        -- Insert sale into Sales table
        INSERT INTO Sales (CustomerID, CarID, SaleDate, PaymentMethod, Amount)
        VALUES (@CustomerID, @CarID, @SaleDate, @PaymentMethod, @Amount);
        
        -- Optionally, return a success message
        PRINT 'Sale inserted successfully.';
    END TRY
    BEGIN CATCH
        -- Handle error and print error message
        PRINT 'Error occurred while inserting the sale.';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        
        -- Reset the identity to the last valid value for the Sales table
        DECLARE @MaxID INT;
        SELECT @MaxID = MAX(SaleID) FROM Sales;
        DBCC CHECKIDENT ('Sales', RESEED, @MaxID);

        PRINT 'Identity reset for Sales table.';
    END CATCH
END;

--- canot exectuted the file
EXEC InsertSale 
    @CustomerID = 1, 
    @CarID = 2, 
    @SaleDate = '2024-12-09', 
    @PaymentMethod = 'Credit', 
    @Amount = 25000.00;

EXEC InsertSale 
    @CustomerID = 2, 
    @CarID = 1, 
    @SaleDate = '2024-12-10', 
    @PaymentMethod = 'Cash', 
    @Amount = 23000.00;

EXEC InsertSale 
    @CustomerID = 1, 
    @CarID = 2, 
    @SaleDate = '2024-12-11', 
    @PaymentMethod = 'Debit', 
    @Amount = 27000.00;


	select * From Customers
	select * From cars
	select * From sales
	SELECT * FROM ONLINEORDERS;

CREATE TABLE OnlineOrders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,     -- Auto-incrementing primary key
    CustomerID INT,                            -- Foreign key to the Customers table
    CarID INT,                                 -- Foreign key to the Cars table
    OrderDate DATETIME DEFAULT GETDATE(),      -- The date the order was placed
    Status NVARCHAR(50),                       -- Status of the order (e.g., Pending, Delivered)
    DeliveryDate DATETIME,                     -- The date the car is delivered
    CONSTRAINT FK_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Car FOREIGN KEY (CarID) REFERENCES Cars(CarID)
);



CREATE PROCEDURE InsertOnlineOrder
    @CustomerID INT,
    @CarID INT,
    @OrderDate DATETIME,
    @Status NVARCHAR(50),
    @DeliveryDate DATETIME
AS
BEGIN
    BEGIN TRY
        -- Insert a new order record into OnlineOrders table
        INSERT INTO OnlineOrders (CustomerID, CarID, OrderDate, Status, DeliveryDate)
        VALUES (@CustomerID, @CarID, @OrderDate, @Status, @DeliveryDate);
        
        -- Optionally, return a success message
        PRINT 'Online order inserted successfully.';
    END TRY
    BEGIN CATCH
        -- Handle errors and return an error message
        PRINT 'Error occurred while inserting the order.';
        
        -- Reset the identity to the last valid value for the Sales table 
        DECLARE @MaxID INT;
        SELECT @MaxID = MAX(SaleID) FROM Sales;
        DBCC CHECKIDENT ('Sales', RESEED, @MaxID);
        
        -- Optionally, log error details
        -- SELECT ERROR_MESSAGE();
    END CATCH
END;



EXEC InsertOnlineOrder
    @CustomerID = 3,           -- CustomerID (foreign key, assuming CustomerID 1 exists)
    @CarID = 2,              -- CarID (foreign key, assuming CarID 101 exists)
    @OrderDate = '2024-12-09', -- OrderDate (date when the order is placed)
    @Status = 'Pending',       -- Status (order status, e.g., Pending, Delivered)
    @DeliveryDate = '2024-12-15'; -- DeliveryDate (date when the car will be delivered)



	select * From Customers
	select * From cars
	select * From sales
	SELECT * FROM ONLINEORDERS;
