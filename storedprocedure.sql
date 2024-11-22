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

-- uses the procedure to add a new order.
CALL AddNewOrder (
	1, -- customer id
    2, -- employee_id
    1, -- 'Recieved' order status
    'delivery', -- type of order
    '123 Main Street', -- address
    1, -- menu id (pepperoni pizza)
    3, -- quantity
    'Large' -- size
);

-- select statements to confirm changes: 

-- check new entry for customer order.
SELECT * FROM CustomerOrder WHERE customer_id = 1 ORDER BY order_id DESC LIMIT 1;

-- check new entry in OrderItem.
SELECT * FROM OrderItem WHERE order_id = (SELECT MAX(order_id) FROM CustomerOrder);

-- check inventory for pepperoni (ingredient_id: 3)
SELECT * FROM Inventory WHERE ingredient_id = 3;

-- check inventory for dough (ingredient_id: 4)
SELECT * FROM Inventory WHERE ingredient_id = 4;

-- uses invalid data for the procedure. 
-- insufficient inventory error. 
CALL AddNewOrder(
    1,
    2,
    1,
    'delivery',
    '123 Main Street',
    1,
    500, -- exceeds stock
    'Extra Large' 
);
