CREATE DATABASE MRO; 
USE MRO;

-- Table: Customer
-- stores information about customers.
-- helps track customer details and facilitates order management.
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY, -- unqiue ID for each customer.
    customer_name VARCHAR(100) NOT NULL,        -- customer's full name.
    email_address VARCHAR(150) NOT NULL UNIQUE, -- email must be unique for identification.
    phone_number VARCHAR(10) NOT NULL CHECK (LENGTH(phone_number) = 10), -- phone number must be 10 digits..
    address VARCHAR(255)    -- address for delivery orders. NULL for pickup orders.
);

-- Table: OrderStatus
-- defines the various statuses an order can have.
-- helps ensure consistent order status values across all orders.
CREATE TABLE OrderStatus (
    status_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each status.
    status_name VARCHAR(50) NOT NULL UNIQUE   -- status name, e.g., 'Received', 'Completed','Canceled'.
);

-- Table: Inventory
-- table tracks the ingredients available in stock.
-- helps manage inventory levels and calculate ingredient usage.
CREATE TABLE Inventory (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each ingredient.
    ingredient_name VARCHAR(100) NOT NULL UNIQUE, -- must have unique ingredient names. 
    ingredient_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- cost of each ingredient
    quantity INT DEFAULT 0 CHECK (quantity >= 0)  -- current stock level, must be non-negative.
);

-- Table: Employee
--  table stores information about employees.
-- employees can take orders, prepare food, or make deliveries.
CREATE TABLE Employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each employee.
    employee_name VARCHAR(100) NOT NULL,        -- full name of the employee.
    email_address VARCHAR(150) UNIQUE,          -- email address is optional butmust be unique if present.
    phone_number VARCHAR(10) NOT NULL CHECK (LENGTH(phone_number) = 10), -- 10-digit phone number.
    hire_date DATE NOT NULL,                    -- date the employee was hired.
    role ENUM('Manager', 'Employee') NOT NULL,  -- employee role, either 'Manager' or 'Employee' (all take and make orders + deliver).
    wage DECIMAL(10, 2) NOT NULL CHECK (wage >= 0) -- hourly wage, must be non-negative.
);

-- Table: CustomerOrder
-- table represents customer orders.
-- tracks details of each order, including customer, status, and employee assigned.
CREATE TABLE CustomerOrder (
    order_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each order.
    customer_id INT NOT NULL,                         -- ID of the customer who placed the order.
    order_status_id INT NOT NULL,                     -- status ID of the order (e.g., 'Completed' or 'Cancelled').
    employee_id INT,                         		  -- employee handling the order.
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- timestamp when the order was placed.
    delivery_address VARCHAR(255),          -- delivery address. NULL for pickup orders.
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0), -- total price of the order.
    delivery_type ENUM('delivery', 'pickup') NOT NULL, -- type of order: delivery or pickup.
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE RESTRICT, -- prevent deletion of customer if ordre exists.
    FOREIGN KEY (order_status_id) REFERENCES OrderStatus(status_id) ON DELETE RESTRICT, -- prevents status deletion if referenced.
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE SET NULL -- link to handling employee.
);

-- Table: MenuItem
-- table represents the items on the menu.
-- tracks the price and required ingredients for each menu item.
CREATE TABLE MenuItem (
    menu_item_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each menu item.
    menu_item_name VARCHAR(100) NOT NULL UNIQUE, -- name of the menu item (e.g., 'Cheese Pizza').
    price DECIMAL(10, 2) NOT NULL CHECK(price >= 0), -- price of the menu item.
    ingredient_id INT,                               -- main ingredient ID (optional).
    quantity_needed INT CHECK(quantity_needed > 0) NOT NULL, -- quantity of the main ingredient needed.
    FOREIGN KEY (ingredient_id) REFERENCES Inventory(ingredient_id) ON DELETE SET NULL -- nulled if ingredient deleted.
);

-- Table: OrderItem
-- table tracks individual items in a customer's order.
-- links a menu item to an order, including size and quantity.
CREATE TABLE OrderItem (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each item in the order.
    order_id INT NOT NULL,                                -- order to which the item belongs.
    menu_id INT NOT NULL,                                 -- menu item being ordered.
    size ENUM('Small','Medium','Large','X-Large') NOT NULL,                   -- size of the item (e.g., 'Small', 'Large').
    quantity INT DEFAULT 1 CHECK(quantity > 0),  -- number of items ordered, must be positive.
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id) ON DELETE CASCADE, -- delete items if order deleted.
    FOREIGN KEY (menu_id) REFERENCES MenuItem(menu_item_id) ON DELETE RESTRICT  -- prevent deletion of referenced menu.
);

-- Table: InventoryTransaction
-- table records changes to inventory levels.
-- tracks restocking or usage of ingredients.
CREATE TABLE InventoryTransaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each transaction.
    ingredient_id INT,                                  -- ingredient being restocked or used.
    quantity_change INT NOT NULL,                       -- positive for restock, negative for usage.
    transaction_type ENUM('restock', 'usage') NOT NULL, -- type of transaction.
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- time the transaction occurred.
    FOREIGN KEY (ingredient_id) REFERENCES Inventory(ingredient_id) ON DELETE SET NULL -- retain transaction records if a ingredient is deleted.
);

-- Table: MenuIngredient
-- tracks the relationship between menu items and their ingredients.
-- helps calculate inventory usage for each menu item ordered.
CREATE TABLE MenuIngredient (
    menu_ingredient_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each entry.
    menu_id INT NOT NULL,                              -- menu item ID.
    ingredient_id INT NOT NULL,                        -- ingredient ID.
    quantity_needed INT NOT NULL CHECK (quantity_needed > 0), -- quantity of ingredient required.
    FOREIGN KEY (menu_id) REFERENCES MenuItem(menu_item_id) ON DELETE CASCADE, -- link to the menu item.
    FOREIGN KEY (ingredient_id) REFERENCES Inventory(ingredient_id) ON DELETE CASCADE -- cascade delete if ingredient removed.
);

-- Table: Shift
-- tracks employee shifts and schedules.
CREATE TABLE Shift (
    shift_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each shift.
    shift_date DATE NOT NULL,                -- date of the shift.
    start_time TIME NOT NULL,                -- shift start time.
    end_time TIME NOT NULL,                  -- shift end time.
    employee_id INT,                -- employee assigned to the shift.
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE CASCADE, -- Cascade delete if employee removed.
    CHECK (start_time < end_time)            -- ensure shift start time is before end time.
);

-- Table: Payment
-- tracks payment details for customer orders.
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY, -- unique ID for each payment.
    order_id INT NOT NULL,                     -- associated order ID.
    payment_date DATE NOT NULL,                -- date of payment.
    payment_amount DECIMAL(10, 2) NOT NULL CHECK (payment_amount >= 0), -- payment amount.
    payment_method ENUM('Cash', 'Card', 'Online') NOT NULL, -- payment method used.
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id) ON DELETE CASCADE, -- cascade delete if order removed.
    UNIQUE (order_id)	-- ensure one payment per order.
); 
