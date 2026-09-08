USE chatgptecommerce;
PRINT 'Customers';
INSERT INTO customers VALUES
(101, 'Rahul', 'Hyderabad', 'Telangana', '2024-01-15'),
(102, 'Priya', 'Chennai', 'Tamil Nadu', '2024-02-10'),
(103, 'Arjun', 'Bangalore', 'Karnataka', '2024-03-05'),
(104, 'Sneha', 'Hyderabad', 'Telangana', '2024-03-20'),
(105, 'Vikram', 'Mumbai', 'Maharashtra', '2024-04-12'),
(106, 'Ananya', 'Pune', 'Maharashtra', '2024-05-18'),
(107, 'Kiran', 'Bangalore', 'Karnataka', '2024-06-01'),
(108, 'Meena', 'Chennai', 'Tamil Nadu', '2024-06-25'),
(109, 'Ravi', 'Delhi', 'Delhi', '2024-07-10'),
(110, 'Divya', 'Hyderabad', 'Telangana', '2024-08-15');

PRINT '*************************************';
PRINT 'Products';
INSERT INTO products VALUES
(201, 'Laptop', 'Electronics', 65000.00),
(202, 'Smartphone', 'Electronics', 30000.00),
(203, 'Headphones', 'Electronics', 2500.00),
(204, 'Office Chair', 'Furniture', 8500.00),
(205, 'Desk', 'Furniture', 12000.00),
(206, 'Backpack', 'Accessories', 1800.00),
(207, 'Keyboard', 'Electronics', 2200.00),
(208, 'Mouse', 'Electronics', 1200.00),
(209, 'Shoes', 'Fashion', 3500.00),
(210, 'Watch', 'Fashion', 5000.00);

PRINT '*************************************';
PRINT 'Orders';
INSERT INTO orders VALUES
(1001, 101, '2025-01-05', 'Credit Card', 'Delivered'),
(1002, 102, '2025-01-10', 'UPI', 'Delivered'),
(1003, 103, '2025-01-15', 'Debit Card', 'Delivered'),
(1004, 101, '2025-02-02', 'UPI', 'Delivered'),
(1005, 104, '2025-02-15', 'Credit Card', 'Cancelled'),
(1006, 105, '2025-03-01', 'UPI', 'Delivered'),
(1007, 106, '2025-03-12', 'Debit Card', 'Delivered'),
(1008, 103, '2025-03-20', 'Credit Card', 'Delivered'),
(1009, 107, '2025-04-05', 'UPI', 'Delivered'),
(1010, 108, '2025-04-18', 'Credit Card', 'Delivered'),
(1011, 101, '2025-05-01', 'Debit Card', 'Delivered'),
(1012, 109, '2025-05-15', 'UPI', 'Cancelled'),
(1013, 110, '2025-06-03', 'Credit Card', 'Delivered'),
(1014, 105, '2025-06-20', 'UPI', 'Delivered'),
(1015, 102, '2025-07-05', 'Debit Card', 'Delivered');

PRINT '*************************************';
PRINT 'Order_items';
INSERT INTO order_items VALUES
(1, 1001, 201, 1, 0.05),
(2, 1001, 203, 2, 0.10),
(3, 1002, 202, 1, 0.00),
(4, 1002, 208, 1, 0.05),
(5, 1003, 204, 1, 0.10),
(6, 1003, 207, 2, 0.00),
(7, 1004, 209, 2, 0.15),
(8, 1005, 205, 1, 0.05),
(9, 1006, 201, 1, 0.08),
(10, 1006, 208, 2, 0.00),
(11, 1007, 206, 3, 0.10),
(12, 1008, 202, 1, 0.05),
(13, 1008, 203, 1, 0.00),
(14, 1009, 210, 1, 0.20),
(15, 1010, 204, 2, 0.05),
(16, 1011, 201, 1, 0.10),
(17, 1011, 207, 1, 0.00),
(18, 1012, 202, 1, 0.00),
(19, 1013, 205, 1, 0.15),
(20, 1013, 206, 2, 0.05),
(21, 1014, 209, 1, 0.00),
(22, 1014, 210, 1, 0.10),
(23, 1015, 203, 3, 0.05),
(24, 1015, 208, 2, 0.00);

