UPDATE availability SET shipment_date = current_date, quantity = quantity + shipment_quantity
WHERE id_mod IN
(SELECT id_modification FROM modification_of_medicines
INNER JOIN
(SELECT id_prod FROM manufacturers
INNER JOIN countries ON "id" = "id_country"
WHERE countries."name" = 'Germany') AS tmp
USING(id_prod))
AND id_ph IN
(SELECT "id_ph" FROM pharmacies
WHERE "address" = 'Тверская-Ямская 1-я, 25 ст1');