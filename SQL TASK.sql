create database PharmacySchema
use PharmacySchema;


CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    manufacturer VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT NOT NULL
);

INSERT INTO Medicines (medicine_id, name, manufacturer, price, quantity_in_stock)
VALUES
(1, 'Paracetamol', 'Pharma Inc.', 5.50, 100),
(2, 'Amoxicillin', 'HealthCorp', 12.75, 50),
(3, 'Ibuprofen', 'Wellness Pharma', 8.20, 150),
(4, 'Cetirizine', 'AllergyMed', 3.40, 200),
(5, 'Omeprazole', 'DigestWell', 15.00, 80);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);

INSERT INTO Customers (customer_id, name, email, phone)
VALUES
(1, 'John Doe', 'john.doe@example.com', '555-1234'),
(2, 'Jane Smith', 'jane.smith@example.com', '555-5678'),
(3, 'Alice Johnson', 'alice.johnson@example.com', '555-8765'),
(4, 'Bob Brown', 'bob.brown@example.com', '555-4321'),
(5, 'Carol White', 'carol.white@example.com', '555-9876');


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders (order_id, customer_id, order_date)
VALUES
(1, 1, '2024-05-01'),
(2, 2, '2024-05-02'),
(3, 3, '2024-05-03'),
(4, 4, '2024-05-04'),
(5, 5, '2024-05-05');


CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    medicine_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

INSERT INTO Order_Details (order_detail_id, order_id, medicine_id, quantity, total_price)
VALUES
(1, 1, 1, 10, 55.00),
(2, 1, 3, 5, 41.00),
(3, 2, 2, 3, 38.25),
(4, 3, 4, 8, 27.20),
(5, 4, 5, 2, 30.00);


 --1)Create a view to display the names and prices of medicines in stock.
 
CREATE VIEW Medicines_In_Stock AS
SELECT name, price
FROM Medicines
WHERE quantity_in_stock > 0;

Select * from Medicines_In_Stock;


--2)Retrieve the names of customers along with their email addresses who have placed an order after January 1, 2024.

SELECT DISTINCT c.name, c.email
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date > '2024-01-01';
 

--3)List all orders with the total price of each order.

 SELECT o.order_id, SUM(od.total_price) AS total_order_price
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY o.order_id;


--4)Find the total number of orders placed by each customer.

SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;


--5)Trigger to update the quantity of medicines in stock after an order is placed.

CREATE TRIGGER update_medicine_stock
AFTER INSERT ON Order_Details
FOR EACH ROW
BEGIN
  UPDATE Medicines
  SET quantity_in_stock = quantity_in_stock - NEW.quantity
  WHERE medicine_id = NEW.medicine_id;
END;


--6)Retrieve the total number of customers who have ordered more than 5 times.

SELECT COUNT(*) AS customers_with_more_than_5_orders
FROM (
  SELECT c.customer_id
  FROM Customers c
  JOIN Orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id
  HAVING COUNT(o.order_id) > 5
) AS frequent_customers;

