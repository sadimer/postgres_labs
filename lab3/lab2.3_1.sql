SELECT DISTINCT "commercial_name", "num", "type", min("price_rub") as "price_rub", "telephone", "address", 
 "opening_time", "closing_time" FROM availability
INNER JOIN 
(SELECT "telephone", "address", "opening_time", "closing_time", "id_ph" 
 FROM pharmacies
 WHERE "address" = 'Тверская-Ямская 1-я, 25 ст1') 
 AS ph USING(id_ph)
INNER JOIN 
(SELECT "id_modification", "commercial_name", "num", "type"
 FROM modification_of_medicines
 INNER JOIN type_of_packaging ON "id" = "id_pack") 
 AS modif ON "id_modification" = "id_mod"
WHERE "quantity" > 0
GROUP BY "commercial_name", "num", "type", "telephone", "address", 
 "opening_time", "closing_time";
