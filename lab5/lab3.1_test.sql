CREATE TABLE pharmacies (
	"id_ph" SERIAL,
	"name" text,	 
	"specialization" text,
	"contact information" jsonb
);

CREATE TABLE medecines (
	"id_med" SERIAL,
	"commercial_name" text,
	"international_nonproprietary_name" text,
	"indications" text, -- может отсутствовать
	"contraindications" text, -- может отсутствовать в описании
	"drug_route" text,  -- может отсутствовать в описании
	"need_for_a_recipe" bool, 
	"side_effects" text, -- может отсутствовать
	"group_of_medecines" text[],
	"manufacturer" text,
	"pack_info" jsonb
);

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
); 

ALTER TABLE availability
ADD FOREIGN KEY ("id_mod") REFERENCES medecines ON DELETE CASCADE;

ALTER TABLE availability
ADD FOREIGN KEY ("id_ph") REFERENCES pharmacies ON DELETE CASCADE;

ALTER TABLE availability
ADD PRIMARY KEY ("id_rec");

ALTER TABLE medecines
ADD PRIMARY KEY ("id_med");

ALTER TABLE pharmacies
ADD PRIMARY KEY ("id_ph");
