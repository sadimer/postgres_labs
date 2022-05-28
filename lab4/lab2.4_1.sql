-- 1) аномалия потерянных изменений в READ UNCOMMITTED
-- 1 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- 2 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- 1 file
UPDATE availability SET quantity = quantity + 10000;

-- 2 file
UPDATE availability SET quantity = quantity + 5000;

-- 1 file
COMMIT;

-- 2 file
COMMIT;
-- +15000 кол-во, 2 юзер ожидет завершения транзакции первого и затем уже добавляет
-- НЕ ДОПУСКАЕТСЯ СТАНДАРТОМ НИ НА ОДНОМ УРОВНЕ

-- 2) аномалия грязного чтения в READ UNCOMMITTED / COMMITED
-- 1 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
UPDATE availability SET quantity = quantity + 10000;

-- 2 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM availability;

-- 1 file 
ROLLBACK;

-- 2 file
COMMIT;

-- В PostgreSQL не допускается

-- 3) аномалия неповторяющегося чтения в READ COMMITTED
-- 1 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 2 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM availability;

-- 1 file
UPDATE availability SET quantity = quantity + 10000;
COMMIT;

-- 2 file
SELECT * FROM availability;

-- 2 file
COMMIT;

-- аномалия есть, данные различаются

-- 4) аномалия неповторяющегося чтения в REPEATABLE READ
-- 1 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- 2 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM availability;

-- 1 file
UPDATE availability SET quantity = quantity + 10000;
COMMIT;

-- 2 file
SELECT * FROM availability;

-- 2 file
COMMIT;

-- 2 file
SELECT * FROM availability;

-- 2 file
COMMIT;

-- аномали нет, выводит те же данные что и в первый раз, 
-- после завершения транзакции если написать SELECT выводит новые

-- 5) аномалия чтения фантомов в REPEATABLE READ / SERIALIZABLE
-- подготовка (полная замена товаров в одной аптеке)
BEGIN;
DELETE FROM availability WHERE id_ph = 9;
COMMIT;

-- 1 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- 2 file
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT avg(quantity) FROM availability;

-- 1 file
INSERT INTO availability ("id_ph", "id_mod", "curr_date", "expiration_date", "price_rub", "quantity", "shipment_date", "shipment_quantity")
	SELECT 9, 
	id_modification, 
	current_date,
	current_date - RANDOM() * age(timestamp '2025-01-01'),
	RANDOM() * 1000,
	RANDOM() * 1000,
	current_date - RANDOM() * age(timestamp '2022-01-01'),
	RANDOM() * 1000
	FROM modification_of_medicines
	WHERE RANDOM() < 0.5;
COMMIT;

-- 2 file
SELECT avg(quantity) FROM availability;

-- 2 file
COMMIT;

-- 2 file
SELECT avg(quantity) FROM availability;

-- 2 file
COMMIT;

-- аномалии нет, запрос выдает тот же результат, измнения доступны только после коммита
