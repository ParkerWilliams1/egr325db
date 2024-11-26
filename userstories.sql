-- User story deomonstrations 

-- As a customer, I want to order a delivery online
-- so that I can enjoy my meal at my own home.

-- call the stored procedure to add a new order
-- CALL AddNewOrder(
-- 	1, -- customer_id "John Doe"
--     NULL, -- employee_id (not assigned intially)
--     1, -- order status. ('recieved)
--     'delivery', -- order type (delivery order)
--     '123 Elm Street', -- delivery address
--     1, -- menu_id (pepperoni pizza)
--     2, -- quantity 
--     'Large' -- size
-- );

-- check the new order
-- SELECT * FROM CustomerOrder WHERE customer_id = 1 ORDER BY order_id DESC LIMIT 1;

-- -- check the items added to the OrderItem table for the new order 
-- SELECT * FROM OrderItem WHERE order_id = (SELECT MAX(order_id) FROM CustomerOrder);

-- -- ensure that the inventory has been updated to reflect the ingredient usage for the order. 
-- SELECT * FROM Inventory WHERE ingredient_id IN (
-- 		SELECT ingredient_id FROM MenuIngredient WHERE menu_id = 1
-- );

-- -- OrderSummary view to view complete order information
-- SELECT * FROM OrderSummary WHERE CustomerName = 'John Doe';
