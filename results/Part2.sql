
USE AdventOfCode2025

DECLARE @Ranges day5.Ranges;

INSERT @Ranges
SELECT *
FROM day5.Ranges

DECLARE @Values day5.[Values];

INSERT @Values
SELECT *
FROM day5.[Values]

EXEC day5.Part2 @Ranges, @Values