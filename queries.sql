/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name like '%mon'

-- List the name of all animals born between 2016 and 2019.
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31'

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT * FROM animals WHERE neutered AND escape_attempts < 3 

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT name, date_of_birth  FROM animals WHERE name='Agumon' or name='Pikachu'

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg >10.5

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name not like 'Gabumon'

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 and 17.3 

/*  Transactions  */

/* Stage 1 */
BEGIN;
UPDATE animals SET species='unspecified';
ROLLBACK;

/* Stage 2 */
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
UPDATE animals SET species='pokemon' WHERE name NOT LIKE '%mon';
COMMIT;

/* Stage 3 DELETE */ 
BEGIN;
DELETE FROM animals;
ROLLBACK;

/* Stage 4 */ 
BEGIN;
DELETE FROM animals WHERE date_of_birth >= '2022-01-01';
SAVEPOINT firstpoint;
UPDATE animals SET weight_kg = weight_kg*-1;
ROLLBACK TO firstpoint;

/* Stage 5 */ 
UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg<0;
COMMIT;

/* Queries */
SELECT COUNT( name ) FROM animals;
SELECT COUNT( * ) FROM animals WHERE escape_attempts = 0;
SELECT AVG( weight_kg ) FROM animals;
SELECT neutered, AVG( escape_attempts ) FROM animals GROUP BY neutered ORDER BY AVG DESC LIMIT 1;
SELECT species, MIN( weight_kg ), MAX( weight_kg ) FROM animals GROUP BY species;
SELECT species, AVG( escape_attempts ) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

/* Queries Using Pgadmin*/ 

/* Querie 1 */
/* What animals belong to Melody Pond? */
SELECT animals.name, owners.full_name 
FROM owners INNER JOIN animals 
ON owners.id = animals.owners_id
WHERE owners.full_name = 'Melody Pond';

/* Querie 2 */ 
/* List of all animals that are pokemon (their type is Pokemon). */ 
SELECT animals.name, species.name AS species
FROM species INNER JOIN animals 
ON species.id = animals.species_id
WHERE species.name = 'Pokemon';

/* Querie 3 */ 
/* List all owners and their animals, remember to include those that don't own any animal. */
SELECT owners.full_name, animals.name
FROM animals RIGHT JOIN owners
ON owners.id = animals.owners_id;

/* Querie 4 */ 
/* How many animals are there per species? */
SELECT species.name AS Species, count(species_id) AS Total
FROM animals INNER JOIN species
ON species.id = animals.species_id
GROUP BY species.name;

/* Querie 5 */ 
/* List all Digimon owned by Jennifer Orwell. */
SELECT owners.full_name AS owner, animals.name AS pet
FROM animals
JOIN owners ON owners.id = animals.owners_id
JOIN species ON species.id = animals.species_id
WHERE owners.full_name = 'Jennifer Orwell ' AND species.name = 'Digimon';

/* Querie 6 */ 
/* List all animals owned by Dean Winchester that haven't tried to escape. */
SELECT owners.full_name, animals.name AS GoodAnimal
FROM animals
INNER JOIN owners ON owners.id = animals.owners_id
WHERE animals.escape_attempts = 0 AND owners.full_name = 'Dean Winchester';

/* Querie 7 */ 
/* Who owns the most animals? */
SELECT owners.full_name AS MostAnimal, count(*)
FROM animals
INNER JOIN owners ON animals.owners_id = owners.id
GROUP BY owners.full_name
ORDER BY count DESC LIMIT 1;