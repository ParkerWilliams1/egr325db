CREATE DATABASE MRO; 
USE MRO;

-- Customer table to store customer information. 
-- Helps manage orders and keeps a record of customers. 
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email_address VARCHAR(150) NOT NULL UNIQUE,   -- each customer must have a unique email. 
    phone_number VARCHAR(10) NOT NULL CHECK (LENGTH(phone_number) = 10), -- Must be a 10 digit number. 
    address VARCHAR(255)    -- NULL if the customer is pick-up. 
);

-- Order status table to store different statuses for orders. 
-- Helps that the order status is consistent across many orders. 
-- Easy updates without changing the main order table.
CREATE TABLE OrderStatus (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE    -- no duplicate status names
);

-- Inventory Table to track the ingredients that are available and in stock. 
-- Manages ingredients needed to prepare items. 
-- Enables the calculation of how much each ingredient is used in orders & stock levels.
CREATE TABLE Inventory (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL UNIQUE, -- unique ingredient names 
    quantity INT DEFAULT 0 CHECK (quantity >= 0) -- quantity cannot be negative
);

-- Order table represents actual orders made by the customer. 
-- Tracks the details of an order and connects to a customer and order status. 
CREATE TABLE CustomerOrder (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_status_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- time of order
    delivery_address VARCHAR(255), -- null if the customer is pickup.      
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0), -- total amount cannot be negative. 
    delivery_type ENUM('delivery', 'pickup') NOT NULL, -- customer order is either a delviery or a pick-up. 
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE, -- delete the if the customer is removed 
    FOREIGN KEY (order_status_id) REFERENCES OrderStatus(status_id) ON DELETE RESTRICT  -- prevents deletion of referenced status
);

-- MenuItem table consists of the menu items the customer can order. 
-- Tracks which ingredients are used in each item. 
-- Lets us manage the different menu items offered by the pizzeria. 
CREATE TABLE MenuItem (
    menu_item_id INT AUTO_INCREMENT PRIMARY KEY,
    menu_item_name VARCHAR(100) NOT NULL UNIQUE, -- avoid duplicate menu item names
    price DECIMAL(10, 2) NOT NULL CHECK(price >= 0),    -- must contain a price that is non-negative.
    ingredient_id INT,  
    quantity_needed INT CHECK(quantity_needed > 0), -- quantity needed must be positive.  
    FOREIGN KEY (ingredient_id) REFERENCES Inventory(ingredient_id) ON DELETE SET NULL -- set the ingredient_id to null if an inventory item is deleted.
);

-- OrderItem Table tracks individual items within the order. 
-- Links to the main order with given quantites and sizes. 
CREATE TABLE OrderItem (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    menu_id INT,
    size VARCHAR(50) NOT NULL, -- items must have a specified size.
    quantity INT DEFAULT 1 CHECK(quantity > 0),    -- cannot have a negative quantity. 
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id) ON DELETE CASCADE, -- delete if the order is deleted. 
    FOREIGN KEY (menu_id) REFERENCES MenuItem(menu_item_id) ON DELETE RESTRICT -- prevents the deletion of referenced menu item.
);

-- Inventory Transaction table to track inventory changes (when ingredients are used or restocked). 
-- Helps maintain accurate stock levels.
CREATE TABLE InventoryTransaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    ingredient_id INT,
    quantity_change INT,  -- Positive for restocking, negative for usage
    transaction_type ENUM('restock', 'usage') NOT NULL, -- must have transaction type.
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- time of transaction 
    FOREIGN KEY (ingredient_id) REFERENCES Inventory(ingredient_id) ON DELETE CASCADE -- delete if ingredient is deleted
);

-- MenuIngredient Table tracks the relationship with menu items and ingredients. 
-- Flexible tracking of the ingredients needed for each menu item.
-- Helps calculating how much inventory will be used when a customer orders an item. 
CREATE TABLE MenuIngredient (
    menu_ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    menu_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity_needed INT NOT NULL CHECK (quantity_needed > 0),  -- quantity needed must be positive.
    FOREIGN KEY (ingredient_id) REFERENCES Inventory(ingredient_id) ON DELETE CASCADE -- delete if an ingredient is deleted. 
);
