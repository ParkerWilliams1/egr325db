-- stored procedure to add new order, check availability of ingredients, 
-- adjust the inventory levels, and insert the order into the database.
DELIMITER //

CREATE PROCEDURE AddNewOrder (
    IN p_customer_id INT, -- ID of the customer placing the order
    IN p_employee_id INT, -- ID of the employee handling the order
    IN p_order_status_id INT, -- current status of the order (e.g., Received, Completed)
    IN p_delivery_type ENUM('delivery', 'pickup'), -- type of the order: delivery or pickup
    IN p_delivery_address VARCHAR(255), -- address for delivery orders (NULL for pickup)
    IN p_menu_id INT, -- ID of the menu item being ordered
    IN p_quantity INT, -- quantity of the menu item being ordered
    IN p_size ENUM('Small', 'Medium', 'Large', 'X-Large') -- size of the menu item
)
BEGIN
    -- declare variables to store values
    DECLARE v_price DECIMAL(10, 2); -- price of the menu item
    DECLARE v_total_amount DECIMAL(10, 2); -- total cost of the order
    DECLARE v_ingredient_id INT; -- ID of the ingredient required for the menu item
    DECLARE v_quantity_needed INT; -- quantity of the ingredient needed per item
    DECLARE v_stock INT; -- current stock of the ingredient in inventory

    -- fetch the price of the menu item and details of the required ingredient
    SELECT price, ingredient_id, quantity_needed
    INTO v_price, v_ingredient_id, v_quantity_needed
    FROM MenuItem
    WHERE menu_item_id = p_menu_id;

    -- check if sufficient stock of the ingredient is available
    SELECT quantity INTO v_stock
    FROM Inventory
    WHERE ingredient_id = v_ingredient_id;

    -- if stock is insufficient, raise an error and terminate the procedure
    IF v_stock < (v_quantity_needed * p_quantity) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient inventory for the order';
    END IF;

    -- deduct the required quantity of the ingredient from the inventory
    UPDATE Inventory
    SET quantity = quantity - (v_quantity_needed * p_quantity)
    WHERE ingredient_id = v_ingredient_id;

    -- calculate the total cost of the order
    SET v_total_amount = v_price * p_quantity;

    -- insert a new order into the CustomerOrder table
    INSERT INTO CustomerOrder (
        customer_id, order_status_id, employee_id, delivery_type, delivery_address, total_amount
    )
    VALUES (
        p_customer_id, p_order_status_id, p_employee_id, p_delivery_type, p_delivery_address, v_total_amount
    );

    -- insert the ordered item into the OrderItem table
    INSERT INTO OrderItem (
        order_id, menu_id, size, quantity
    )
    VALUES (
        LAST_INSERT_ID(), -- Retrieve the ID of the newly inserted order
        p_menu_id,        -- Menu item being ordered
        p_size,           -- Size of the menu item
        p_quantity        -- Quantity of the menu item
    );
END //

DELIMITER ;

-- -- uses the procedure to add a new order.
-- CALL AddNewOrder (
-- 	1, -- customer id
--     2, -- employee_id
--     1, -- 'Recieved' order status
--     'delivery', -- type of order
--     '123 Main Street', -- address
--     1, -- menu id (pepperoni pizza)
--     3, -- quantity
--     'Large' -- size
-- );

-- select statements to confirm changes: 

-- -- check new entry for customer order.
-- SELECT * FROM CustomerOrder WHERE customer_id = 1 ORDER BY order_id DESC LIMIT 1;

-- -- check new entry in OrderItem.
-- SELECT * FROM OrderItem WHERE order_id = (SELECT MAX(order_id) FROM CustomerOrder);

-- -- check inventory for pepperoni (ingredient_id: 3)
-- SELECT * FROM Inventory WHERE ingredient_id = 3;

-- -- check inventory for dough (ingredient_id: 4)
-- SELECT * FROM Inventory WHERE ingredient_id = 4;

-- uses invalid data for the procedure. 
-- insufficient inventory error. 
-- CALL AddNewOrder(
--     1,
--     2,
--     1,
--     'delivery',
--     '123 Main Street',
--     1,
--     500, -- exceeds stock
--     'Extra Large' 
-- );

-- function to calculate the total cost of an order. 
DELIMITER //

CREATE FUNCTION CalculateOrderTotal(p_order_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
	DECLARE v_total DECIMAL(10, 2);
    
    -- calculate the total cost by summing up item prices and quantities
    SELECT SUM(mi.price * oi.quantity)
    INTO v_total 
    FROM OrderItem oi
    JOIN MenuItem mi ON oi.menu_id = mi.menu_item_id
    WHERE oi.order_id = p_order_id; 
    
    -- return the calculated total cost 
    RETURN IFNULL(v_total, 0);		-- return zero if no items are found. 
END // 

DELIMITER ;

-- select statement to test changes: 

-- SELECT order_id, CalculateOrderTotal(order_id) AS total_cost
-- FROM CustomerOrder;


-- trigger to automatically update the Inventory table when a new entry is added to the InventoryTransaction table.
DELIMITER //

CREATE TRIGGER trg_update_inventory
AFTER INSERT ON InventoryTransaction
FOR EACH ROW
BEGIN 
	-- check if the transaction is valid
    IF NEW.transaction_type IN ('restock','usage') THEN
		UPDATE Inventory
        SET quantity = quantity + NEW.quantity_change
        WHERE ingredient_id = NEW.ingredient_id;
        
        -- ensure inventory quantity does not go below zero
        IF (SELECT quantity FROM Inventory WHERE ingredient_id = NEW.ingredient_id) < 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Inventory cannot have a negative quantity.';
	END IF; 
	ELSE 
		-- error message for invalid transaction types
	        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Transaction type';
	END IF;
END // 

DELIMITER ;


-- INSERT INTO InventoryTransaction (ingredient_id, quantity_change, transaction_type)
-- VALUES (1, 20, 'restock'); -- Restock 20 units of Cheese

-- INSERT INTO InventoryTransaction (ingredient_id, quantity_change, transaction_type)
-- VALUES (1, -15, 'usage'); -- Use 15 units of Cheese

-- INSERT INTO InventoryTransaction (ingredient_id, quantity_change, transaction_type)
-- VALUES (1, 10, 'invalid'); -- Invalid transaction type

-- INSERT INTO InventoryTransaction (ingredient_id, quantity_change, transaction_type)
-- VALUES (1, -1000, 'usage'); -- Use more units than available

-- custom view to provide detailed order summaries 
CREATE VIEW OrderSummary AS 
SELECT 
	o.order_id AS OrderID,				-- the ID of the order from CustomerOrder
    c.customer_name AS CustomerName,	-- name of the customer from Customer table 
    os.status_name AS OrderStatus, 		-- the status of the order from OrderStatus
    e.employee_name AS EmployeeName,	-- name of the employee handling the order
    CalculateOrderTotal(o.order_id) AS TotalAmount, -- total amount of the order
    o.delivery_type AS DeliveryType,	-- delivery order or pickup from CustomerOrder
    o.delivery_address AS DeliveryAddress	-- deleivery address of a customer. (NULL if pickup)
FROM 
	CustomerOrder o
-- LEFT JOIN ensures the view still works if some optional fields are NULL
LEFT JOIN Customer c ON o.customer_id = c.customer_id	
LEFT JOIN OrderStatus os ON o.order_status_id = os.status_id
LEFT JOIN Employee e ON o.employee_id = e.employee_id;

-- test the custom view:
-- retrieve all orders with their details
-- SELECT * FROM OrderSummary; 

-- orders above a specific amount
-- SELECT * FROM OrderSummary WHERE TotalAmount > 50;

-- only delivery orders
-- SELECT * FROM OrderSummary WHERE DeliveryType = 'delivery';

-- orders handles by a specific employee 
-- SELECT * FROM OrderSummary WHERE EmployeeName = 'Charlie Davis';

-- Trigger to test that user correctly entered only digits for phone number
DELIMITER //

CREATE TRIGGER trg_validate_customer_phone_number_update
BEFORE UPDATE ON Customer
FOR EACH ROW
BEGIN
    -- Ensure phone number does not contain any letters or special characters
    IF NOT (NEW.phone_number REGEXP '^[0-9]{10}$') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Customer phone number cannot contain any letters or special characters.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_validate_customer_phone_number_insert
BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
    -- Ensure phone number does not contain any letters or special characters
    IF NOT (NEW.phone_number REGEXP '^[0-9]{10}$') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Customer phone number cannot contain any letters or special characters.';
    END IF;
END //

DELIMITER ;

/*
-- Valid phone number 
INSERT INTO Customer (customer_name, email_address, phone_number, address) 
VALUES ('John Doe', 'johndoe@example.com', '1234567890', '123 Main St, Springfield, IL 62701');

-- Invalid phone number with letters
INSERT INTO Customer (customer_name, email_address, phone_number, address) 
VALUES ('Jane Doe', 'janedoe@example.com', '12345ae567', '456 Oak St, Springfield, IL 62702');

-- Invalid phone number with special characters
INSERT INTO Customer (customer_name, email_address, phone_number, address) 
VALUES ('Alice Smith', 'alice@example.com', '1234!@#567', '789 Pine St, Springfield, IL 62703');
*/

-- Trigger to test that employees correctly entered only digits for phone number
DELIMITER //

CREATE TRIGGER trg_validate_employee_phone_number_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    -- Ensure phone number does not contain any letters or special characters
    IF NOT (NEW.phone_number REGEXP '^[0-9]{10}$') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Customer phone number cannot contain any letters or special characters.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_validate_employee_phone_number_insert
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    -- Ensure phone number does not contain any letters or special characters
    IF NOT (NEW.phone_number REGEXP '^[0-9]{10}$') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Customer phone number cannot contain any letters or special characters.';
    END IF;
END //

DELIMITER ;

/*
-- Valid phone number
INSERT INTO Employee (employee_name, email_address, phone_number, hire_date, role, wage) 
VALUES ('John Doe', 'johndoe@example.com', '1234567890', '2024-12-05', 'Employee', 15.00);

-- Invalid phone number with letters
INSERT INTO Employee (employee_name, email_address, phone_number, hire_date, role, wage) 
VALUES ('Jane Doe', 'janedoe@example.com', '12345ae567', '2024-12-05', 'Employee', 16.00);

-- Invalid phone number with special characters
INSERT INTO Employee (employee_name, email_address, phone_number, hire_date, role, wage) 
VALUES ('Alice Smith', 'alice@example.com', '1234!@#567', '2024-12-05', 'Manager', 20.00);
*/

-- Stored procedure to add new employees
DELIMITER //
CREATE PROCEDURE AddNewEmployee (
	IN newName VARCHAR(100),
    IN newEmail VARCHAR(150),
    IN newPhone VARCHAR(10),
    IN hireDate DATE,
    IN assignedRole ENUM('Manager', 'Employee'),
    IN assignedWage DECIMAL(10, 2)
)
BEGIN
	IF newEmail IS NULL THEN
		INSERT INTO employee (employee_name, phone_number, hire_date, role, wage)
        VALUES (newName, newPhone, hireDate, assignedRole, assignedWage);
	ELSE
		INSERT INTO employee (employee_name, email_address, phone_number, hire_date, role, wage)
        VALUES (newName, newEmail, newPhone, hireDate, assignedRole, assignedWage);
	END IF;
END //

DELIMITER ;

-- Stored Procedure to schedule employees to shift
DELIMITER //
CREATE PROCEDURE AssignEmployeeToShift(
	IN employeeID Int,
    IN shiftDate DATE,
    IN startTime TIME,
    IN endTime TIME
)
BEGIN
	INSERT INTO shift (shift_date, start_time, end_time, employee_id)
    VALUES (shiftDate, startTime, endTime, employeeID);
END //
DELIMITER ;