
IF DB_ID('AdventOfCode2025') IS NULL
    EXEC('CREATE DATABASE AdventOfCode2025')

USE AdventOfCode2025

IF SCHEMA_ID('day4') IS NULL
    EXEC('CREATE SCHEMA day4')

IF OBJECT_ID('day4.input') IS NULL
    CREATE TABLE day4.input (
        id INT PRIMARY KEY IDENTITY,
        rollsRow varchar(150)
    )

TRUNCATE TABLE day4.input

DECLARE @YourInput NVARCHAR(MAX) = 'Your input string here'

INSERT day4.input (rollsRow)
SELECT REPLACE([value], CHAR(10), '')
FROM STRING_SPLIT(@YourInput, CHAR(13))