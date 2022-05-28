SELECT "name", "telephone", "address", "price_rub", "quantity", "opening_time", "closing_time" FROM pharmacies
INNER JOIN
(SELECT "price_rub", "quantity", "id_ph" FROM availability INNER JOIN
(SELECT "id_modification" AS "id_mod" FROM modification_of_medicines
INNER JOIN type_of_packaging ON "id" = "id_pack"
WHERE "commercial_name" = 'Арбидол' AND "num" = 20 AND "type" = 'Капсулы') AS tmp
USING(id_mod)) AS new_tmp USING(id_ph)
WHERE "opening_time" <= '08:30:00' or ("opening_time" = "closing_time");