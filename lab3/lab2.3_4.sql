WITH arb AS 
(SELECT * FROM availability WHERE id_mod IN
(SELECT id_modification FROM modification_of_medicines
WHERE commercial_name = 'Арбидол' AND num = 10))

UPDATE availability SET quantity = "sum" FROM (SELECT sum(tmp2.quantity)/3 as "sum" FROM
(SELECT * FROM (SELECT quantity, id_ph FROM arb ORDER BY quantity DESC LIMIT 1) AS tmp1
UNION ALL
SELECT quantity, id_ph FROM arb ORDER BY quantity ASC LIMIT 3) AS tmp2) AS tmp3
WHERE id_ph IN (SELECT id_ph FROM
(SELECT * FROM (SELECT quantity, id_ph FROM arb ORDER BY quantity DESC LIMIT 1) AS tmp1
UNION ALL
SELECT quantity, id_ph FROM arb ORDER BY quantity ASC LIMIT 3) AS tmp4) 
AND id_mod IN (SELECT id_mod FROM arb);
