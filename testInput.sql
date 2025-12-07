
USE AdventOfCode2025
GO

IF SCHEMA_ID('day1') IS NULL
	EXEC('CREATE SCHEMA day1')
GO

DROP TABLE IF EXISTS day1.testInput
GO

CREATE TABLE day1.testInput (
	id int IDENTITY PRIMARY KEY,
	rotation varchar(4)
)
GO

INSERT day1.testInput
SELECT *
FROM (VALUES
    ('L68'),
    ('L30'),
    ('R48'),
    ('L5'),
    ('R60'),
    ('L55'),
    ('L1'),
    ('L99'),
    ('R14'),
    ('L82')
) x (rotation)
GO