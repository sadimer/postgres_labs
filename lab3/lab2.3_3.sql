SELECT "commercial_name", "num", "type", 
"need_for_a_recipe", "group", "indications", "contraindications", "side_effects" 
FROM modification_of_medicines
INNER JOIN type_of_packaging ON "id_pack" = "id"
INNER JOIN 
(SELECT "id_med", "need_for_a_recipe", "group", "indications", "contraindications", "side_effects" FROM medecines
INNER JOIN compliance_of_groups_of_medicines USING("id_med")
INNER JOIN group_of_medicines ON "id" = "id_group"
WHERE strpos("indications", 'грипп') != 0 
OR strpos("indications", 'вирус') != 0
OR strpos("indications", 'ОРВИ') != 0
OR strpos("group", 'вирус') != 0) AS tmp USING("id_med");