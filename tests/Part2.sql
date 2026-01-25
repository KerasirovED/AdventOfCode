
USE AdventOfCode2025

DECLARE @Expected int = NULL;

DECLARE @Ranges day5.Ranges;

INSERT @Ranges
SELECT *
FROM day5.Ranges

DECLARE @Values day5.[Values];

INSERT @Values
SELECT *
FROM day5.[Values]

DECLARE @Result TABLE (Result int)

INSERT @Result
EXEC day5.Part2 @Ranges, @Values;

SELECT
    @Expected AS Expected,
    Result AS Got,
    CASE WHEN Result = @Expected THEN 1 ELSE 0 END AS Passed
FROM @Result;