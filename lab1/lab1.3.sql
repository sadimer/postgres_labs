SELECT * FROM tickets INNER JOIN ticket_flights USING(ticket_no)
WHERE book_ref IN
(SELECT book_ref FROM bookings
 WHERE book_date > '2017-05-11 00:00:00+03' AND book_date < '2017-05-11 00:30:00+03')
INTERSECT
SELECT * FROM tickets INNER JOIN ticket_flights USING(ticket_no)
 WHERE flight_id IN
 (SELECT flight_id FROM flights
  WHERE departure_airport = 'DME')
ORDER BY amount;