-- UDT / composite type
DROP TABLE IF EXISTS person CASCADE;
DROP TYPE IF EXISTS address_type CASCADE;
CREATE TYPE address_type AS (
 street VARCHAR(50), city VARCHAR(30), state CHAR(2), zip VARCHAR(10)
);
CREATE TABLE person (
 person_id INTEGER PRIMARY KEY, name VARCHAR(50), birth_date DATE, address address_type
);
INSERT INTO person VALUES
(1,'John Smith','2000-05-15',ROW('123 Main St','Kenosha','WI','53140')::address_type),
(2,'Maria Garcia','1998-09-20',ROW('45 Lake Ave','Racine','WI','53403')::address_type);
SELECT name,(address).street,(address).city,(address).state,(address).zip FROM person;
