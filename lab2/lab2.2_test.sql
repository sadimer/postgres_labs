CREATE TABLE countries (
	"id" SERIAL PRIMARY KEY,
	"name" text NOT NULL
);
CREATE TABLE group_of_medicines (
	"id" SERIAL PRIMARY KEY,
	"group" text NOT NULL
);
CREATE TABLE specialization_of_pharmacies (
	"id" SERIAL PRIMARY KEY,
	"specialization" text NOT NULL
);
CREATE TABLE type_of_packaging (
	"id" SERIAL PRIMARY KEY,
	"type" text NOT NULL
);
CREATE TABLE pharmacies (
	"id_ph" SERIAL PRIMARY KEY, 
	"name" text, -- могут быть сетевые аптеки с одни названием (безымянные аптеки тоже допустимы)
	"telephone" text, -- телефон горячей линии сетевых аптек может быть общий (или не сущестовать)
	"address" text NOT NULL UNIQUE, -- адрес должен быть уникален
	"id_spec" integer REFERENCES specialization_of_pharmacies NOT NULL,
	"opening_time" time without time zone NOT NULL, -- closing_time и opening_time 00:00 - круглосуточно
	"closing_time" time without time zone NOT NULL,
	CHECK ("opening_time" <= "closing_time")
);
CREATE TABLE medecines (
	"id_med" SERIAL PRIMARY KEY,
	"chemical_name" text NOT NULL,
	"international_nonproprietary_name" text NOT NULL,
	"contraindications" text, -- может отсутствовать в описании
	"indications" text, -- может отсутствовать
	"drug_route" text,  -- может отсутствовать в описании
	"need_for_a_recipe" bool NOT NULL, 
	"side_effects" text -- может отсутствовать
);
CREATE TABLE compliance_of_groups_of_medicines (
	"id_med" integer REFERENCES medecines NOT NULL,
	"id_group" integer REFERENCES group_of_medicines NOT NULL,
	PRIMARY KEY ("id_med", "id_group")
);
CREATE TABLE manufacturers (
	"id_prod" SERIAL PRIMARY KEY,
	"id_country" integer REFERENCES countries NOT NULL,
	"quality_sert" bool, -- может быть неизвестен
	"telephone" text, -- может быть неизвестен
	"address" text, -- может быть неизвестен
	"name" text NOT NULL UNIQUE
);
CREATE TABLE modification_of_medicines (
	"id_modification" SERIAL PRIMARY KEY,
	"id_prod" integer REFERENCES manufacturers ON DELETE CASCADE NOT NULL,
	"id_med" integer REFERENCES medecines ON DELETE CASCADE NOT NULL,
	"commercial_name" text NOT NULL,
	"num" integer, -- может быть NULL например в упаковке в виде бутылки или тюбика
	"id_pack" integer REFERENCES type_of_packaging, 
	"weight_mg" numeric NOT NULL, -- вес есть у всех
	"volume_ml" numeric, -- обьем только у специальных упаковок
	CHECK ("weight_mg" >= 0),
	CHECK ("volume_ml" >= 0),
	CHECK ("num" >= 0)
);
CREATE TABLE availability (
	"id_ph" integer REFERENCES pharmacies NOT NULL,
	"id_mod" integer REFERENCES modification_of_medicines ON DELETE CASCADE NOT NULL,
	"curr_date" date NOT NULL,
	"expiration_date" date NOT NULL,
	"price_rub" integer NOT NULL,
	"quantity" integer NOT NULL,
	"shipment_date" date, -- может быть неизвестна
	"shipment_quantity" integer, -- может быть неизвестно
	PRIMARY KEY ("id_ph", "id_mod"),
	CHECK ("curr_date" <= "shipment_date"),
	CHECK ("curr_date" <= "expiration_date"),
	CHECK ("shipment_quantity" >= 0),
	CHECK ("quantity" >= 0)
)


