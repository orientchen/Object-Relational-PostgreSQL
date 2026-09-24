-- Textbook UNDER concept vs PostgreSQL INHERITS: related, not identical.
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS person_base CASCADE;
CREATE TABLE person_base (person_id INTEGER,name VARCHAR(50),birth_date DATE);
CREATE TABLE student (major VARCHAR(50),gpa NUMERIC(3,2)) INHERITS (person_base);
CREATE TABLE employee (department VARCHAR(50),salary NUMERIC(10,2)) INHERITS (person_base);
INSERT INTO person_base VALUES (1,'Pat Morgan','1980-04-12');
INSERT INTO student VALUES
(2,'Sam Chen','2003-08-18','Computer Science',3.75),
(3,'Riley Jones','2002-11-03','Mathematics',3.60);
INSERT INTO employee VALUES
(4,'Casey Miller','1988-02-10','Information Technology',72000);
SELECT * FROM person_base ORDER BY person_id;
SELECT * FROM ONLY person_base ORDER BY person_id;
SELECT * FROM student ORDER BY person_id;
SELECT * FROM employee ORDER BY person_id;
