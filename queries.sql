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

-- WHAT ANIMALA BELONGS TO MELODY POND?
SELECT full_name as owner, name as animal
	FROM animals
	INNER JOIN owners 
	ON animals.owner_id = owners.id
	WHERE owners.full_name = 'Melody Pond';

-- LIST ALL ANIMALS THAT ARE POKEMON (THEIR TYPE IS POKEMON)
SELECT animals.name as animal, species.name as species
	FROM animals
	INNER JOIN species  
	ON animals.species_id = species.id
	WHERE species.name = 'Pokemon';

-- LIST ALL OWNERS AND THEIR ANIMALS, REMEMBER TO INCLUDE THOSE THAT DON'T OWN ANY ANIMAL
SELECT full_name as owner, name as animal
	FROM animals
	RIGHT JOIN owners
	ON animals.owner_id = owners.id;

-- HOW MANY ANIMALS ARE THERE IN PER SPECIES?
SELECT s.name AS species_name, COUNT(*) AS animal_count
	FROM animals a
	JOIN species s ON a.species_id = s.id
	GROUP BY s.name;

-- LIST ALL DIGIMON OWNED BY JENNIFER ORWELL.
SELECT a.name
	FROM animals a
	JOIN owners o ON a.owner_id = o.id
	JOIN species s ON a.species_id = s.id
	WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- LIST ALL ANIMALS OWNED BY DEAN WINCHESTER THAT HAVEN'T TRIED TO ESCAPE
SELECT name as animal  
	FROM animals
	JOIN owners
	ON animals.owner_id = owners.id
	WHERE animals.escape_attempts = 0 AND owners.full_name = 'Dean Winchester';

-- WHO OWNS THE MOST ANIMALS?
SELECT o.full_name as owner, COUNT(*) as total_animals
	FROM animals a 
	JOIN owners o 
	ON a.owner_id = o.id
	GROUP BY owner
	ORDER BY total_animals DESC
	LIMIT 1;

-- WHO WAS THE LAST ANIMAL SEEN BY WILLIAM TATCHER?
SELECT animals.name 
	FROM animals 
	JOIN visits ON animals.id = visits.animal_id 
	JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'William Tatcher'
	ORDER BY visit_date DESC 
LIMIT 1;

-- HOW MANY DIFFERENT ANIMALS DID STEPHANIE MENDEZ SEE?
SELECT COUNT(animals.name)
	FROM animals 
	JOIN visits ON animals.id = visits.animal_id 
	JOIN vets ON vets.id = visits.vet_id 
WHERE vets.name = 'Stephanie Mendez';

-- LIST ALL VETS AND THEIR SPECIALTIES, INCLUDING VETS WITH NO SPECIALTIES.
SELECT vets.name, species.name AS specialty
	FROM vets
	LEFT JOIN specializations sp ON vets.id = sp.vet_id
	LEFT JOIN species ON sp.species_id = species.id;

-- LIST ALL ANIMALS THAT VISITED STEPHANIE MENDEZ BETWEEN APRIL 1ST AND AUGUST 30TH, 2020.
SELECT animals.name 
	FROM animals 
	JOIN visits ON visits.animal_id = animals.id 
	JOIN vets ON vets.id = visits.vet_id 
	WHERE vets.name = 'Stephanie Mendez' 
		AND visits.visit_date BETWEEN '2020-04-1' AND '2020-08-30';

-- WHAT ANIMAL HAS THE MOST VISITS TO VETS?
SELECT animals.name, COUNT(visits.animal_id) as visits 
	FROM animals 
	JOIN visits ON visits.animal_id = animals.id 
	GROUP BY animals.name 
	ORDER BY visits DESC 
LIMIT 1;

-- WHO WAS MAISY SMITH'S FIRST VISIT?
SELECT animals.name, visits.visit_date 
	FROM visits 
	JOIN vets ON visits.vet_id = vets.id 
	JOIN animals ON visits.animal_id = animals.id 
	WHERE vets.name = 'Maisy Smith' 
	ORDER BY visits.visit_date ASC 
LIMIT 1;

-- DETAILS FOR MOST RECENT VISIT: ANIMAL INFORMATION, VET INFORMATION, AND DATE OF VISIT.
SELECT animals.name AS animal_name, vets.name AS vet_name, visits.visit_date 
	FROM visits 
	JOIN vets ON visits.vet_id = vets.id 
	JOIN animals ON visits.animal_id = animals.id 
	ORDER BY visits.visit_date DESC 
LIMIT 1;

-- HOW MANY VISITS WERE WITH A VET THAT DID NOT SPECIALIZE IN THAT ANIMAL'S SPECIES?
SELECT COUNT(*)
	FROM visits
	JOIN vets ON visits.vet_id = vets.id
	JOIN animals ON visits.animal_id = animals.id
	LEFT JOIN specializations spec ON vets.id = spec.vet_id AND animals.species_id = spec.species_id
WHERE spec.vet_id IS NULL;
