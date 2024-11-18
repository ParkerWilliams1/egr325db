-- Create table for OrderStatus
CREATE TABLE OrderStatus (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Create table for Customer
CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    email_address VARCHAR(100) UNIQUE NOT NULL,
    address TEXT NOT NULL
);

-- Create table for Inventory
CREATE TABLE Inventory (
    ingredient_id SERIAL PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

-- Create table for MenuItem
CREATE TABLE MenuItem (
    menu_item_id SERIAL PRIMARY KEY,
    menu_item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Create table for MenuIngredient
CREATE TABLE MenuIngredient (
    menu_ingredient_id SERIAL PRIMARY KEY,
    menu_item_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity_needed INT NOT NULL,
    FOREIGN KEY (menu_item_id) REFERENCES MenuItem(menu_item_id),
    FOREIGN KEY (ingredient_id) REFERENCES Inventory(ingredient_id)
);

-- Create table for Order
CREATE TABLE "Order" (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    status_id INT NOT NULL,
    order_date DATE NOT NULL,
    delivery_address TEXT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    delivery_type VARCHAR(50) CHECK (delivery_type IN ('delivery', 'pickup')),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (status_id) REFERENCES OrderStatus(status_id)
);

-- Create table for OrderItem
CREATE TABLE OrderItem (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    size VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES "Order"(order_id),
    FOREIGN KEY (menu_id) REFERENCES MenuItem(menu_item_id)
);

-- Create table for InventoryTransaction
CREATE TABLE InventoryTransaction (
    transaction_id SERIAL PRIMARY KEY,
    ingredient_id INT NOT NULL,
    quantity_change INT NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    transaction_date DATE NOT NULL,
    FOREIGN KEY (ingredient_id) REFERENCES Inventory(ingredient_id)
);

-- Insert data into OrderStatus
INSERT INTO OrderStatus (status_name) VALUES
('Pending'),
('Processing'),
('Completed'),
('Cancelled');

-- Insert data into Customer
INSERT INTO Customer (customer_name, phone_number, email_address, address) VALUES
('John Doe', '555-1234', 'john.doe@example.com', '123 Main St, Springfield'),
('Jane Smith', '555-5678', 'jane.smith@example.com', '456 Oak Ave, Riverside'),
('Sam Brown', '555-8765', 'sam.brown@example.com', '789 Pine Rd, Lakewood');

-- Insert data into Inventory
INSERT INTO Inventory (ingredient_name, quantity) VALUES
('Tomatoes', 100),
('Cheese', 50),
('Dough', 30),
('Pepperoni', 20);

-- Insert data into MenuItem
INSERT INTO MenuItem (menu_item_name, price) VALUES
('Margherita Pizza', 12.99),
('Pepperoni Pizza', 14.99),
('Veggie Pizza', 13.99);

-- Insert data into MenuIngredient
INSERT INTO MenuIngredient (menu_item_id, ingredient_id, quantity_needed) VALUES
(1, 1, 2), -- Margherita Pizza needs Tomatoes
(1, 2, 1), -- Margherita Pizza needs Cheese
(1, 3, 1), -- Margherita Pizza needs Dough
(2, 1, 1), -- Pepperoni Pizza needs Tomatoes
(2, 2, 1), -- Pepperoni Pizza needs Cheese
(2, 3, 1), -- Pepperoni Pizza needs Dough
(2, 4, 1), -- Pepperoni Pizza needs Pepperoni
(3, 1, 3), -- Veggie Pizza needs Tomatoes
(3, 2, 1), -- Veggie Pizza needs Cheese
(3, 3, 1); -- Veggie Pizza needs Dough

-- Insert data into Order
INSERT INTO "Order" (customer_id, status_id, order_date, delivery_address, total_amount, delivery_type) VALUES
(1, 1, '2024-11-18', '123 Main St, Springfield', 27.98, 'delivery'),
(2, 2, '2024-11-18', '456 Oak Ave, Riverside', 14.99, 'pickup');

-- Insert data into OrderItem
INSERT INTO OrderItem (order_id, menu_id, size, quantity) VALUES
(1, 1, 'Medium', 1), -- Order 1 includes 1 Medium Margherita Pizza
(1, 2, 'Medium', 1), -- Order 1 includes 1 Medium Pepperoni Pizza
(2, 2, 'Large', 1);  -- Order 2 includes 1 Large Pepperoni Pizza

-- Insert data into InventoryTransaction
INSERT INTO InventoryTransaction (ingredient_id, quantity_change, transaction_type, transaction_date) VALUES
(1, -3, 'Order Fulfillment', '2024-11-18'), -- Tomatoes used
(2, -2, 'Order Fulfillment', '2024-11-18'), -- Cheese used
(3, -2, 'Order Fulfillment', '2024-11-18'), -- Dough used
(4, -1, 'Order Fulfillment', '2024-11-18'); -- Pepperoni used

