DROP PROCEDURE IF EXISTS get_clients;

use sql_invoicing;
DELIMITER $$
CREATE PROCEDURE get_all_clients()
BEGIN
	SELECT * FROM clients;
END$$
DELIMITER ;

select * from clients;