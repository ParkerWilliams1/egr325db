
use mro; 

-- dummy customer data
INSERT INTO Customer(customer_name, email_address, phone_number, address)
VALUES 
('John Doe', 'john.doe@example.com', '1234567890', '123 Elm St'),
('Jane Smith', 'jane.smith@example.com', '9876543210', '456 Oak St'),
('Tom Brown', 'tom.brown@example.com', '5555555555', NULL),
('Alice Green', 'alice.green@example.com', '1112223333', '789 Pine St'),
('Bob White', 'bob.white@example.com', '4445556666', '101 Maple Ave'),
('Charlie Blue', 'charlie.blue@example.com', '7778889999', NULL),   
('David Black', 'david.black@example.com', '2223334444', '202 Birch Blvd'),
('Eva Purple', 'eva.purple@example.com', '3334445555', '303 Cedar Rd');


-- dummy data into OrderStatus table
INSERT INTO OrderStatus (status_name)
VALUES
('Received'),
('In Progress'),
('Completed'),
('Cancelled');

-- dummy data into Inventory table
INSERT INTO Inventory (ingredient_name, quantity)
VALUES
('Tomato', 100),
('Cheese', 200),
('Olives', 50),
('Pepperoni', 75),
('Basil', 30),
('Mushrooms', 60),
('Green Peppers', 80),
('Onions', 40),
('Anchovies', 20),
('Chicken', 50),
('Ham', 60);

 -- dummy data into MenuItem table
INSERT INTO MenuItem (menu_item_name, price, ingredient_id, quantity_needed)
VALUES
('Margherita Pizza', 12.99, 1, 2),  -- Tomato
('Pepperoni Pizza', 15.99, 2, 3),   -- Cheese
('Veggie Pizza', 14.99, 3, 2),      -- Olives
('Meat Lovers Pizza', 17.99, 4, 4), -- Pepperoni
('Pesto Pizza', 13.99, 5, 1),      -- Basil
('Mushroom Pizza', 13.49, 6, 3),    -- Mushrooms
('Veggie Supreme Pizza', 16.99, 3, 5),  -- Olives, Green Peppers
('BBQ Chicken Pizza', 18.49, 6, 4),   -- Chicken
('Hawaiian Pizza', 15.49, 7, 3),      -- Ham
('Seafood Pizza', 19.99, 8, 5);       -- Anchovies

-- dummy data into Order table
INSERT INTO `Order` (customer_id, order_status_id, delivery_address, total_amount, delivery_type)
VALUES
(1, 1, '123 Elm St', 25.98, 'delivery'),
(2, 2, '456 Oak St', 30.98, 'pickup'),
(3, 3, NULL, 14.99, 'pickup'),
(4, 1, '202 Birch Blvd', 35.98, 'delivery'),
(5, 2, '303 Cedar Rd', 50.98, 'pickup'),
(1, 3, '123 Elm St', 40.98, 'delivery'),
(2, 4, '456 Oak St', 25.99, 'pickup'),
(3, 1, NULL, 17.99, 'pickup');

-- dummy data into OrderItem table
INSERT INTO OrderItem (order_id, menu_id, size, quantity)
VALUES
(1, 1, 'Large', 2),
(1, 2, 'Medium', 1),
(2, 3, 'Small', 1),
(2, 4, 'Large', 1),
(3, 5, 'Medium', 1),
(4, 6, 'Large', 2),  -- 2 Mushroom Pizzas
(5, 3, 'Medium', 1),  -- 1 Veggie Supreme Pizza
(1, 7, 'Large', 2),   -- 2 Hawaiian Pizzas
(2, 8, 'Small', 1),   -- 1 Seafood Pizza
(3, 5, 'Medium', 1);  -- 1 BBQ Chicken Pizza

-- dummy data into InventoryTransaction table
INSERT INTO InventoryTransaction (ingredient_id, quantity_change, transaction_type)
VALUES
(1, -5, 'usage'),  -- Tomato usage
(2, -10, 'usage'), -- Cheese usage
(3, -3, 'usage'),  -- Olives usage
(4, -5, 'usage'),  -- Pepperoni usage
(5, -2, 'usage'),  -- Basil usage
(1, 20, 'restock'), -- Restock Tomato
(2, 50, 'restock'), -- Restock Cheese
(6, -6, 'usage'),  -- Mushrooms usage for Mushroom Pizza
(3, -10, 'usage'), -- Olives usage for Veggie Supreme Pizza
(7, -6, 'usage'),  -- Ham usage for Hawaiian Pizza
(8, -5, 'usage'),  -- Anchovies usage for Seafood Pizza
(6, -4, 'usage'),  -- Chicken usage for BBQ Chicken Pizza
(6, 30, 'restock'), -- Restock Mushrooms
(3, 20, 'restock'), -- Restock Olives
(7, 50, 'restock'); -- Restock Ham

-- dummy data into MenuIngredient table
INSERT INTO MenuIngredient (menu_id, ingredient_id, quantity_needed)
VALUES
(1, 1, 2),  -- Margherita Pizza uses 2 Tomatoes
(2, 2, 3),  -- Pepperoni Pizza uses 3 Cheese
(3, 3, 2),  -- Veggie Pizza uses 2 Olives
(4, 4, 4),  -- Meat Lovers Pizza uses 4 Pepperonis
(5, 5, 1),  -- Pesto Pizza uses 1 Basil
(6, 6, 3),  -- Mushroom Pizza uses 3 Mushrooms
(3, 3, 2),  -- Veggie Supreme Pizza uses 2 Olives
(7, 7, 3),  -- Hawaiian Pizza uses 3 Ham
(8, 8, 5),  -- Seafood Pizza uses 5 Anchovies
(5, 6, 4);  -- BBQ Chicken Pizza uses 4 Chicken
