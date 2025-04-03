
============================ERD Diagram===============================

--1) See ERD Diagram --Orange Tables and Blue tables
--2) --- With ERD Diagram Creation:  It provides better visualization, error detection, and ease of understanding and collaboration.
     --  Without ERD Diagram: It requires more manual effort to maintain and understand the schema, and you risk missing errors.

--3  -- Orange Color Vs Blue color
Orange: Focuses on the operational or transactional part of the business.
Blue: Focuses on the definition and inventory aspects.

Transaction Tables (e.g., sales, orders) and
Master Tables (e.g., products, categories).

--oragne tables

customers
staffs
stores
orders
order_items

--blue tables

categories
brands
products
stocks


--4) Table Creations

-- Table: customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(100),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(10)
);


-- Table: stores
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(10)
);


-- Table: staffs   --Self-referecing Foreig Key)
--you might need to insert records with NULL values for manager_id initially, and then update them after adding the appropriate staff_id.
CREATE TABLE staffs (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15),
    active bit,
    store_id INT,
    manager_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);




-- Table: orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_status VARCHAR(50),
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    store_id INT,
    staff_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

-- Table: brands
CREATE TABLE brands (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(100)
);

-- Table: categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);


-- Table: products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    brand_id INT,
    category_id INT,
    model_year INT,
    list_price DECIMAL(10, 2),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Table: order_items
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price DECIMAL(10, 2),
    discount DECIMAL(5, 2),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- Table: stocks
CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

use erd2



---why we required pk vs fk realtionship, is it only to avoid orphan data ?????


The Primary Key (PK) vs Foreign Key (FK) relationship is a fundamental concept in relational databases and is required for more than just avoiding orphan data. Let me break it down into key purposes and benefits:

1. Avoid Orphan Data
Purpose: To ensure that a record in a child table (one with a foreign key) is always related to a valid record in the parent table (one with a primary key).
Example:
If an order (orders table) references a customer (customers table), the foreign key ensures that the customer exists. Without this relationship, orders might reference non-existent customers, causing data integrity issues.
2. Ensure Data Integrity
Purpose: To maintain consistency in the database by enforcing rules about how data in different tables is related.
Example:
In the products table, a brand_id must always reference a valid entry in the brands table. If someone tries to insert a product with a brand_id that doesn’t exist, the foreign key constraint prevents the operation.
3. Enforce Referential Integrity
Purpose: To automatically propagate changes from parent to child tables.
Actions supported:
ON DELETE CASCADE: If a parent record is deleted, all related child records are also deleted.
ON UPDATE CASCADE: If the primary key in the parent table is updated, all related foreign key values in child tables are automatically updated.
Example:
Deleting a store will also delete all its stocks and orders associated with it.
4. Establish Relationships Between Tables
Purpose: To model real-world relationships between entities in a database.
Example:
The orders table has a foreign key to the customers table because customers place orders. This relationship allows the database to model real-world behavior.
5. Enable Efficient Queries
Purpose: To enable joining tables and retrieving related data more efficiently.
Example:
You can use a JOIN query to get all orders placed by a specific customer:
sql
Copy
Edit
SELECT o.order_id, o.order_date, c.first_name, c.last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;
6. Prevent Duplicate or Invalid Data
Purpose: To ensure that relationships between tables are valid and avoid duplicate or redundant data.
Example:
Without a foreign key, a user could mistakenly add a product to a non-existent category, which would create inconsistencies.
7. Help Database Normalization
Purpose: To organize data into tables efficiently, ensuring minimal redundancy and dependency.
Example:
Instead of repeating the brand_name in every product, the products table references the brands table using brand_id.
Why Is PK vs FK Needed?
Key Purpose	Explanation
Avoid orphan data	Prevent child records from existing without a valid parent record.
Maintain data integrity	Ensure that all references between tables are valid.
Enforce rules	Automate referential integrity through cascading operations.
Reflect real-world logic	Model relationships like orders linked to customers, products linked to brands, etc.
Normalize data	Eliminate redundancy by storing related data in separate tables linked through PK-FK.
Support complex queries	Enable meaningful joins and queries to retrieve related data across multiple tables efficiently.
Example Without PK-FK:
Scenario: Assume there’s no foreign key between orders and customers.
Someone accidentally deletes a customer from the customers table.
Now, the orders table may have rows referencing a non-existent customer (orphan data).
Querying orders with customer details will fail or give incomplete results.
Example With PK-FK:
The database enforces that a customer must exist before an order can be created. Deleting a customer can either:
Prevent deletion (default behavior) if related orders exist.
Cascade deletion (if specified) to remove all related orders automatically.
In summary, while avoiding orphan data is a critical benefit of PK-FK relationships, the larger purpose is to ensure data integrity, consistency, and accurate relationships across the database, which makes it easier to manage, query, and maintain the data effectively.