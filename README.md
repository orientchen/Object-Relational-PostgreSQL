# Object-Relational Databases with PostgreSQL

This Codespace supports the Object/Object-Relational Database module.

The textbook presents SQL-standard object-relational concepts. PostgreSQL provides practical counterparts for several of them. PostgreSQL syntax is **not always identical** to the textbook syntax; in particular, PostgreSQL `INHERITS` is not the same mechanism as SQL-standard `UNDER`.

## Start
1. GitHub: **Code > Codespaces > Create codespace on main**.
2. Wait for setup to finish.
3. Open a terminal and run:
```bash
psql -h postgres -U student -d objectdb
```
Password: `studentpass`

Exit with `\q`.

## Run examples
From the repository root:
```bash
PGPASSWORD=studentpass psql -h postgres -U student -d objectdb -f examples/01_composite_types.sql
```

Run in order:
1. `01_composite_types.sql`
2. `02_nested_types.sql`
3. `03_arrays.sql`
4. `04_inheritance.sql`
5. `05_functions.sql`
6. `06_overloading.sql`

Then complete the SQL files in `practice/`.
