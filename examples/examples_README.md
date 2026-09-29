# Instructor Demo Manual: Object-Relational Features with PostgreSQL

This folder contains six PostgreSQL demonstrations that correspond to
object-relational concepts from the Chapter 12 lecture.

> **Teaching note:** The lecture presents general and SQL-standard
> object-relational concepts. PostgreSQL provides practical counterparts
> for many of these concepts, but its syntax and behavior are not always
> identical to the SQL standard.

## Before Class

Connect to PostgreSQL from the Codespace terminal:

``` bash
psql -h postgres -U student -d objectdb
```

After entering the password, the normal `psql` prompt is:

``` text
objectdb=#
```

If the prompt changes to:

``` text
objectdb-#
```

PostgreSQL is waiting for the rest of an unfinished SQL statement. Press
**Ctrl+C** to cancel the unfinished statement and return to
`objectdb=#`.

Useful `psql` meta-commands:

``` text
\i file.sql       Run/include an SQL file
\d table_name     Describe a table
\dT type_name     List/show a data type
\df function      List/show a function
\dt               List tables
```

Commands beginning with `\` are `psql` meta-commands, not SQL
statements.

------------------------------------------------------------------------

## Demo 1 --- Composite Types / User-Defined Types

**File:** `01_composite_types.sql`

**Concept:** A user-defined composite type can represent a complex
structure and can be used as the data type of a table column.

### Run the demo

``` text
\i examples/01_composite_types.sql
```

The script creates:

``` sql
CREATE TYPE address_type AS (
    street VARCHAR(50),
    city VARCHAR(30),
    state CHAR(2),
    zip VARCHAR(10)
);
```

and uses the new type in the `person` table:

``` sql
address address_type
```

### Inspect the type and table

``` text
\dT address_type
\d person
```

Point out this column in `person`:

``` text
address | address_type
```

`address_type` is not a built-in type; it is the type created by the
demo.

The script also demonstrates accessing components of the composite
value:

``` sql
SELECT name,
       (address).street,
       (address).city,
       (address).state,
       (address).zip
FROM person;
```

### What to explain

Instead of storing an address as one ordinary string, PostgreSQL can
define a structured type containing several related fields.

Also explain:

``` text
INSERT 0 2
```

means that two rows were inserted successfully. The `0` is historical
OID-related information and can normally be ignored.

**Key takeaway:** A UDT/composite type lets one attribute have a complex
internal structure.

------------------------------------------------------------------------

## Demo 2 --- Nested Composite Types

**File:** `02_nested_types.sql`

**Concept:** One complex type can contain another complex type.

### Run the demo

``` text
\i examples/02_nested_types.sql
```

The script first creates:

``` sql
CREATE TYPE street_address_type AS (
    number VARCHAR(10),
    street_name VARCHAR(40),
    apt_no VARCHAR(10)
);
```

It then nests that type inside another type:

``` sql
CREATE TYPE usa_address_type AS (
    street street_address_type,
    city VARCHAR(30),
    state CHAR(2),
    zip VARCHAR(10)
);
```

Finally, `usa_address_type` is used in `person_nested`.

### Inspect the objects

``` text
\dT street_address_type
\dT usa_address_type
\d person_nested
```

### What to explain

The structure is conceptually:

``` text
person_nested
└── address : usa_address_type
    ├── street : street_address_type
    │   ├── number
    │   ├── street_name
    │   └── apt_no
    ├── city
    ├── state
    └── zip
```

The final query demonstrates nested component access:

``` sql
((address).street).number
((address).street).street_name
(address).city
```

**Key takeaway:** Complex types can be nested to represent more complex
structures.

------------------------------------------------------------------------

## Demo 3 --- Arrays / Collections

**File:** `03_arrays.sql`

**Concept:** PostgreSQL arrays provide a practical example of a
collection-valued attribute.

### Run the demo

``` text
\i examples/03_arrays.sql
```

### Inspect the table

``` text
\d student_array
```

Point out:

``` text
skills | text[]
```

Inside the `CREATE TABLE` statement:

``` sql
skills TEXT[]
```

is a **column definition**. It means that the column `skills` has the
data type "array of TEXT."

It is **not** a complete SQL statement by itself.

### Show array values

``` sql
SELECT * FROM student_array;
```

Example value:

``` text
{SQL,Python,Java}
```

### Access one array element

``` sql
SELECT name, skills[1] AS first_skill
FROM student_array;
```

PostgreSQL arrays normally use 1-based indexing, so `skills[1]` is the
first element.

### Search within an array

``` sql
SELECT name, skills
FROM student_array
WHERE 'SQL' = ANY(skills);
```

Explain that this asks whether `'SQL'` matches any element in the
`skills` array.

**Key takeaway:**

``` text
TEXT[]       -> array of text values
skills[1]    -> first array element
ANY(skills)  -> test values in the array
```

------------------------------------------------------------------------

## Demo 4 --- Inheritance

**File:** `04_inheritance.sql`

**Concept:** A child table can inherit columns from a parent table and
add its own columns.

> **Terminology note:** The lecture/textbook uses the SQL-standard
> `UNDER` concept. PostgreSQL provides its own table-inheritance
> mechanism using `INHERITS`. They illustrate related inheritance ideas
> but are not identical features.

### Run the demo

``` text
\i examples/04_inheritance.sql
```

The hierarchy is:

``` text
person_base
├── student
└── employee
```

The child tables are created with:

``` sql
CREATE TABLE student (
    major VARCHAR(50),
    gpa NUMERIC(3,2)
) INHERITS (person_base);
```

and:

``` sql
CREATE TABLE employee (
    department VARCHAR(50),
    salary NUMERIC(10,2)
) INHERITS (person_base);
```

### Compare parent and child structures

``` text
\d person_base
\d student
\d employee
```

`student` inherits:

``` text
person_id
name
birth_date
```

and adds:

``` text
major
gpa
```

### Query the parent hierarchy

``` sql
SELECT * FROM person_base;
```

In PostgreSQL, querying an inherited parent table normally includes rows
from descendant tables.

Now compare:

``` sql
SELECT * FROM ONLY person_base;
```

`ONLY` restricts the query to rows stored directly in `person_base`.

Useful comparison:

``` sql
SELECT * FROM person_base;       -- parent + descendants
SELECT * FROM ONLY person_base;  -- parent only
```

You can also show the child tables directly:

``` sql
SELECT * FROM student;
SELECT * FROM employee;
```

**Key takeaway:** Child tables inherit parent columns, and PostgreSQL
parent-table queries normally include descendant rows unless `ONLY` is
used.

------------------------------------------------------------------------

## Demo 5 --- User-Defined Functions

**File:** `05_functions.sql`

**Concept:** PostgreSQL can define application-specific operations using
user-defined functions.

**Dependency:** Run Demo 4 first because this demo uses the `student`
table.

### Run the demo

``` text
\i examples/05_functions.sql
```

The function is:

``` sql
CREATE FUNCTION student_status(p_gpa NUMERIC)
RETURNS TEXT
LANGUAGE SQL IMMUTABLE AS $$
    SELECT CASE
        WHEN p_gpa >= 3.50 THEN 'High Achievement'
        WHEN p_gpa >= 2.00 THEN 'Good Standing'
        ELSE 'Academic Concern'
    END;
$$;
```

### Inspect the function

``` text
\df student_status
```

### Call it directly

``` sql
SELECT student_status(3.75);
```

Try another value:

``` sql
SELECT student_status(2.50);
```

### Apply it to table data

``` sql
SELECT name, gpa, student_status(gpa) AS status
FROM student;
```

### What to explain

The function receives a GPA and returns a status based on the GPA.

This is a practical PostgreSQL counterpart to the lecture concept of
associating operations with data. It is not the same syntax as
SQL-standard UDT methods.

**Key takeaway:** We can create our own database functions and apply
them to stored data.

------------------------------------------------------------------------

## Demo 6 --- Function Overloading / Polymorphism

**File:** `06_overloading.sql`

**Concept:** PostgreSQL allows functions with the same name when their
parameter types differ.

### Run the demo

``` text
\i examples/06_overloading.sql
```

The script creates:

``` sql
describe_value(INTEGER)
describe_value(TEXT)
```

Both functions have the same name, but they accept different argument
types.

### Inspect the overloaded functions

``` text
\df describe_value
```

Point out that two functions named `describe_value` exist with different
argument types.

### Call the integer version

``` sql
SELECT describe_value(100);
```

### Call the text version

``` sql
SELECT describe_value('Database'::TEXT);
```

Explain:

``` sql
'Database'::TEXT
```

means to explicitly cast `'Database'` to the PostgreSQL `TEXT` type.

PostgreSQL cast syntax:

``` text
value::type
```

Equivalent standard-style syntax:

``` sql
CAST('Database' AS TEXT)
```

### What to explain

PostgreSQL determines which `describe_value()` implementation to call
from the argument's data type.

``` text
INTEGER -> describe_value(INTEGER)
TEXT    -> describe_value(TEXT)
```

**Key takeaway:** Same function name + different parameter types =
function overloading.

------------------------------------------------------------------------

## End-of-Lecture Summary

  Demo   PostgreSQL Feature       Object-Relational Concept
  ------ ------------------------ ---------------------------------
  01     Composite type           UDT / complex object
  02     Nested composite types   Nested complex structures
  03     `TEXT[]` arrays          Collections / arrays
  04     `INHERITS`               Inheritance / type hierarchy
  05     User-defined function    Operations associated with data
  06     Function overloading     Polymorphism / overloading

### Suggested closing statement

Object-relational databases retain the relational model while extending
it with richer data types and selected object-oriented ideas, such as
complex structures, collections, inheritance, and user-defined
operations.
