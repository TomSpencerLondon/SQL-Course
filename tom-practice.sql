INSERT INTO customers (
last_name,
first_name,
birth_date,
address,
city,
state)
VALUES (
'Smith',
'John',
'1990-01-01',
'address',
'city',
'CA');

INSERT INTO shippers (name)
VALUES ('Shipper1'),
	   ('Shipper2'),
	   ('Shipper3');

INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('Microwave', 2, 25.50),
	   ('Blender', 4, 15.50),
	   ('Olive Oil', 3, 25.50);
       
UPDATE products
SET unit_price = 8.75
WHERE product_id = 13;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(), 1, 1, 2.95),
	(LAST_INSERT_ID(), 2, 1, 3.95);

INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01';

INSERT INTO invoices_archived
SELECT 
	i.invoice_id,
    i.number,
    c.name,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM invoices i
LEFT JOIN clients c
	ON i.client_id = c.client_id
where i.payment_date is not null;

use sql_store;

create table orders_archived as
SELECT * FROM orders;

INSERT INTO orders_archived
SELECT * FROM orders
WHERE order_date < '2019-01-01';


use sql_invoicing;

select * from invoices_archived;

select name, payment_date from invoices_archived;

SELECT * FROM invoices_archived
	WHERE payment_date > '2019-01-15'
    AND invoice_total > 100;
    
SELECT * from invoices_archived
ORDER BY name DESC, invoice_total DESC;

SELECT * from invoices_archived
LIMIT 1, 3;

SELECT payment_id, client_id, invoice_id, date, amount, pm.name from payments p
join payment_methods pm on pm.payment_method_id = p.payment_method;

SELECT c.name, pm.name FROM clients c 
inner join payments p on
	c.client_id = p.client_id
inner join payment_methods pm on 
	p.payment_method = pm.payment_method_id;

select * from invoices;
SELECT SUM(invoice_total) from invoices where due_date > '2019-03-01';

SELECT c.name, SUM(i.invoice_total) from invoices i
inner join clients c on c.client_id = i.client_id
	group by c.name;

-- get the clients' names by joining the clients table 

UPDATE invoices
	SET payment_total = invoice_total * 0.5,
	payment_date = due_date
WHERE client_id = 3;



