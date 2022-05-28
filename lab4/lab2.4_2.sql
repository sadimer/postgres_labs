SET search_path TO public;

CREATE OR REPLACE FUNCTION modification_of_medicines_checker() RETURNS trigger AS $modification_of_medicines_checker$
    BEGIN 
        IF NEW.volume_ml IS NULL AND
        NEW.id_pack IN (SELECT id FROM type_of_packaging WHERE
        "type" = 'Растворы' OR "type" = 'Пасты' OR "type" = 'Настойки' OR "type" = 'Экстракты' OR 
        "type" = 'Спреи' OR "type" = 'Сиропы' OR "type" = 'Гели')
        THEN
			RAISE EXCEPTION 'the volume is not specified!';
        END IF;
        RETURN NEW;
    END;
$modification_of_medicines_checker$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS modification_of_medicines_checker on modification_of_medicines;

CREATE CONSTRAINT TRIGGER modification_of_medicines_checker AFTER INSERT OR UPDATE ON modification_of_medicines
DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE FUNCTION modification_of_medicines_checker();

-- проверка 
-- 1) правильный запрос на вставку
INSERT INTO modification_of_medicines ("id_prod", "id_med", "commercial_name", "num", "id_pack", "weight_mg", "volume_ml") VALUES (
	(SELECT id_prod FROM manufacturers WHERE "name" = 'DELPHARM REIMS (Франция)'),
	(SELECT id_med FROM medecines WHERE international_nonproprietary_name = 'Амброксол'),
	'Лазолван®',
	1,
	(SELECT id FROM type_of_packaging WHERE "type" = 'Сиропы'),
	30,
	50
);

SELECT * FROM modification_of_medicines;

-- 2) запрос вызывающий триггер
INSERT INTO modification_of_medicines ("id_prod", "id_med", "commercial_name", "num", "id_pack", "weight_mg") VALUES (
	(SELECT id_prod FROM manufacturers WHERE "name" = 'DELPHARM REIMS (Франция)'),
	(SELECT id_med FROM medecines WHERE international_nonproprietary_name = 'Амброксол'),
	'Лазолван®',
	1,
	(SELECT id FROM type_of_packaging WHERE "type" = 'Сиропы'),
	200
);
-- если отключить автокоммит надо будет делать ROLLBACK

SELECT * FROM modification_of_medicines;

