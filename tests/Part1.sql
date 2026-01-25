
USE AdventOfCode2025

DECLARE @Expected int = 3;

DECLARE @Ranges day5.Ranges;

INSERT @Ranges
SELECT *
FROM day5.test_ranges

DECLARE @Values day5.[Values];

INSERT @Values
SELECT *
FROM day5.test_values

DECLARE @Result TABLE (Result int)

INSERT @Result
EXEC day5.Part1 @Ranges, @Values;

SELECT
    @Expected AS Expected,
    Result AS Got,
    CASE WHEN Result = @Expected THEN 1 ELSE 0 END AS Passed
FROM @Result;