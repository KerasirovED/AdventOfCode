
DECLARE @RollsRows day4.RollsRows;

INSERT @RollsRows
SELECT *
FROM day4.test_input

DECLARE @Result TABLE (Result int)

INSERT @Result
EXEC day4.SolutionPart2 @RollsRows;

SELECT 43 AS Expected, Result AS Got
FROM @Result;