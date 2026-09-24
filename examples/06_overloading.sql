-- Function overloading
DROP FUNCTION IF EXISTS describe_value(INTEGER);
DROP FUNCTION IF EXISTS describe_value(TEXT);
CREATE FUNCTION describe_value(value INTEGER) RETURNS TEXT LANGUAGE SQL IMMUTABLE
AS $$ SELECT 'Integer value: '||value::TEXT; $$;
CREATE FUNCTION describe_value(value TEXT) RETURNS TEXT LANGUAGE SQL IMMUTABLE
AS $$ SELECT 'Text value: '||value; $$;
SELECT describe_value(25);
SELECT describe_value('PostgreSQL'::TEXT);
