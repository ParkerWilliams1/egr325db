USE MRO;
-- Populate Customer table
INSERT INTO Customer (customer_name, email_address, phone_number, address) VALUES
('John Doe', 'john.doe@example.com', '1234567890', '123 Main Street'),
('Jane Smith', 'jane.smith@example.com', '0987654321', NULL),
('Bob Brown', 'bob.brown@example.com', '5551234567', '456 Elm Street'),
('Alice Green', 'alice.green@example.com', '7778889999', '789 Oak Lane'),
('Michael Johnson', 'michael.johnson@example.com', '6665554444', NULL),
('Emily Davis', 'emily.davis@example.com', '1112223333', '321 Pine Avenue');

-- Populate OrderStatus table
INSERT INTO OrderStatus (status_name) VALUES
('Received'),
('In Progress'),
('Completed'),
('Cancelled'),
('Delivered'),
('Refunded');

-- Populate Inventory table
INSERT INTO Inventory (ingredient_name, ingredient_cost, quantity) VALUES
('Cheese', 4.25 , 100),
('Tomato Sauce', 3.00, 80),
('Pepperoni', 4.40, 60),
('Dough', 2.00, 200),
('Onions', 1.50, 40),
('Bell Peppers', 2.50, 30),
('Mushrooms', 3.50, 25),
('Sausage', 6.00, 50);

-- Populate Employee table
INSERT INTO Employee (employee_name, email_address, phone_number, hire_date, role, wage) VALUES
('Alice Johnson', 'alice.johnson@example.com', '2223334444', '2023-01-01', 'Manager', 25.00),
('Charlie Davis', 'charlie.davis@example.com', '3334445555', '2023-02-15', 'Employee', 15.00),
('Emily White', 'emily.white@example.com', '4445556666', '2023-03-10', 'Employee', 15.50),
('David Harris', 'david.harris@example.com', '9998887777', '2023-04-20', 'Employee', 16.00),
('Olivia Brown', 'olivia.brown@example.com', '5556667777', '2023-05-10', 'Employee', 14.50);

-- Populate CustomerOrder table
INSERT INTO CustomerOrder (customer_id, order_status_id, employee_id, delivery_address, total_amount, delivery_type) VALUES
(1, 1, 2, '123 Main Street', 25.50, 'delivery'),
(2, 2, 3, NULL, 15.00, 'pickup'),
(3, 3, 2, '456 Elm Street', 30.75, 'delivery'),
(4, 4, 4, '789 Oak Lane', 18.50, 'delivery'),
(5, 5, 5, NULL, 22.00, 'pickup'),
(6, 6, 3, '321 Pine Avenue', 27.00, 'delivery');

-- Populate MenuItem table
INSERT INTO MenuItem (menu_item_name, price, ingredient_id, quantity_needed) VALUES
('Pepperoni Pizza', 12.00, 3, 2),
('Cheese Pizza', 10.00, 1, 3),
('Veggie Pizza', 11.50, 5, 2),
('Meat Lover\'s Pizza', 14.00, 8, 4),
('Supreme Pizza', 15.50, 6, 3),
('Hawaiian Pizza', 13.50, 4, 2);

-- Populate OrderItem table
INSERT INTO OrderItem (order_id, menu_id, size, quantity) VALUES
(1, 1, 'Medium', 2),
(1, 2, 'Large', 1),
(2, 3, 'Small', 3),
(2, 4, 'Large', 2),
(3, 5, 'Medium', 1),
(3, 6, 'Large', 3),
(4, 1, 'Small', 2),
(5, 2, 'Large', 1),
(6, 4, 'Medium', 3);

-- Populate InventoryTransaction table
INSERT INTO InventoryTransaction (ingredient_id, quantity_change, transaction_type) VALUES
(1, -5, 'usage'),
(2, 10, 'restock'),
(3, -3, 'usage'),
(4, -10, 'usage'),
(5, 5, 'restock'),
(6, -8, 'usage'),
(7, 15, 'restock'),
(8, -12, 'usage');

-- Populate MenuIngredient table
INSERT INTO MenuIngredient (menu_id, ingredient_id, quantity_needed) VALUES
(1, 3, 2),
(1, 4, 1),
(2, 1, 3),
(2, 2, 2),
(3, 5, 1),
(3, 6, 1),
(4, 8, 3),
(5, 7, 2);

-- Populate Shift table
INSERT INTO Shift (shift_date, start_time, end_time, employee_id) VALUES
('2024-11-22', '00:00:00', '08:00:00', 1),
('2024-11-22', '08:00:00', '16:00:00', 2),
('2024-11-22', '16:00:00', '24:00:00', 3),
('2024-11-23', '00:00:00', '08:00:00', 4),
('2024-11-23', '08:00:00', '16:00:00', 5),
('2024-11-23', '16:00:00', '24:00:00', NULL),
('2024-11-24', '00:00:00', '08:00:00', 2),
('2024-11-24', '08:00:00', '16:00:00', 3),
('2024-11-24', '16:00:00', '24:00:00', NULL),
('2024-11-25', '00:00:00', '08:00:00', NULL),
('2024-11-25', '08:00:00', '16:00:00', 3),
('2024-11-25', '16:00:00', '24:00:00', NULL);

-- Populate Payment table
INSERT INTO Payment (order_id, payment_date, payment_amount, payment_method) VALUES
(1, '2024-11-22', 25.50, 'Card'),
(2, '2024-11-22', 15.00, 'Cash'),
(3, '2024-11-22', 30.75, 'Online'),
(4, '2024-11-23', 18.50, 'Card'),
(5, '2024-11-23', 22.00, 'Cash'),
(6, '2024-11-24', 27.00, 'Online');
