DELETE FROM manufacturers
WHERE id_prod IN (SELECT id_prod FROM manufacturers INNER JOIN modification_of_medicines USING(id_prod)
WHERE commercial_name = 'Лазолван®' AND (quality_sert = false OR quality_sert IS NULL));