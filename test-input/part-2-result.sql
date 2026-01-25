
DECLARE @RollsRows day4.RollsRows;

INSERT @RollsRows
SELECT *
FROM day4.test_input

EXEC day4.SolutionPart2 @RollsRows;