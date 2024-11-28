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

/* As a manager, I want to see the menu items that need to be restocked 
so that I can order the correct items. */

-- use the InventorySummary view and filter to view Low Stock status. 
-- SELECT * FROM InventorySummary WHERE StockStatus = 'Low Stock';

/* As a manager, I want to see the total price I will need to resupply
	stock so that I can calculate the total amount spent on ingredients.
*/

-- assume the target quantity is 100 units for each ingredient.
-- calculates the cost of resupplying each ingredient and sums
-- up the total.
-- SELECT 
-- 	ingredient_name AS IngredientName, -- name of ingredient
--     ingredient_cost AS CostPerUnit,	   -- cost per unit of ingredient
--     CASE 
-- 		-- calculate the quantity needed to reach the desired stock level (100 units).
-- 		WHEN 100 - quantity > 0 THEN 100 - quantity 
--         ELSE 0	-- if the stock is already sufficient, then no quantity is needed. 
-- 	END AS QuantityToOrder,
--     (CASE  
-- 		-- calculate the total cost for the quantity to be orderd. 
-- 		WHEN 100 - quantity > 0 THEN 100 - quantity
--         ELSE 0 -- if no additional quantity is needed, then the total cost is 0. 
-- 	END * ingredient_cost) AS TotalCost	-- multiply the quantity to order by the cost per unit for total cost.
-- FROM 
-- 	Inventory; 
    
-- to calculate the total cost for ALL ingredients to the target level
-- SELECT 
-- 	-- for each ingredient, calculate the cost to reach the target level (100 units)
-- 	SUM(CASE
-- 		WHEN 100 - quantity > 0 THEN (100 - quantity) * ingredient_cost
--         ELSE 0 -- if no additional quantity is needed, the cost is 0 for that ingredient
-- 	END) AS TotalResupplyCost	-- sum up the costs for all the ingredients
-- FROM 
-- 	Inventory; 

/* As an 
employee, I want to be assigned to a customer’s order to avoid 
conflicts with other employees when handling and creating orders. */

-- stored procedure assigns an employee to an order:
-- DELIMITER //

-- CREATE PROCEDURE AssignEmployeeToOrder (
-- 	IN p_order_id INT, -- the order assigned to the employee
--     IN p_employee_id INT -- the employee assigned to the order
-- )
-- BEGIN
-- 	DECLARE v_existing_employee INT;
--     
--     -- check if the order has already been assigned to another employee
--     SELECT employee_id INTO v_existing_employee
--     FROM CustomerOrder
--     WHERE order_id = p_order_id; 
--     
--     -- if the order is already assigned, display an error message
--     IF v_existing_employee IS NOT NULL AND v_existing_employee != p_employee_id THEN
-- 		SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'This order has already been assigned to another employee.';
-- 	END IF;
--     
--     -- assign the order to an employee
--     UPDATE CustomerOrder
--     SET employee_id = p_employee_id
--     WHERE order_id = p_order_id;
--     
--     -- confirm the assignement
--     SELECT CONCAT('Order ', p_order_id, ' has been assigned to employee ', p_employee_id) AS AssignmentStatus;
-- END //
--  
-- DELIMITER ; 

-- CALL AssignEmployeeToOrder(1, 2); -- assigns Employee 2 to order 1. 

-- CALL AssignEmployeeToOrder(1, 3); -- attempt to assign Employee 3 to Order 1 (error).

-- To confrim which orders are assigned to employees
-- SELECT 
-- 	o.order_id AS OrderID,
--     e.employee_name AS EmployeeName,
--     c.customer_name AS CustomerName,
--     o.order_date AS OrderDate,
--     os.status_name AS OrderStatus
-- FROM 
-- 	CustomerOrder o 
-- LEFT JOIN 
-- 	Employee e ON o.employee_id = e.employee_id
-- JOIN 
-- 	Customer c ON o.customer_id = c.customer_id
-- JOIN 
-- 	OrderStatus os ON o.order_status_id = os.status_id
-- ORDER BY 
-- 	o.order_date ASC;

/* as an employee, I want to view my customer’s order I am
 assigned to, so I prepare the right order on time.
*/

-- create a view for employees to access their assigned orders.
-- CREATE VIEW AssignedOrders AS
-- SELECT 
--     o.order_id AS OrderID,
--     c.customer_name AS CustomerName,
--     o.order_date AS OrderDate,
--     os.status_name AS OrderStatus,
--     o.delivery_type AS DeliveryType,
--     o.delivery_address AS DeliveryAddress,
--     o.total_amount AS TotalAmount,
--     e.employee_name AS EmployeeName 
-- FROM 
--     CustomerOrder o
-- JOIN 
--     Customer c ON o.customer_id = c.customer_id
-- JOIN 
--     OrderStatus os ON o.order_status_id = os.status_id
-- LEFT JOIN 
-- 	Employee e ON o.employee_id = e.employee_id;

-- shows all assigned orders
-- SELECT * FROM AssignedOrders;

-- filter orderes by an employees name
-- SELECT * FROM AssignedOrders WHERE EmployeeName = 'Charlie Davis';

-- views orders without assigned employees
-- CALL AddNewOrder(
--     5, -- customer_id (e.g., micheal johnson)
--     NULL, -- employee_id (no employee assigned)
--     1, -- order_status_id (e.g., 'Received')
--     'delivery', -- delivery_type
--     '456 Elm Street', -- delivery_address
--     2, -- menu_id (e.g., cheese pizza)
--     1, -- quantity
--     'Medium' -- size
-- );
-- SELECT * FROM AssignedOrders WHERE EmployeeName IS NULL;  -- retrives all unassigned orders.

/* as a manager, I want to assign my employees to open shifts 
to manage the operations at my restaurant efficiently. 
*/

-- create a procedure to assign an employee to an open shift. 
-- DELIMITER // 
-- CREATE PROCEDURE AssignEmployeeToShift (
-- 		IN p_shift_id INT, -- shift to be assigned
--         IN p_employee_id INT -- employee assigned being assigned 
-- )	
-- BEGIN 
-- 	DECLARE v_existing_employee INT;	-- check if a shift has already been taken
--     DECLARE v_start_time TIME;	-- start time of the shift being assigned.
--     DECLARE v_end_time TIME;	-- end time of the shift being assigned
--     DECLARE v_date DATE;	-- date of the shift being assigned
--     DECLARE v_conflict_count INT;	-- number of conflicting shifts
--     
--     -- check if a shift is already assigned to an employee.
--     SELECT employee_id INTO v_existing_employee
--     FROM Shift 
--     WHERE shift_id = p_shift_id ;
--     
--     -- if the shift is already assigned, raise an error 
--     IF v_existing_employee IS NOT NULL THEN
-- 		SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'This shift has already been assigned';
-- 	END IF; 
--     
--     -- retrieve details of the shift being assigned 
--     SELECT shift_date, start_time, end_time
--     INTO v_date, v_start_time, v_end_time
--     FROM Shift 
--     WHERE shift_id = p_shift_id;
--     
--     -- check for conflicts with employee's existing shifts. 
--     SELECT COUNT(*)
--     INTO v_conflict_count
-- 	FROM Shift 
--     WHERE employee_id = p_employee_id
-- 		AND shift_date = v_date -- same date
--         AND (v_start_time < end_time AND v_end_time > start_time); -- time overlap.
--         
-- 	IF v_conflict_count > 0 THEN 
-- 		SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'Employee has a conflicting shift on the same date.';
-- 	END IF;
--     
--     -- assign employee to the shift. 
--     UPDATE Shift 
--     SET employee_id = p_employee_id 
--     WHERE shift_id = p_shift_id;
--     
--     -- confirm the assignment 
--     SELECT CONCAT('Shift ', p_shift_id, ' has been assigned to Employee ', p_employee_id) AS AssignmentStatus;
--     
-- END //

-- DELIMITER ;

-- -- list all avaliable shifts 
-- SELECT *
-- FROM Shift
-- WHERE employee_id IS NULL;
