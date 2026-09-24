-- Nested composite types
DROP TABLE IF EXISTS person_nested CASCADE;
DROP TYPE IF EXISTS usa_address_type CASCADE;
DROP TYPE IF EXISTS street_address_type CASCADE;
CREATE TYPE street_address_type AS (
 number VARCHAR(10), street_name VARCHAR(40), apt_no VARCHAR(10)
);
CREATE TYPE usa_address_type AS (
 street street_address_type, city VARCHAR(30), state CHAR(2), zip VARCHAR(10)
);
CREATE TABLE person_nested (person_id INTEGER PRIMARY KEY,name VARCHAR(50),address usa_address_type);
INSERT INTO person_nested VALUES
(1,'Ava Johnson',ROW(ROW('800','Wood Road',NULL)::street_address_type,'Kenosha','WI','53144')::usa_address_type);
SELECT name,((address).street).number,((address).street).street_name,(address).city FROM person_nested;
