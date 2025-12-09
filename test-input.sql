
USE AdventOfCode2025
GO

IF SCHEMA_ID('day2') IS NULL
	EXEC('CREATE SCHEMA day2')
GO

DROP TABLE IF EXISTS day2.test_input
GO

CREATE TABLE day2.test_input (
	id int IDENTITY PRIMARY KEY,
	[range] varchar(1000)
)
GO

INSERT day2.test_input
SELECT *
FROM (VALUES
    ('11-22'),
    ('95-115'),
    ('998-1012'),
    ('1188511880-1188511890'),
    ('222220-222224'),
    ('1698522-1698528'),
    ('446443-446449'),
    ('38593856-38593862'),
    ('565653-565659'),
    ('824824821-824824827'),
    ('2121212118-2121212124')
) x ([range])