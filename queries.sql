/*Queries that provide answers to the questions from all projects.*/

SELECT *
	FROM animals
	WHERE name LIKE '%mon';

SELECT name
	FROM animals
	WHERE DATE_PART('year', date_of_birth) >= 2016
	AND DATE_PART('year', date_of_birth) <= 2019;

SELECT name
	FROM animals
	WHERE neutered  = 'true'
	AND escape_attempts < 3;

SELECT date_of_birth
	FROM animals
	WHERE name  = 'Agumon'
	OR name = 'Pikachu';

SELECT name, escape_attempts
	FROM animals
	WHERE weight_kg  > '10.5';

SELECT *
	FROM animals
	WHERE neutered = true;

SELECT *
	FROM animals
	WHERE name != 'Gabumon';

SELECT *
	FROM animals
	WHERE weight_kg >= '10.4'
	AND weight_kg <= '17.3';

BEGIN TRANSACTION;
	UPDATE animals SET species= 'unspecified';
	SELECT * FROM animals;
ROLLBACK TRANSACTION;
	SELECT * FROM animals;

BEGIN TRANSACTION;
	UPDATE animals SET species= 'digimon' WHERE TRIM(name) like '%mon';
	UPDATE animals SET species= 'pokemon' WHERE species IS NULL;
	SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN TRANSACTION;
	DELETE FROM animals;
	SELECT * FROM animals;
ROLLBACK TRANSACTION;
SELECT * FROM animals;

BEGIN TRANSACTION;
	DELETE FROM animals
	WHERE date_of_birth > '2022-01-01';
SAVEPOINT my_savepoint;
	UPDATE animals
	SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT my_savepoint;
	UPDATE animals SET weight_kg = weight_kg * -1
	WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;

-- ANALYTICAL QUESTIONS
-- HOW MANY ANIMALS ARE THERE
SELECT COUNT(name) as animals_quantity FROM animals;

-- HOW MANY ANIMALS HAVE NEVER TRIED TO ESCAPE?
SELECT COUNT(name) as never_attempted FROM animals WHERE escape_attempts = 0;

-- WHAT IS THE AVERAGE WEIGHT OF ANIMALS
SELECT AVG(weight_kg) as average_weight FROM animals;

-- WHO ESCAPED THE MOST, NEUTERED OR NOT NEUTERED ANIMALS
SELECT neutered, MAX(escape_attempts) AS maximum_attempts
	FROM animals
	GROUP BY neutered;

-- WHAT IS THE MINIMUM AND MAXIMUM WEIGHT OF EACH SPECY OF animal
SELECT species, MIN(weight_kg) AS minimum_weight, MAX(weight_kg) AS maximum_weight
	FROM animals
	GROUP BY species;

-- WHAT IS THE AVERAGE NUMBER OF ESCAPE ATTEMPS/ANIMAL-TYPE OF THOSE BORN BETWEEN 1990 AND 2000
SELECT species, AVG(escape_attempts) AS AVG_escape_attempts
	FROM animals
	WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
	GROUP BY species;

-- UPDATE animals species_id when name doesn't end with mon
BEGIN TRANSACTION;
UPDATE animals
	SET species_id = 1
	WHERE TRIM(name) NOT LIKE '%mon';
COMMIT TRANSACTION;
SELECT * FROM animals;

-- UPDATE animals species_id when name ends with mon
BEGIN TRANSACTION;
UPDATE animals
	SET species_id = 2
	WHERE TRIM(name) LIKE '%mon';
COMMIT TRANSACTION;
SELECT * FROM animals;