SET search_path TO public;

CREATE OR REPLACE FUNCTION add_to_ph() RETURNS trigger AS $add_to_ph$
    BEGIN 
        INSERT INTO availability ("id_ph", "id_mod", "curr_date", "expiration_date", "price_rub", "quantity", "shipment_date", "shipment_quantity")
		10, 
		NEW.id_modification, 
		current_date,
		current_date - RANDOM() * age(timestamp '2025-01-01'),
		RANDOM() * 1000,
		RANDOM() * 1000 + 10000,
		current_date - RANDOM() * age(timestamp '2022-01-01'),
		RANDOM() * 1000;
		RETURN NEW;
	END;
$add_to_ph$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS add_to_ph on modification_of_medicines;

CREATE CONSTRAINT TRIGGER add_to_ph AFTER INSERT ON modification_of_medicines
DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE FUNCTION add_to_ph();

------------------------------------------------
INSERT INTO modification_of_medicines ("id_prod", "id_med", "commercial_name", "num", "id_pack", "weight_mg", "volume_ml") VALUES (
	(SELECT id_prod FROM manufacturers WHERE "name" = 'DELPHARM REIMS (Франция)'),
	(SELECT id_med FROM medecines WHERE international_nonproprietary_name = 'Амброксол'),
	'Лазолван®',
	1,
	(SELECT id FROM type_of_packaging WHERE "type" = 'Сиропы'),
	30,
	50
);
----------------------------------------------------------------
SELECT * FROM availability WHERE id_ph = 10;
