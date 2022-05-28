DROP INDEX IF EXISTS med_ph_name_index;

EXPLAIN ANALYZE SELECT * FROM availability 
WHERE med_name = 'Ацидекс' AND ph_name = 'Норма';

-- Gather  (cost=1000.00..5551647.80 rows=1288 width=297) (actual time=325.868..184649.029 rows=1343 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on availability  (cost=0.00..5550519.00 rows=537 width=297) (actual time=423.732..184497.808 rows=448 loops=3)
--         Filter: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--         Rows Removed by Filter: 33332886
-- Planning Time: 0.420 ms
-- JIT:
--   Functions: 6
--   Options: Inlining true, Optimization true, Expressions true, Deforming true
--  Timing: Generation 17.883 ms, Inlining 215.967 ms, Optimization 224.583 ms, Emission 124.908 ms, Total 583.341 ms
-- Execution Time: 184664.626 ms
--(12 rows)


CREATE INDEX med_ph_name_index ON availability (med_name, ph_name); -- BTREE

EXPLAIN ANALYZE SELECT * FROM availability
WHERE med_name = 'Ацидекс' AND ph_name = 'Норма';

-- Bitmap Heap Scan on availability  (cost=21.77..5130.61 rows=1288 width=297) (actual time=3.118..949.723 rows=1343 loops=1)
--   Recheck Cond: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--   Heap Blocks: exact=1343
--   ->  Bitmap Index Scan on med_ph_name_index  (cost=0.00..21.45 rows=1288 width=0) (actual time=1.845..1.845 rows=1343 loops=1)
--         Index Cond: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
-- Planning Time: 3.390 ms
-- Execution Time: 951.483 ms
--(7 rows)

-- Bitmap Heap Scan on availability  (cost=21.77..5130.61 rows=1288 width=297) (actual time=2.090..3.266 rows=1343 loops=1)
--   Recheck Cond: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--   Heap Blocks: exact=1343
--   ->  Bitmap Index Scan on med_ph_name_index  (cost=0.00..21.45 rows=1288 width=0) (actual time=1.872..1.873 rows=1343 loops=1)
--         Index Cond: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
-- Planning Time: 0.913 ms
-- Execution Time: 4.259 ms
--(7 rows)

-- Bitmap Heap Scan on availability  (cost=21.77..5130.61 rows=1288 width=297) (actual time=0.363..1.522 rows=1343 loops=1)
--   Recheck Cond: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--   Heap Blocks: exact=1343
--   ->  Bitmap Index Scan on med_ph_name_index  (cost=0.00..21.45 rows=1288 width=0) (actual time=0.152..0.152 rows=1343 loops=1)
--         Index Cond: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
-- Planning Time: 0.074 ms
-- Execution Time: 1.594 ms
--(7 rows)

EXPLAIN ANALYZE SELECT * FROM availability INNER JOIN medecines ON id_med = id_mod 
WHERE price_rub < 1000 AND pack_info ->> 'type' = 'Таблетки';

-- Gather  (cost=254124.04..5732488.76 rows=100431 width=2054) (actual time=267686.054..297941.355 rows=1537246 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Hash Join  (cost=253124.04..5721445.66 rows=41846 width=2054) (actual time=267571.693..289302.333 rows=512415 loops=3)
--         Hash Cond: (availability.id_mod = medecines.id_med)
--         ->  Parallel Seq Scan on availability  (cost=0.00..5446352.33 rows=8369220 width=297) (actual time=1.663..249242.969 rows=6665068 loops=3)
--               Filter: (price_rub < 1000)
--               Rows Removed by Filter: 26668265
--         ->  Parallel Hash  (cost=253098.00..253098.00 rows=2083 width=1757) (actual time=11180.221..11180.222 rows=25664 loops=3)
--               Buckets: 2048 (originally 8192)  Batches: 64 (originally 1)  Memory Usage: 2352kB
--              ->  Parallel Seq Scan on medecines  (cost=0.00..253098.00 rows=2083 width=1757) (actual time=632.021..10885.265 rows=25664 loops=3)
--                     Filter: ((pack_info ->> 'type'::text) = 'Таблетки'::text)
--                     Rows Removed by Filter: 307670
-- Planning Time: 12.155 ms
-- JIT:
--   Functions: 42
--   Options: Inlining true, Optimization true, Expressions true, Deforming true
--   Timing: Generation 25.270 ms, Inlining 361.534 ms, Optimization 945.652 ms, Emission 585.496 ms, Total 1917.951 ms
-- Execution Time: 298055.131 ms
--(19 rows)

DROP INDEX IF EXISTS price_rub_index;
DROP INDEX IF EXISTS pack_info_index;

CREATE INDEX price_rub_index ON availability (price_rub); -- BTREE
CREATE INDEX pack_info_index ON medecines (pack_info);

SET enable_seqscan=FALSE;
EXPLAIN ANALYZE SELECT * FROM availability INNER JOIN medecines ON id_med = id_mod 
WHERE price_rub < 1000 AND pack_info ->> 'type' = 'Таблетки';

-- Gather  (cost=493972.71..5969568.46 rows=100431 width=2054) (actual time=323382.547..355964.280 rows=1537246 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Hash Join  (cost=492972.71..5958525.36 rows=41846 width=2054) (actual time=323323.870..346831.556 rows=512415 loops=3)
--         Hash Cond: (availability.id_mod = medecines.id_med)
--         ->  Parallel Bitmap Heap Scan on availability  (cost=223860.05..5667443.41 rows=8369220 width=297) (actual time=1786.188..314008.800 rows=6665068 loops=3)
--               Recheck Cond: (price_rub < 1000)
--               Rows Removed by Index Recheck: 26306418
--              Heap Blocks: exact=9275 lossy=1365831
--               ->  Bitmap Index Scan on price_rub_index  (cost=0.00..218838.52 rows=20086127 width=0) (actual time=1771.802..1771.803 rows=19995204 loops=1)
--                     Index Cond: (price_rub < 1000)
--         ->  Parallel Hash  (cost=269086.62..269086.62 rows=2083 width=1757) (actual time=1523.297..1523.299 rows=25664 loops=3)
--               Buckets: 2048 (originally 8192)  Batches: 64 (originally 1)  Memory Usage: 2384kB
--               ->  Parallel Index Scan using medecines_pkey on medecines  (cost=0.42..269086.62 rows=2083 width=1757) (actual time=533.922..1207.302 rows=25664 loops=3)
--                     Filter: ((pack_info ->> 'type'::text) = 'Таблетки'::text)
--                     Rows Removed by Filter: 307670
-- Planning Time: 7.152 ms
-- JIT:
--   Functions: 42
--   Options: Inlining true, Optimization true, Expressions true, Deforming true
--   Timing: Generation 15.813 ms, Inlining 335.865 ms, Optimization 874.843 ms, Emission 389.225 ms, Total 1615.747 ms
-- Execution Time: 256067.567 ms
--(22 rows)

SET enable_seqscan=TRUE;

EXPLAIN ANALYZE SELECT * FROM medecines
WHERE to_tsvector('russian', indications) @@ to_tsquery('Грипп & ОРВИ');

-- Gather  (cost=1000.00..461392.17 rows=25 width=1757) (actual time=40.059..56727.487 rows=7767 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on medecines  (cost=0.00..460389.67 rows=10 width=1757) (actual time=37.649..56639.767 rows=2589 loops=3)
--         Filter: (to_tsvector('russian'::regconfig, indications) @@ to_tsquery('Грипп & ОРВИ'::text))
--         Rows Removed by Filter: 330744
-- Planning Time: 32.803 ms
-- JIT:
--   Functions: 6
--   Options: Inlining false, Optimization false, Expressions true, Deforming true
--   Timing: Generation 3.876 ms, Inlining 0.000 ms, Optimization 1.601 ms, Emission 19.919 ms, Total 25.395 ms
-- Execution Time: 56730.374 ms
--(12 rows)

DROP INDEX IF EXISTS text_index;
CREATE INDEX text_index ON medecines USING GIN(to_tsvector('russian', indications));

EXPLAIN ANALYZE SELECT * FROM medecines
WHERE to_tsvector('russian', indications) @@ to_tsquery('Грипп & ОРВИ');

-- Bitmap Heap Scan on medecines  (cost=52.44..164.50 rows=25 width=1757) (actual time=4.409..44.805 rows=7767 loops=1)
--   Recheck Cond: (to_tsvector('russian'::regconfig, indications) @@ to_tsquery('Грипп & ОРВИ'::text))
--   Heap Blocks: exact=7667
--   ->  Bitmap Index Scan on text_index  (cost=0.00..52.44 rows=25 width=0) (actual time=2.895..2.896 rows=7767 loops=1)
--         Index Cond: (to_tsvector('russian'::regconfig, indications) @@ to_tsquery('Грипп & ОРВИ'::text))
-- Planning Time: 4.260 ms
-- Execution Time: 45.170 ms
--(7 rows)


-- Bitmap Heap Scan on medecines  (cost=52.44..164.50 rows=25 width=1757) (actual time=4.352..11.447 rows=7767 loops=1)
--   Recheck Cond: (to_tsvector('russian'::regconfig, indications) @@ to_tsquery('Грипп & ОРВИ'::text))
--   Heap Blocks: exact=7667
--  ->  Bitmap Index Scan on text_index  (cost=0.00..52.44 rows=25 width=0) (actual time=2.825..2.826 rows=7767 loops=1)
--         Index Cond: (to_tsvector('russian'::regconfig, indications) @@ to_tsquery('Грипп & ОРВИ'::text))
-- Planning Time: 0.131 ms
-- Execution Time: 11.770 ms
--(7 rows)

EXPLAIN ANALYZE SELECT * FROM medecines
WHERE group_of_medecines = ARRAY['Психостимуляторы']::text[];

-- Gather  (cost=1000.00..253059.63 rows=33 width=1757) (actual time=8.310..572.000 rows=1475 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on medecines  (cost=0.00..252056.33 rows=14 width=1757) (actual time=29.997..538.424 rows=492 loops=3)
--         Filter: (group_of_medecines = '{Психостимуляторы}'::text[])
--         Rows Removed by Filter: 332842
-- Planning Time: 2.303 ms
-- JIT:
--   Functions: 6
--   Options: Inlining false, Optimization false, Expressions true, Deforming true
--   Timing: Generation 2.214 ms, Inlining 0.000 ms, Optimization 1.697 ms, Emission 21.757 ms, Total 25.669 ms
-- Execution Time: 572.894 ms
--(12 rows)

DROP INDEX IF EXISTS array_index;
CREATE INDEX array_index ON medecines USING GIN(group_of_medecines);


EXPLAIN ANALYZE SELECT * FROM medecines
WHERE group_of_medecines = ARRAY['Психостимуляторы']::text[];

-- Bitmap Heap Scan on medecines  (cost=0.66..4.71 rows=33 width=1757) (actual time=1.643..29.902 rows=1475 loops=1)
--   Recheck Cond: (group_of_medecines = '{Психостимуляторы}'::text[])
--   Rows Removed by Index Recheck: 2863
--   Heap Blocks: exact=4305
--   ->  Bitmap Index Scan on array_index  (cost=0.00..0.65 rows=33 width=0) (actual time=0.834..0.835 rows=4338 loops=1)
--         Index Cond: (group_of_medecines = '{Психостимуляторы}'::text[])
-- Planning Time: 0.363 ms
-- Execution Time: 30.135 ms
--(8 rows)


EXPLAIN ANALYZE SELECT * FROM medecines
WHERE pack_info ->> 'type' = 'Таблетки';

-- Gather  (cost=1000.00..254598.00 rows=5000 width=1757) (actual time=5.508..559.741 rows=76991 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on medecines  (cost=0.00..253098.00 rows=2083 width=1757) (actual time=8.833..511.547 rows=25664 loops=3)
--         Filter: ((pack_info ->> 'type'::text) = 'Таблетки'::text)
--         Rows Removed by Filter: 307670
-- Planning Time: 0.136 ms
-- JIT:
--   Functions: 6
--   Options: Inlining false, Optimization false, Expressions true, Deforming true
--   Timing: Generation 3.028 ms, Inlining 0.000 ms, Optimization 2.014 ms, Emission 24.273 ms, Total 29.314 ms
-- Execution Time: 564.478 ms
--(12 rows)


DROP INDEX IF EXISTS json_index;
CREATE INDEX json_index ON medecines (((pack_info ->> 'type')::text));

EXPLAIN ANALYZE SELECT * FROM medecines
WHERE pack_info ->> 'type' = 'Таблетки';

-- Index Scan using json_index on medecines  (cost=0.42..583.42 rows=5000 width=1757) (actual time=0.055..250.991 rows=76991 loops=1)
--   Index Cond: ((pack_info ->> 'type'::text) = 'Таблетки'::text)
-- Planning Time: 0.075 ms
-- Execution Time: 254.176 ms
--(4 rows)

DROP TABLE availability;

CREATE TABLE availability (
    "id_rec" SERIAL,
	"id_ph" integer,
	"id_mod" integer,
	"med_name" text,
	"ph_name" text,
	"ph_address" text,
	"recording_date" date,
	"prev shipment information" jsonb,
	"price_rub" integer,
	"quantity" integer,
	"shipment information" jsonb
) PARTITION BY RANGE (quantity);

CREATE TABLE IF NOT EXISTS availability_500
PARTITION OF availability FOR VALUES FROM (0) TO (500);
	
CREATE TABLE IF NOT EXISTS availability_1000
PARTITION OF availability FOR VALUES FROM (500) TO (1000);
	
CREATE TABLE IF NOT EXISTS availability_1500
PARTITION OF availability FOR VALUES FROM (1000) TO (1500);
	
CREATE TABLE IF NOT EXISTS availability_2000
PARTITION OF availability FOR VALUES FROM (1500) TO (2000);

CREATE TABLE IF NOT EXISTS availability_2500
PARTITION OF availability FOR VALUES FROM (2000) TO (2500);

CREATE TABLE IF NOT EXISTS availability_3000
PARTITION OF availability FOR VALUES FROM (2500) TO (3000);

CREATE TABLE IF NOT EXISTS availability_3500
PARTITION OF availability FOR VALUES FROM (3000) TO (3500);

CREATE TABLE IF NOT EXISTS availability_4000
PARTITION OF availability FOR VALUES FROM (3500) TO (4000);

CREATE TABLE IF NOT EXISTS availability_4500
PARTITION OF availability FOR VALUES FROM (4000) TO (4500);

CREATE TABLE IF NOT EXISTS availability_5000
PARTITION OF availability FOR VALUES FROM (4500) TO (5000);

CREATE TABLE IF NOT EXISTS availability_10000 -- на всякий
PARTITION OF availability FOR VALUES FROM (5000) TO (10000);

ALTER TABLE availability
ADD FOREIGN KEY ("id_mod") REFERENCES medecines ON DELETE CASCADE;

ALTER TABLE availability
ADD FOREIGN KEY ("id_ph") REFERENCES pharmacies ON DELETE CASCADE;

ALTER TABLE availability
ADD PRIMARY KEY ("id_rec", "quantity");

--ANALYZE;

EXPLAIN ANALYZE SELECT * FROM availability
WHERE med_name = 'Ацидекс' AND ph_name = 'Норма';

-- Gather  (cost=1000.00..4768288.28 rows=1286 width=297) (actual time=421.166..152999.724 rows=1343 loops=1
--)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Append  (cost=0.00..4767159.68 rows=536 width=297) (actual time=466.206..152921.459 rows=4
--48 loops=3)
--        ->  Parallel Seq Scan on availability_10000 availability_11  (cost=0.00..477891.76 rows=54 width=
--297) (actual time=479.411..45447.837 rows=133 loops=1)
--               Filter: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--               Rows Removed by Filter: 10024308
--         ->  Parallel Seq Scan on availability_2000 availability_4  (cost=0.00..476715.29 rows=54 width=29
--7) (actual time=498.656..49466.670 rows=138 loops=1)
--               Filter: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--               Rows Removed by Filter: 9999749
--         ->  Parallel Seq Scan on availability_2500 availability_5  (cost=0.00..476709.21 rows=53 width=29
--7) (actual time=34.554..43768.395 rows=138 loops=1)
--               Filter: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--               Rows Removed by Filter: 9999576
--         ->  Parallel Seq Scan on availability_4000 availability_8  (cost=0.00..476606.85 rows=53 width=29
--7) (actual time=236.025..43870.009 rows=139 loops=1)
--               Filter: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--               Rows Removed by Filter: 9997757
--         ->  Parallel Seq Scan on availability_5000 availability_10  (cost=0.00..476587.16 rows=54 width=297) (actual time=1088.330..44455.427 rows=116 loops=1)
--               Filter: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--               Rows Removed by Filter: 9997509
--         ->  Parallel Seq Scan on availability_1500 availability_3  (cost=0.00..476545.24 rows=53 width=297) (actual time=157.432..44322.729 rows=147 loops=1)
--               Filter: ((med_name = 'Ацидекс'::text) AND (ph_name = 'Норма'::text))
--               Rows Removed by Filter: 9996372
--         ->  Parallel Seq Scan on availability_4500 availability_9  (cost=0.00..476521.30 rows=54 width=297) (actual time=614.862..16658.253 rows=44 loops=3)


EXPLAIN ANALYZE SELECT * FROM availability
WHERE quantity > 700 AND quantity < 900;


-- Index Scan using availability_1000_pkey on availability_1000 availability  (cost=0.43..196982.72 rows=3194982 width=297) (actual time=2.407..9192.585 rows=3184919 loops=1)
--   Index Cond: ((quantity > 700) AND (quantity < 900))
-- Planning Time: 1.655 ms
-- JIT:
--   Functions: 2
--   Options: Inlining false, Optimization false, Expressions true, Deforming true
--   Timing: Generation 0.660 ms, Inlining 0.000 ms, Optimization 0.000 ms, Emission 0.000 ms, Total 0.660 ms
-- Execution Time: 9323.548 ms
--(8 rows)
