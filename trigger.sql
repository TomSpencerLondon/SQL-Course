use sql_invoicing;

DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
	state CHAR(2)
)
BEGIN
		SELECT * FROM clients c
        WHERE c.state = state;
END $$
DELIMITER ;

call get_clients_by_state('CA');

-- Write a stored procedure to return invoices
-- for a given client
-- 
-- get_invoices_by_client

DELIMITER $$
CREATE PROCEDURE get_invoices_by_client
(
	client_id INT
)
BEGIN
	SELECT * from invoices i
    WHERE i.client_id = client_id;
END $$
DELIMITER ;


-- Parameters with default value
DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
	state CHAR(2)
)
BEGIN
	IF state is null then
		set state = 'CA';
    end if;
	
    SELECT * FROM clients c
	WHERE c.state = state;
END $$
DELIMITER ;

CALL get_clients_by_state(NULL);


DROP PROCEDURE IF EXISTS get_clients_by_state;
DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
	state CHAR(2)
)
BEGIN
	SELECT * FROM clients c
	WHERE c.state = IFNULL(state, c.state);
END $$
DELIMITER ;

CALL get_clients_by_state(NULL);


-- Write a stored procedure called get_payments
-- with two parameters
--
-- 		client_id => INT(4)
-- 		payment_method_id => TINYINT(1) 0 - 255

DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments
(
	client_id INT(4),
    payment_method_id TINYINT(1)
)
BEGIN
	SELECT * FROM payments p
    WHERE p.client_id = IFNULL(client_id, p.client_id)
    AND payment_method = IFNULL(payment_method_id, p.payment_method);
END $$
DELIMITER ;

call get_payments(NULL, 2);

DROP PROCEDURE IF EXISTS make_payment;
DELIMITER $$
CREATE procedure make_payment(
	invoice_id INT,
    payment_amount DECIMAL(9, 2),
    payment_date DATE
)
BEGIN
	if payment_amount <= 0 THEN
		SIGNAL SQLSTATE '22003' 
        SET MESSAGE_TEXT = 'Invalid payment amount';
	end if;

	UPDATE invoices i
    SET
		i.payment_total = payment_amount,
        i.payment_date = payment_date
	WHERE i.invoice_id = invoice_id;
END $$
DELIMITER ;


-- User of session variables
SET @invoices_count = 0;

-- Local variable


SELECT 
	client_id,
	name,
    get_risk_factor_for_client(client_id) as risk_factor
FROM clients;

DROP FUNCTION IF EXISTS get_risk_factor_for_client;



DELIMITER $$

CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
	SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
END $$
DELIMITER ;

SHOW triggers;


-- create a trigger that gets fired when we delete a payment
INSERT INTO payments
VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1);

DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_delete;
CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
	SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW());
END $$
DELIMITER ;

DELETE FROM payments
WHERE payment_id = 5;

select * from invoices;


use sql_invoicing;

CREATE table payments_audit
(
	client_id 		INT 			NOT NULL,
    date 			DATE 			NOT NULL,
    amount			DECIMAL(9,2)	NOT NULL,
    action_type		VARCHAR(50)		NOT NULL,
    action_date		DATETIME		NOT NULL
);




DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_insert;

CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
	SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW());
END $$
DELIMITER ;


insert into payments
values(default, 5, 3, '2019-01-01', 10, 1);








