SELECT DISTINCT flight_no, departure_airport, arrival_airport, (dst<@>src) * 1.609 AS dst, "range" FROM flights 
INNER JOIN (SELECT coordinates AS dst, airport_code FROM airports) AS tmp1 ON arrival_airport = tmp1.airport_code 
INNER JOIN (SELECT coordinates AS src, airport_code FROM airports) AS tmp2 ON departure_airport = tmp2.airport_code
INNER JOIN (SELECT * FROM aircrafts_data) AS tmp3 USING(aircraft_code)
WHERE (dst<@>src) * 1.609 > "range" * 0.8;