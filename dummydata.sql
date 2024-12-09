USE MRO;

-- Insert into Customer table
-- unique emails and phone numbers
INSERT INTO Customer (customer_name, email_address, phone_number) VALUES
('John Doe', 'john.doe@example.com', '1234567890'),
('Jane Smith', 'jane.smith@example.com', '0987654321'),
('Bob Brown', 'bob.brown@example.com', '5551234567'),
('Alice Green', 'alice.green@example.com', '7778889999'),
('Michael Johnson', 'michael.johnson@example.com', '6665554444'),
('Emily Davis', 'emily.davis@example.com', '1112223333');

-- insert into CustomerAddress table
-- MRO pizzeria is only located in CA. Zipcodes are of length 5. 
INSERT INTO CustomerAddress (customer_id, address_type, street, city, state, zipcode) VALUES
(1, 'House', '123 Main Street', 'Riverside', 'CA', '92501'),   -- John Doe
(3, 'Apartment', '456 Elm Street Apt 5', 'Riverside', 'CA', '92506'), -- Bob Brown
(5, 'Business', '789 Oak Lane Suite 200', 'San Diego', 'CA', '92101'); -- Michael Johnson
-- Customers 2,4,6 have no addresses.

-- Insert into OrderStatus table
-- different status for orders
INSERT INTO OrderStatus (status_name) VALUES
('Received'),
('In Progress'),
('Completed'),
('Cancelled'),
('Delivered'),
('Refunded');

-- Insert into Inventory table
-- all ingredients for our menu items at our pizzeria
INSERT INTO Inventory (ingredient_name, ingredient_cost, quantity) VALUES
('Cheese', 4.25, 100),
('Tomato Sauce', 3.00, 80),
('Pepperoni', 4.40, 60),
('Dough', 2.00, 200),
('Onions', 1.50, 40),
('Bell Peppers', 2.50, 30),
('Mushrooms', 3.50, 25),
('Sausage', 6.00, 50),
('Ham', 5.00, 50),
('Pineapple', 4.00, 40);

-- Insert into Employee table 
-- information about each employee is given. 
INSERT INTO Employee (employee_name, email_address, phone_number, hire_date, role, wage) VALUES
('Alice Johnson', 'alice.johnson@example.com', '2223334444', '2023-01-01', 'Manager', 25.00),
('Charlie Davis', 'charlie.davis@example.com', '3334445555', '2023-02-15', 'Employee', 15.00),
('Emily White', 'emily.white@example.com', '4445556666', '2023-03-10', 'Employee', 15.50),
('David Harris', 'david.harris@example.com', '9998887777', '2023-04-20', 'Employee', 16.00),
('Olivia Brown', 'olivia.brown@example.com', '5556667777', '2023-05-10', 'Employee', 14.50);

-- Insert into CustomerOrder table
-- customer address id is null if it is a pickup order.
INSERT INTO CustomerOrder (customer_id, order_status_id, employee_id, customer_address_id, total_amount, delivery_type)
VALUES
(1, 1, 2, 1, 25.50, 'delivery'),   -- John Doe, Received, delivery
(2, 2, 3, NULL, 15.00, 'pickup'),  -- Jane Smith, In Progress, pickup
(3, 3, 2, 2, 30.75, 'delivery'),   -- Bob Brown, Completed, delivery
(4, 4, 4, NULL, 18.50, 'pickup'),  -- Alice Green, Cancelled
(5, 5, 5, 3, 22.00, 'delivery'),   -- Michael Johnson, Delivered, delivery
(6, 6, 3, NULL, 27.00, 'pickup');  -- Emily Davis, Refunded

-- Insert into MenuItem table
-- each menu item listed with its relevent details. 
INSERT INTO MenuItem (menu_item_name, price, ingredient_id, quantity_needed) VALUES
('Pepperoni Pizza', 12.00, 3, 2),   -- main: Pepperoni
('Cheese Pizza', 10.00, 1, 3),      -- main: Cheese
('Veggie Pizza', 11.50, 5, 2),      -- main: Onions
('Meat Lover\'s Pizza', 14.00, 8, 4), -- main: Sausage
('Supreme Pizza', 15.50, 6, 3),     -- main: Bell Peppers
('Hawaiian Pizza', 13.50, 4, 2);    -- main: Dough

-- Insert into OrderItem table 
-- order details such as size, quantity and item ordered. 
INSERT INTO OrderItem (order_id, menu_id, size, quantity) VALUES
(1, 1, 'Medium', 2),   -- Order #1: Pepperoni Pizza x2
(1, 2, 'Large', 1),    -- Order #1: Cheese Pizza x1
(2, 3, 'Small', 3),    -- Order #2: Veggie Pizza x3
(2, 4, 'Large', 2),    -- Order #2: Meat Lover's x2
(3, 5, 'Medium', 1),   -- Order #3: Supreme Pizza x1
(3, 6, 'Large', 3),    -- Order #3: Hawaiian Pizza x3
(4, 1, 'Small', 2),    -- Order #4: Pepperoni Pizza x2
(5, 2, 'Large', 1),    -- Order #5: Cheese Pizza x1
(6, 4, 'Medium', 3);   -- Order #6: Meat Lover's x3

-- Insert into InventoryTransaction table
-- transactions of how much inventory was used or restocked. 
INSERT INTO InventoryTransaction (ingredient_id, quantity_change, transaction_type) VALUES
(1, -5, 'usage'),    -- Cheese used
(2, 10, 'restock'),  -- Tomato Sauce restocked
(3, -3, 'usage'),    -- Pepperoni used
(4, -10, 'usage'),   -- Dough used
(5, 5, 'restock'),   -- Onions restocked
(6, -8, 'usage'),    -- Bell Peppers used
(7, 15, 'restock'),  -- Mushrooms restocked
(8, -12, 'usage'),   -- Sausage used
(9, -5, 'usage'),    -- Ham used
(10, -4, 'usage');   -- Pineapple used

-- Insert into MenuIngredient
-- Pepperoni Pizza: Pepperoni(3), Cheese(1), Dough(4)
INSERT INTO MenuIngredient (menu_id, ingredient_id, quantity_needed) VALUES
(1, 3, 2),
(1, 1, 2),
(1, 4, 1),

-- Cheese Pizza: Cheese(1), Tomato Sauce(2), Dough(4)
(2, 1, 3),
(2, 2, 2),
(2, 4, 1),

-- Veggie Pizza: Onions(5), Bell Peppers(6), Mushrooms(7), Dough(4)
(3, 5, 1),
(3, 6, 1),
(3, 7, 1),
(3, 4, 1),

-- Meat Lover's: Sausage(8), Pepperoni(3), Cheese(1), Dough(4)
(4, 8, 3),
(4, 3, 2),
(4, 1, 1),
(4, 4, 1),

-- Supreme Pizza: Bell Peppers(6), Onions(5), Pepperoni(3), Sausage(8), Dough(4), Cheese(1)
(5, 6, 1),
(5, 5, 1),
(5, 3, 1),
(5, 8, 1),
(5, 4, 1),
(5, 1, 1),

-- Hawaiian Pizza: Dough(4), Cheese(1), Ham(9), Pineapple(10)
(6, 4, 1),
(6, 1, 2),
(6, 9, 2),   
(6, 10, 1); 

-- Insert into Shift table
-- a NULL emloyee_id meaning a open shift.
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

-- Insert into Payment table 
-- relavent details of all payments.
INSERT INTO Payment (order_id, payment_date, payment_amount, payment_method) VALUES
(1, '2024-11-22', 25.50, 'Card'),
(2, '2024-11-22', 15.00, 'Cash'),
(3, '2024-11-22', 30.75, 'Online'),
(4, '2024-11-23', 18.50, 'Card'),
(5, '2024-11-23', 22.00, 'Cash'),
(6, '2024-11-24', 27.00, 'Online');
