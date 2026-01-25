
/*
    1. Change database schema from dayX to dayY
    2. Adjust the structure of the input tables, and user-defined types
    3. Update the test input
    4. Adjust the link
*/

IF DB_ID('AdventOfCode2025') IS NULL
    EXEC('CREATE DATABASE AdventOfCode2025')

USE AdventOfCode2025

IF SCHEMA_ID('dayX') IS NULL
    EXEC('CREATE SCHEMA dayX')

IF OBJECT_ID('dayX.input') IS NULL
    CREATE TABLE dayX.input (
        id INT PRIMARY KEY IDENTITY
    )

TRUNCATE TABLE dayX.input

DECLARE @YourInput NVARCHAR(MAX) = 'Your input string here'

INSERT dayX.input
SELECT REPLACE([value], CHAR(10), '')
FROM STRING_SPLIT(@YourInput, CHAR(13))

IF OBJECT_ID('dayX.test_input') IS NULL
BEGIN
    CREATE TABLE dayX.test_input (
        id INT PRIMARY KEY IDENTITY
    )

    INSERT dayX.test_input
    VALUES
END

IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'Input' AND schema_id = SCHEMA_ID('dayX'))
	CREATE TYPE dayX.Input AS TABLE (
		id int
	);
GO