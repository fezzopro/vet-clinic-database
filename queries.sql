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
ROLLBACK TRANSACTION;
SELECT * FROM animals;

BEGIN TRANSACTION;
	DELETE FROM animals;
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
