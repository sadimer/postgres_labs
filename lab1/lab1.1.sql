SELECT airport_code, airport_name, city, coordinates, timezone FROM 
(SELECT *, SQRT(POW(coordinates[0] - cd0_msk, 2) + POW(coordinates[1] - cd1_msk, 2)) as dst
 FROM airports_data AS ap,
 (SELECT AVG(coordinates[0]) AS cd0_msk, AVG(coordinates[1]) AS cd1_msk 
  FROM airports_data AS airp
  WHERE airp.city -> 'en' = '"Moscow"') as ap_msk) as tmp
WHERE dst IN
(SELECT MAX(dst) FROM
 (SELECT SQRT(POW(coordinates[0] - cd0_msk, 2) + POW(coordinates[1] - cd1_msk, 2)) as dst
  FROM airports_data AS ap,
  (SELECT AVG(coordinates[0]) AS cd0_msk, AVG(coordinates[1]) AS cd1_msk
    FROM airports_data AS airp
    WHERE airp.city -> 'en' = '"Moscow"') as ap_msk) as tmp);