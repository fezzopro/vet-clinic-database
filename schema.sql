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
    id serial NOT NULL,
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

-- CREATE TABLE owners
CREATE TABLE IF NOT EXISTS owners
(
    id serial NOT NULL,
    full_name character(50) NOT NULL,
    age integer,
    CONSTRAINT owners_primary_key PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE IF EXISTS owners
    OWNER to postgres;

-- CREATE TABLE species
CREATE TABLE IF NOT EXISTS species
(
    id serial NOT NULL,
    name character(50) NOT NULL,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE IF EXISTS species
    OWNER to postgres;

-- REMOVE species COLUMN FROM animals TABLE
ALTER TABLE IF EXISTS animals DROP COLUMN IF EXISTS species;

-- ADD species_id COLUMN TO animals TABLE
ALTER TABLE IF EXISTS animals
    ADD COLUMN IF NOT EXISTS species_id integer;

-- ADD species_foreign_key AS FOREIGN KEY TO species TABLE
ALTER TABLE IF EXISTS animals
    ADD CONSTRAINT species_foreign_key FOREIGN KEY (species_id)
    REFERENCES species (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

-- ADD owners_foreign_key AS FOREIGN KEY TO owners TABLE
ALTER TABLE IF EXISTS animals
    ADD COLUMN IF NOT EXISTS owner_id integer;
ALTER TABLE IF EXISTS animals
    ADD CONSTRAINT owners_foreign_key FOREIGN KEY (owner_id)
    REFERENCES owners (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

-- CREATE TABLE vets
CREATE TABLE IF NOT EXISTS vets
(
    id serial NOT NULL,
    name character(50) NOT NULL,
    age integer,
    date_of_graduation date,
    PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
);

ALTER TABLE IF EXISTS vets
    OWNER to postgres;

-- CREATE TABLE specializations
-- ADD CONSTRAINT AND (vet_id, species_id) AS UNIQUE KEY
CREATE TABLE specializations
(
    id serial NOT NULL,
    vet_id integer NOT NULL,
    species_id integer NOT NULL,
    CONSTRAINT "specializations_PK" PRIMARY KEY (id),
    CONSTRAINT "vet_FK" FOREIGN KEY (vet_id)
        REFERENCES vets (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "species_FK" FOREIGN KEY (species_id)
        REFERENCES species (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
WITH (
    OIDS = FALSE
);
ALTER TABLE IF EXISTS specializations
    ADD CONSTRAINT "specializations_UQ" UNIQUE (vet_id, species_id);

ALTER TABLE IF EXISTS specializations
    OWNER to postgres;

-- CREATE TABLE visits
-- ADD CONSTRAINT AND (vet_id, animal_id) AS UNIQUE KEY
CREATE TABLE visits
(
    id serial NOT NULL,
    vet_id integer NOT NULL,
    animal_id integer NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (vet_id, animal_id),
    FOREIGN KEY (vet_id)
        REFERENCES vets (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    FOREIGN KEY (animal_id)
        REFERENCES animals (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
WITH (
    OIDS = FALSE
);

ALTER TABLE IF EXISTS visits
    OWNER to postgres;
-- ALTER TABLE TO ADD VISIT DATE
ALTER TABLE IF EXISTS visits
    ADD COLUMN IF NOT EXISTS visit_date date;