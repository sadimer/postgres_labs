UPDATE "pharmacies" SET "id_spec" = (SELECT "id" FROM specialization_of_pharmacies 
WHERE specialization = 'Детских лекарственных средств')
WHERE "address" IN ('Тверская-Ямская 1-я, 25 ст1', 'Ленинский проспект, 74');

DELETE FROM "availability"
WHERE "id_ph" IN (SELECT "id_ph" FROM "pharmacies"
WHERE "address" IN ('Тверская-Ямская 1-я, 25 ст1', 'Ленинский проспект, 74'));
