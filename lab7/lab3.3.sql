DROP FUNCTION IF EXISTS income_rub;
CREATE OR REPLACE FUNCTION income_rub(IN OUT ph_name text, OUT ph_addr text, OUT income_rub numeric) 
RETURNS SETOF record AS $$
DECLARE 
	curs CURSOR FOR SELECT availability.ph_address, SUM(price_rub::numeric * (("prev shipment information"->>'quantity')::numeric - quantity::numeric))
	AS income_rub FROM availability WHERE availability.ph_name = $1
	GROUP BY availability.ph_address;
BEGIN
	FOR x in curs LOOP
		RETURN QUERY SELECT ph_name, x.ph_address, x.income_rub;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM income_rub('Норма');


DROP FUNCTION IF EXISTS shipment;
CREATE OR REPLACE FUNCTION shipment(IN OUT ph_name text, IN sh_date text, IN max_shipment_num integer, OUT med_name text, OUT quantity integer, OUT price_rub integer, OUT prev_sh jsonb, OUT next_sh jsonb)
RETURNS SETOF record AS $$
DECLARE
	curs CURSOR FOR SELECT * FROM availability WHERE availability.ph_name = $1 AND "shipment information"->>'date' = $2;
	new_sh_date date;
	cur_shipment_num integer;
	line record;
	sh_inf text;
BEGIN
	cur_shipment_num = 0;
	IF max_shipment_num <= 0 THEN 
		RAISE EXCEPTION 'Number of max_shipment_num should be positive';
	new_sh_date = (SELECT MIN(("shipment information"->>'expiration date')::date) FROM availability 
	WHERE availability.ph_name = $1 AND "shipment information"->>'date' = $2)::date;
	ELSE
		OPEN curs;
		WHILE cur_shipment_num <= max_shipment_num LOOP
			FETCH curs INTO line;
			IF line IS NULL THEN EXIT;
			END IF;
			cur_shipment_num = cur_shipment_num + (line."shipment information"->>'quantity')::integer;
			UPDATE availability SET "prev shipment information" = line."shipment information" WHERE CURRENT OF curs;
			UPDATE availability SET quantity = availability.quantity + (line."shipment information"->>'quantity')::integer WHERE CURRENT OF curs;
			sh_inf = format('{"expiration date": "%s"}', (new_sh_date + '1 year'::interval)::date::text);
			UPDATE availability SET "shipment information" = line."shipment information" || sh_inf::jsonb;
			sh_inf = format('{"date": "%s"}', new_sh_date::text);
			UPDATE availability SET "shipment information" = line."shipment information" || sh_inf::jsonb;
		END LOOP;
		
		CLOSE curs;
	END IF;
	FOR x in curs LOOP
		RETURN QUERY SELECT x.ph_name, x.med_name, x.quantity, x.price_rub, x."prev shipment information", x."shipment information";
	END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM shipment('Норма', '29.08.2023', 10000);
