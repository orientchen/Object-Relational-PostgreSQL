-- Collection counterpart: arrays
DROP TABLE IF EXISTS student_array;
CREATE TABLE student_array (
 student_id INTEGER PRIMARY KEY, name VARCHAR(50), skills TEXT[]
);
INSERT INTO student_array VALUES
(1,'Alex Lee',ARRAY['SQL','Python','Java']),
(2,'Jordan Kim',ARRAY['PostgreSQL','C++']),
(3,'Taylor Brown',ARRAY['SQL','PostgreSQL']);
SELECT * FROM student_array;
SELECT name,skills[1] AS first_skill FROM student_array;
SELECT name,skills FROM student_array WHERE 'SQL'=ANY(skills);
