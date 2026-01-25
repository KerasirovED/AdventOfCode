
IF DB_ID('AdventOfCode2025') IS NULL
    EXEC('CREATE DATABASE AdventOfCode2025')

USE AdventOfCode2025

IF SCHEMA_ID('day4') IS NULL
    EXEC('CREATE SCHEMA day4')

IF OBJECT_ID('day4.test_input') IS NULL
BEGIN
    CREATE TABLE day4.test_input (
        id INT PRIMARY KEY IDENTITY,
        rollsRow varchar(150)
    )

    INSERT day4.test_input
    VALUES
        ('..@@.@@@@.'),
        ('@@@.@.@.@@'),
        ('@@@@@.@.@@'),
        ('@.@@@@..@.'),
        ('@@.@@@@.@@'),
        ('.@@@@@@@.@'),
        ('.@.@.@.@@@'),
        ('@.@@@.@@@@'),
        ('.@@@@@@@@.'),
        ('@.@.@@@.@.')
END