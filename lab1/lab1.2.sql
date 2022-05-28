SELECT * FROM airports 
INNER JOIN 
 (SELECT departure_airport AS airport_code, COUNT(departure_airport) AS out_num_of_flights FROM flights AS fl
 INNER JOIN airports_data ON departure_airport = airport_code
 GROUP BY departure_airport
 ORDER BY departure_airport) AS tmp1 USING(airport_code)
INNER JOIN 
 (SELECT arrival_airport AS airport_code, COUNT(arrival_airport) AS in_num_of_flights FROM flights AS fl
 INNER JOIN airports_data ON departure_airport = airport_code
 GROUP BY arrival_airport
 ORDER BY arrival_airport) AS tmp2 USING(airport_code);