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