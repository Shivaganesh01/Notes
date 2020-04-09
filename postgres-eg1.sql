CREATE DATABASE testdb; -- creates database
DROP DATABASE IF EXISTS testdb1; -- delete database

CREATE SCHEMA MY_SCHEMA; -- creates a schema

DROP SCHEMA MY_SCHEMA CASCADE;

CREATE TABLE MY_SCHEMA.DEPARTMENT(
	ID INT PRIMARY KEY NOT NULL,
	DEPT CHAR(20) NOT NULL,
	EMP_ID INT NOT NULL
);

-- create a table named company
CREATE TABLE COMPANY(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL,
   JOIN_DATE	  DATE
);

-- create a table named department
CREATE TABLE DEPARTMENT(
	ID INT PRIMARY KEY NOT NULL,
	DEPT CHAR(20) NOT NULL,
	EMP_ID INT NOT NULL
);

INSERT INTO DEPARTMENT VALUES (1, 'PHY', 1);
INSERT INTO DEPARTMENT(dept, id, EMP_ID) VALUES ('CHE', 2, 2);
INSERT INTO DEPARTMENT VALUES (3, 'MAT', 3);
INSERT INTO DEPARTMENT (ID, DEPT, EMP_ID) VALUES (4, 'IT Billing', 1 );
INSERT INTO DEPARTMENT (ID, DEPT, EMP_ID) VALUES (5, 'Engineering', 2 );
INSERT INTO DEPARTMENT (ID, DEPT, EMP_ID) VALUES (6, 'Finance', 7 );

INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY,JOIN_DATE) VALUES (1, 'Paul', 32, 'California', 20000.00,'2001-07-13');
INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,JOIN_DATE) VALUES (2, 'Allen', 25, 'Texas', '2007-12-13');
INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY,JOIN_DATE) VALUES (3, 'Teddy', 23, 'Norway', 20000.00, DEFAULT );
INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY,JOIN_DATE) VALUES (4, 'Mark', 25, 'Rich-Mond ', 65000.00, '2007-12-13' ), (5, 'David', 27, 'Texas', 85000.00, '2007-12-13');
INSERT INTO COMPANY VALUES (8, 'Paul', 24, 'Houston', 20000.00);
INSERT INTO COMPANY VALUES (9, 'James', 44, 'Norway', 5000.00);
INSERT INTO COMPANY VALUES (10, 'James', 45, 'Texas', 5000.00);

Select * from COMPANY;
Select * from department;

DROP TABLE IF EXISTS TABLE1, TABLE2;


select |/ 2 as result;  -- square root
select ||/ 2 as result; -- cube root
select 1 + 2 as result; -- sum
select !! 4 as result; -- factorial
select 4! as result; -- factorial
select 2^8 as result; -- exponent

select 2=2 as result;

SELECT CURRENT_TIMESTAMP;

--AND and OR Conjunctive Operators
SELECT id, name, age FROM COMPANY WHERE AGE >= 25 OR SALARY >= 65000;

SELECT * FROM COMPANY WHERE AGE IS NOT NULL;
SELECT * FROM COMPANY WHERE NAME LIKE 'Pa%';
SELECT * FROM COMPANY WHERE AGE IN ( 28, 25 );
SELECT * FROM COMPANY WHERE AGE NOT IN ( 25, 27 );
SELECT * FROM COMPANY WHERE AGE BETWEEN 25 AND 27;
SELECT AGE FROM COMPANY
        WHERE EXISTS (SELECT AGE FROM COMPANY WHERE SALARY > 65000);
SELECT AGE FROM COMPANY
        WHERE EXISTS (SELECT AGE FROM COMPANY WHERE SALARY > 95000);
	
SELECT * FROM COMPANY
        WHERE AGE > (SELECT AGE FROM COMPANY WHERE SALARY > 65000);

-- UPDATE
UPDATE COMPANY SET SALARY = 75000 WHERE ID = 3; -- single row update
 UPDATE COMPANY SET ADDRESS = 'Texas' -- all rows update

-- DELETE
DELETE FROM COMPANY WHERE ID = 2; -- delete a particular row
DELETE FROM COMPANY; -- delete all rows

-- LIKE CLAUSE
-- There are two wildcards used in conjunction with the LIKE operator −
-- The percent sign (%)
-- The underscore (_)
-- The percent sign represents zero, one, or multiple numbers or characters. The underscore represents a single number or character. These symbols can be used in combinations.
-- If either of these two signs is not used in conjunction with the LIKE clause, then the LIKE acts like the equals operator.

SELECT * FROM COMPANY WHERE AGE::text LIKE '%2%';
SELECT * FROM COMPANY WHERE ADDRESS  LIKE '_e%';

-- LIMIT CLAUSE
SELECT * FROM COMPANY LIMIT 3 OFFSET 2;

-- ORDER BY CLAUSE
SELECT * FROM COMPANY ORDER BY JOIN_DATE ASC, SALARY DESC;

 -- GROUP BY CLAUSE
-- The PostgreSQL GROUP BY clause is used in collaboration with the SELECT statement to group together those rows in a table that have identical data. This is done to eliminate redundancy in the output and/or compute aggregates that apply to these groups.
-- The GROUP BY clause follows the WHERE clause in a SELECT statement and precedes the ORDER BY clause.
SELECT NAME, SUM(SALARY) FROM COMPANY GROUP BY NAME ORDER BY NAME;

-- WITH QUERY
-- WITH query provides a way to write auxiliary statements for use in a larger query. It helps in breaking down complicated and large queries into simpler forms, which are easily readable. 
-- Common Table Expressions or CTEs

With CTE AS
(Select
 ID
, NAME
, AGE
, ADDRESS
, SALARY
FROM COMPANY )
-- Select * From CTE;
Select NAME From CTE;

-- HAVING CLAUSE
-- The WHERE clause places conditions on the selected columns, whereas the HAVING clause places conditions on groups created by the GROUP BY clause.
-- ORDER IN QUERY
	-- SELECT
	-- FROM
	-- WHERE
	-- GROUP BY
	-- HAVING
	-- ORDER BY
SELECT NAME FROM COMPANY GROUP BY name HAVING count(name) < 2;

-- DISTINCT
SELECT name FROM COMPANY;
SELECT DISTINCT name FROM COMPANY;


-- Advanced Concepts

-- Constraints: These are the rules enforced on data columns on table. These are used to prevent invalid data from being entered into the database. This ensures the accuracy and reliability of the data in the database.
-- Constraints could be column level or table level. Defining a data type to a data column is also a constraint.
-- PRIMARY KEY, NOT NULL, UNIQUE, FOREIGN KEY(EMP_ID INT references COMPANY(ID)), CHECK CONSTRAINT(SALARY REAL CHECK(SALARY > 0)), EXCLUDE
-- Due to a 'longstanding coding oversight', primary keys can be NULL in SQLite. This is not the case with other databases
ALTER TABLE table_name DROP CONSTRAINT some_name;
CREATE EXTENSION btree_gist;
CREATE TABLE COMPANY7(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT,
   AGE            INT  ,
   ADDRESS        CHAR(50),
   SALARY         REAL,
   EXCLUDE USING gist
   (NAME WITH =,
   AGE WITH <>)
);
INSERT INTO COMPANY7 VALUES(1, 'Paul', 32, 'California', 20000.00 );
INSERT INTO COMPANY7 VALUES(2, 'Paul', 32, 'Texas', 20000.00 );
INSERT INTO COMPANY7 VALUES(4, 'Paul', 42, 'California', 20000.00 );


-- JOINS
-- The PostgreSQL Joins clause is used to combine records from two or more tables in a database.
-- The CROSS JOIN - matches every row of the first table with every row of the second table. If the input tables have x and y columns, respectively, the resulting table will have x+y columns.
-- The INNER JOIN - Default Join and most common.
SELECT EMP_ID, NAME, DEPT FROM COMPANY INNER JOIN DEPARTMENT
        ON COMPANY.ID = DEPARTMENT.EMP_ID;
		
-- OUTER JOIN IS THE EXTENSION OF INNER JOIN
-- The LEFT OUTER JOIN - In case of LEFT OUTER JOIN, an inner join is performed first. Then, for each row in table T1 that does not satisfy the join condition with any row in table T2, a joined row is added with null values in columns of T2. Thus, the joined table always has at least one row for each row in T1.
SELECT EMP_ID, NAME, DEPT FROM COMPANY LEFT OUTER JOIN DEPARTMENT
   ON COMPANY.ID = DEPARTMENT.EMP_ID;
-- The RIGHT OUTER JOIN
SELECT EMP_ID, NAME, DEPT FROM COMPANY RIGHT OUTER JOIN DEPARTMENT
   ON COMPANY.ID = DEPARTMENT.EMP_ID;
-- The FULL OUTER JOIN
SELECT EMP_ID, NAME, DEPT FROM COMPANY FULL OUTER JOIN DEPARTMENT
   ON COMPANY.ID = DEPARTMENT.EMP_ID;

-- The PostgreSQL UNION clause/operator is used to combine the results of two or more SELECT statements without returning any duplicate rows.
SELECT EMP_ID, NAME, DEPT FROM COMPANY INNER JOIN DEPARTMENT
   ON COMPANY.ID = DEPARTMENT.EMP_ID
   UNION
      SELECT EMP_ID, NAME, DEPT FROM COMPANY LEFT OUTER JOIN DEPARTMENT
         ON COMPANY.ID = DEPARTMENT.EMP_ID;
-- The UNION ALL operator is used to combine the results of two SELECT statements including duplicate rows.

-- NULL
--  The PostgreSQL NULL is the term used to represent a missing value. A NULL value in a table is a value in a field that appears to be blank.
-- A field with a NULL value is a field with no value. It is very important to understand that a NULL value is different from a zero value or a field that contains spaces.

WHERE NAME IS NOT NULL, IS NULL

-- ALIAS - Renaming a table or a column temporarily by giving another name, which is known as ALIAS.
SELECT C.ID AS COMPANY_ID, C.NAME AS COMPANY_NAME, C.AGE, D.DEPT
   FROM COMPANY AS C, DEPARTMENT AS D
   WHERE  C.ID = D.EMP_ID;

-- TRIGGER : Triggers are database callback functions, which are automatically performed/invoked when a specified database event occurs.
CREATE TABLE COMPANY_TRIGGER(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);
CREATE TABLE AUDIT(
   EMP_ID INT NOT NULL,
   ENTRY_DATE TEXT NOT NULL
);
CREATE OR REPLACE FUNCTION auditlogfunc() RETURNS TRIGGER AS $example_table$
   BEGIN
      INSERT INTO AUDIT(EMP_ID, ENTRY_DATE) VALUES (new.ID, current_timestamp);
      RETURN NEW;
   END;
   $example_table$ LANGUAGE plpgsql;
CREATE TRIGGER example_trigger AFTER INSERT ON COMPANY_TRIGGER
FOR EACH ROW EXECUTE PROCEDURE auditlogfunc();
INSERT INTO COMPANY_TRIGGER (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'Paul', 32, 'California', 20000.00 );
SELECT * FROM pg_trigger;
SELECT * FROM AUDIT;
SELECT tgname FROM pg_trigger, pg_class WHERE tgrelid=pg_class.oid AND relname='company_trigger';

-- INDEX: Indexes are special lookup tables that the database search engine can use to speed up data retrieval.
CREATE INDEX index_name
ON table_name (column1_name, column2_name);
-- Unique index
CREATE UNIQUE INDEX index_name
on table_name (column_name);
--  Partial index
CREATE INDEX index_name
on table_name (conditional_expression);
-- Implcit indexes used on primary key and unique constraint columns

-- The following guidelines indicate when the use of an index should be avoided −
-- 	Indexes should not be used on small tables.
-- 	Tables that have frequent, large batch update or insert operations.
-- 	Indexes should not be used on columns that contain a high number of NULL values.
-- 	Columns that are frequently manipulated should not be indexed.

-- ALTER TABLE command will be used to add, delete or modify columns in an existing table, to add and drop various constraints on an existing table.

-- The basic syntax of ALTER TABLE to add a new column in an existing table is as follows −
ALTER TABLE table_name ADD column_name datatype;
-- The basic syntax of ALTER TABLE to DROP COLUMN in an existing table is as follows −
ALTER TABLE table_name DROP COLUMN column_name;
-- The basic syntax of ALTER TABLE to change the DATA TYPE of a column in a table is as follows −
ALTER TABLE table_name ALTER COLUMN column_name TYPE datatype;
-- The basic syntax of ALTER TABLE to add a NOT NULL constraint to a column in a table is as follows −
ALTER TABLE table_name MODIFY column_name datatype NOT NULL;
-- The basic syntax of ALTER TABLE to ADD UNIQUE CONSTRAINT to a table is as follows −
ALTER TABLE table_name
ADD CONSTRAINT MyUniqueConstraint UNIQUE(column1, column2...);
-- The basic syntax of ALTER TABLE to ADD CHECK CONSTRAINT to a table is as follows −
ALTER TABLE table_name
ADD CONSTRAINT MyUniqueConstraint CHECK (CONDITION);
-- The basic syntax of ALTER TABLE to ADD PRIMARY KEY constraint to a table is as follows −
ALTER TABLE table_name
ADD CONSTRAINT MyPrimaryKey PRIMARY KEY (column1, column2...);
-- drop a constraint
ALTER TABLE table_name
DROP CONSTRAINT MyUniqueConstraint;

-- TRUNCATE
-- This command is used to delete complete data from an existing table. You can also use DROP TABLE command to delete complete table but it would remove complete table structure from the database and you would need to re-create this table once again if you wish to store some data.
-- It has the same effect as DELETE on each table, but since it does not actually scan the tables, it is faster. Furthermore, it reclaims disk space immediately, rather than requiring a subsequent VACUUM operation. This is most useful on large tables.
TRUNCATE TABLE table_name;

-- VIEWS
-- Views are pseudo-tables. That is, they are not real tables; nevertheless appear as ordinary tables to SELECT. A view can represent a subset of a real table, selecting certain columns or certain rows from an ordinary table. A view can even represent joined tables. Because views are assigned separate permissions, you can use them to restrict table access so that the users see only specific rows or columns of a table.
-- If the optional TEMP or TEMPORARY keyword is present, the view will be created in the temporary space. Temporary views are automatically dropped at the end of the current session.
CREATE [TEMP | TEMPORARY] VIEW view_name AS
SELECT column1, column2.....
FROM table_name
WHERE [condition];

DROP VIEW view_name;

-- Transaction
-- A transaction is a unit of work that is performed against a database. Transactions are units or sequences of work accomplished in a logical order, whether in a manual fashion by a user or automatically by some sort of a database program.

-- ACID Properties of a transaction
-- Atomicity − Ensures that all operations within the work unit are completed successfully; otherwise, the transaction is aborted at the point of failure and previous operations are rolled back to their former state.
-- Consistency − Ensures that the database properly changes states upon a successfully committed transaction.
-- Isolation − Enables transactions to operate independently of and transparent to each other.
-- Durability − Ensures that the result or effect of a committed transaction persists in case of a system failure.

-- Transactional control commands are only used with the DML commands INSERT, UPDATE and DELETE only. They cannot be used while creating tables or dropping them because these operations are automatically committed in the database.
-- BEGIN TRANSACTION or BEGIN
-- COMMIT : To save the changes, alternatively you can use END TRANSACTION command.
-- ROLLBACK : This can only be used to undo transactions since the last COMMIT or ROLLBACK command was issued.
BEGIN;
-- INSERT, UPDATE OR DELETE STATEMENTS
COMMIT;
-- INSERT, UPDATE OR DELETE STATEMENTS
ROLLBACK;
-- INSERT, UPDATE OR DELETE STATEMENTS
END TRANSACTION;

-- Locks
-- Locks or Exclusive Locks or Write Locks prevent users from modifying a row or an entire table. Rows modified by UPDATE and DELETE are then exclusively locked automatically for the duration of the transaction. This prevents other users from changing the row until the transaction is either committed or rolled back.
-- The only time when users must wait for other users is when they are trying to modify the same row. If they modify different rows, no waiting is necessary. SELECT queries never have to wait.
-- The database performs locking automatically. In certain cases, however, locking must be controlled manually.

LOCK [ TABLE ]
name
 IN
lock_mode
-- name − The name (optionally schema-qualified) of an existing table to lock. If ONLY is specified before the table name, only that table is locked. If ONLY is not specified, the table and all its descendant tables (if any) are locked.
-- lock_mode − The lock mode specifies which locks this lock conflicts with. If no lock mode is specified, then ACCESS EXCLUSIVE, the most restrictive mode, is used. Possible values are: ACCESS SHARE, ROW SHARE, ROW EXCLUSIVE, SHARE UPDATE EXCLUSIVE, SHARE, SHARE ROW EXCLUSIVE, EXCLUSIVE, ACCESS EXCLUSIVE.
BEGIN;
LOCK TABLE COMPANY_TRIGGER IN ACCESS EXCLUSIVE MODE;
END TRANSACTION;

-- SUB QUERY/ INNER QUERY/ NESTED QUERY
-- There are a few rules that subqueries must follow −
-- 			Subqueries must be enclosed within parentheses.
-- 			A subquery can have only one column in the SELECT clause, unless multiple columns are in the main query for the subquery to compare its selected columns.
-- 			An ORDER BY cannot be used in a subquery, although the main query can use an ORDER BY. The GROUP BY can be used to perform the same function as the ORDER BY in a subquery.
-- 			Subqueries that return more than one row can only be used with multiple value operators, such as the IN, EXISTS, NOT IN, ANY/SOME, ALL operator.
-- 			The BETWEEN operator cannot be used with a subquery; however, the BETWEEN can be used within the subquery.
SELECT column_name [, column_name ]
FROM   table1 [, table2 ]
WHERE  column_name OPERATOR
      (SELECT column_name [, column_name ]
      FROM table1 [, table2 ]
      [WHERE])
	  
SELECT * FROM COMPANY
   WHERE ID IN (SELECT ID FROM COMPANY WHERE SALARY > 45000) ;
   
INSERT INTO COMPANY_BKP 
	SELECT * FROM COMPANY WHERE ID IN (SELECT ID FROM COMPANY) ;
	
UPDATE COMPANY
   SET SALARY = SALARY * 0.50
   WHERE AGE IN (SELECT AGE FROM COMPANY_BKP WHERE AGE >= 27 );
   
DELETE FROM COMPANY
   WHERE AGE IN (SELECT AGE FROM COMPANY_BKP WHERE AGE > 27 );

-- AUTO INCREMENT
-- PostgreSQL has the data types smallserial(smallint), serial(integer) and bigserial(bigint); these are not true types, but merely a notational convenience for creating unique identifier columns. These are similar to AUTO_INCREMENT property supported by some other databases.
CREATE TABLE COMPANY(
   ID  SERIAL PRIMARY KEY);

-- Previleges
-- Different kinds of privileges in PostgreSQL are −
-- SELECT,
-- INSERT,
-- UPDATE,
-- DELETE,
-- TRUNCATE,
-- REFERENCES,
-- TRIGGER,
-- CREATE,
-- CONNECT,
-- TEMPORARY,
-- EXECUTE, and
-- USAGE
-- Basic syntax for GRANT command is as follows −

GRANT privilege [, ...]
ON object [, ...]
TO { PUBLIC | GROUP group | username }
-- privilege − values could be: SELECT, INSERT, UPDATE, DELETE, RULE, ALL.
-- object − The name of an object to which to grant access. The possible objects are: table, view, sequence
-- PUBLIC − A short form representing all users.
-- GROUP group − A group to whom to grant privileges.
-- username − The name of a user to whom to grant privileges. PUBLIC is a short form representing all users.

-- The privileges can be revoked using the REVOKE command.
REVOKE privilege [, ...]
ON object [, ...]
FROM { PUBLIC | GROUP groupname | username }

CREATE USER manisha WITH PASSWORD 'password';
GRANT ALL ON COMPANY TO manisha;
REVOKE ALL ON COMPANY FROM manisha;

-- Date and Time
SELECT date '2001-09-28' + integer '7' as MyDate;
SELECT 900 * interval '1 second' as mytime;
SELECT CURRENT_TIMESTAMP;
SELECT NOW();
SELECT justify_hours(interval '27 hours');

-- FUNCTIONS
PostgreSQL functions, also known as Stored Procedures, allow you to carry out operations that would normally take several queries and round trips in a single function within the database.
Functions can be created in a language of your choice like SQL, PL/pgSQL, C, Python, etc.

CREATE [OR REPLACE] FUNCTION function_name (arguments) 
RETURNS return_datatype AS $variable_name$
   DECLARE
      declaration;
      [...]
   BEGIN
      < function_body >
      [...]
      RETURN { variable_name | value }
   END; LANGUAGE plpgsql;
   
CREATE OR REPLACE FUNCTION totalRecords ()
RETURNS integer AS $total$
declare
	total integer;
BEGIN
   SELECT count(*) into total FROM COMPANY;
   RETURN total;
END;
$total$ LANGUAGE plpgsql;
select totalRecords();

-- POSTGRES INBUILT FUNCTIONS MIN, MAX, AVG, COUNT, SUM, ARRAY, numeric and string functions.








