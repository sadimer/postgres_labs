CREATE USER test;
GRANT SELECT, UPDATE, INSERT ON availability TO test;
GRANT SELECT, UPDATE("contact information") ON pharmacies TO test;
GRANT SELECT ON medecines TO test;

SELECT rolname FROM pg_roles;

SET ROLE test;

-- SELECT CHECK 1
SELECT * FROM availability 
LIMIT 100;
-- UPDATE CHECK 1
BEGIN;
UPDATE availability SET med_name = 'Какое-то лекарство'
WHERE id_rec = 1;
ROLLBACK;
--INSERT CHECK 1
BEGIN;
INSERT INTO availability (id_rec, id_ph, id_mod, med_name, ph_name, ph_address, recording_date, price_rub, quantity) VALUES
	(100000001, 1, 1, 'Какое-то название лекарства', 'Какое-то название аптеки', 'Какой-то адрес аптеки', current_date, 100, 100);
ROLLBACK;

-- SELECT CHECK 2
SELECT * FROM pharmacies
LIMIT 100;

-- UPDATE CHECK 2
BEGIN;
UPDATE pharmacies SET "contact information" = '{}'
WHERE id_ph = 1;
ROLLBACK;

-- BAD UPDATE CHECK 2
BEGIN;
UPDATE pharmacies SET "name" = 'Новое название' -- ERROR!
WHERE id_ph = 1;
ROLLBACK;

-- BAD INSERT CHECK 2
BEGIN;
INSERT INTO pharmacies ("id_ph", "name", "specialization", "contact information") VALUES
	(1000001, 'Какое-то', 'Какая-то', '{}');
ROLLBACK;

-- SELECT CHECK 3
SELECT * FROM medecines
LIMIT 100;

-- BAD UPDATE CHECK 3
BEGIN;
UPDATE medecines SET commercial_name = 'Новое название'
WHERE id_med = 1;
ROLLBACK;

-- BAD INSERT CHECK 3
BEGIN;
INSERT INTO medecines ("id_med", "commercial_name") VALUES
	(1000001, 'Какое-то');
ROLLBACK;

SET ROLE postgres;


DROP VIEW IF EXISTS moscow_availability;
DROP VIEW IF EXISTS prices_availability;

CREATE OR REPLACE VIEW moscow_availability AS
	SELECT med_name, ph_name, ph_address, recording_date, price_rub, quantity
	FROM availability WHERE strpos("ph_address", 'Москва') != 0
	ORDER BY quantity DESC;
	
CREATE OR REPLACE VIEW prices_availability AS
	SELECT med_name, ph_name, ph_address, recording_date, price_rub, price_rub / 73.28 as price_dollars, price_rub / 83.15 as price_euro, quantity FROM availability; 
	
GRANT SELECT ON prices_availability TO test;

CREATE ROLE new_role;
GRANT SELECT ON moscow_availability TO new_role;
GRANT UPDATE (price_rub, quantity) ON moscow_availability TO new_role;
GRANT new_role TO test;

SELECT rolname FROM pg_roles;
SET ROLE test;

-- SELECT CHECK 1
SELECT * FROM prices_availability 
LIMIT 100;

-- BAD UPDATE CHECK 1
BEGIN;
UPDATE prices_availability SET med_name = 'Какое-то лекарство'
WHERE quantity = 100;
ROLLBACK;

-- BAD INSERT CHECK 1
BEGIN;
INSERT INTO prices_availability (med_name, ph_name, ph_address, recording_date, price_rub, quantity) VALUES
	('Какое-то название лекарства', 'Какое-то название аптеки', 'Какой-то адрес аптеки', current_date, 100, 100);
ROLLBACK;

-- SELECT CHECK 2
SELECT * FROM moscow_availability
LIMIT 100;

-- UPDATE CHECK 2
BEGIN;
UPDATE moscow_availability SET price_rub = 0
WHERE quantity = 100;
ROLLBACK;

-- BAD UPDATE CHECK 2
BEGIN;
UPDATE moscow_availability SET med_name = 'Какое-то лекарство'
WHERE quantity = 100;
ROLLBACK;

-- BAD INSERT CHECK 2
BEGIN;
INSERT INTO moscow_availability (med_name, ph_name, ph_address, recording_date, price_rub, quantity) VALUES
	('Какое-то название лекарства', 'Какое-то название аптеки', 'Какой-то адрес аптеки', current_date, 100, 100);
ROLLBACK;

SET ROLE postgres;
REVOKE ALL ON TABLE moscow_availability FROM new_role;
DROP ROLE IF EXISTS new_role;

DROP OWNED BY test;
DROP ROLE IF EXISTS test;



