-- User story demonstrations 

-- USER STORY 1  
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

-- USER STORY 2
-- As a customer I want to view my order status so I can 
-- easily adjust my routine to the order. 

-- view all orders for a customer 
-- SELECT 	
-- 	o.order_id AS OrderID,
--     o.order_date AS OrderDate,
--     os.status_name AS OrderStatus,
--     o.delivery_type AS DeliveryType,
--     o.delivery_address AS DeliveryAddress,
--     o.total_amount AS TotalAmount
-- FROM 
-- 	CustomerOrder o
-- JOIN 
-- 	OrderStatus os ON o.order_status_id = os.status_id
-- WHERE
-- 	o.customer_id = 1 -- replace 1 with the customers ID. 
-- ORDER BY 
-- 	o.order_date DESC;

/* As a customer, I want to view the menu, so that 
	I know what meals I can pick and order.*/
-- SELECT 
--     mi.menu_item_id AS MenuID,
--     mi.menu_item_name AS ItemName,
--     mi.price AS Price
-- FROM 
--     MenuItem mi;

/* as a manager, I want to see the inventory quantity in the restaurant 
inventory so that I can prevent supply from running out. */

-- custom view for the manager to access inventory details easily
-- CREATE VIEW InventorySummary AS 
-- SELECT 
-- 	ingredient_id AS IngredientID, 
--     ingredient_name AS IngredientName,
--     quantity AS Quantity,
-- 	CASE 
-- 		WHEN quantity < 10 THEN 'Low Stock'
-- 		ELSE 'Sufficient'
-- 	END AS StockStatus
-- FROM 
-- 	Inventory; 
        
-- SELECT * FROM InventorySummary; 
