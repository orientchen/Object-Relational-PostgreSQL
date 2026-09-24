-- UDF as a practical counterpart to operations associated with data.
DROP FUNCTION IF EXISTS student_status(NUMERIC);
CREATE FUNCTION student_status(p_gpa NUMERIC) RETURNS TEXT
LANGUAGE SQL IMMUTABLE AS $$
 SELECT CASE WHEN p_gpa>=3.50 THEN 'High Achievement'
             WHEN p_gpa>=2.00 THEN 'Good Standing'
             ELSE 'Academic Concern' END;
$$;
SELECT person_id,name,gpa,student_status(gpa) AS status FROM student;
