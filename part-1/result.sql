
USE AdventOfCode2025

DECLARE @RollsRows day4.RollsRows

INSERT @RollsRows
SELECT *
FROM day4.input

EXEC day4.Solution @RollsRows