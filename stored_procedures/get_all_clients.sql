DROP PROCEDURE IF EXISTS get_clients;

use sql_invoicing;
DELIMITER $$
CREATE PROCEDURE get_all_clients()
BEGIN
	SELECT * FROM clients;
END$$
DELIMITER ;

select * from clients;

use northwind;
select upper(ProductName), UnitPrice
from Products order by ProductName;

-- ltrim, rtrim, trim
-- replace
-- left, right
-- , substring(column, start, length) (or mid, or substr)
-- locate, instr

select 
	FirstName
	, instr(Notes, '(') as PositionOfOpenBracket
    , instr(Notes, ')') as PositionOfCloseBracket
    , instr(Notes, ')') - instr(Notes, '(')
    , substring(Notes, instr(Notes, '('), instr(Notes, ')') - instr(Notes, '(') + 1) as Subs
    , Notes
from Employees
-- where instr(Notes, '(') > 0;
where length(substring(Notes, instr(Notes, '('), instr(Notes, ')') - instr(Notes, '(') + 1)) <= 1;


