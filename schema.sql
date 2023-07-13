/* Database schema to keep the structure of entire database. */
-- Database: vet_clinic

-- DROP DATABASE IF EXISTS vet_clinic;

CREATE DATABASE vet_clinic
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_Rwanda.1252'
    LC_CTYPE = 'English_Rwanda.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Table: animals

-- DROP TABLE IF EXISTS.animals;

CREATE TABLE IF NOT EXISTS animals
(
    id integer NOT NULL DEFAULT nextval('animals_id_seq'::regclass),
    name character(100) COLLATE pg_catalog."default" NOT NULL,
    date_of_birth date,
    escape_attempts integer,
    neutered boolean,
    weight_kg numeric,
    CONSTRAINT primary_key PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS animals
    OWNER to postgres;

ALTER TABLE IF EXISTS public.animals
    ADD COLUMN IF NOT EXISTS species character(20);