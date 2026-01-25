
USE AdventOfCode2025

DECLARE @Expected int = NULL;

DECLARE @Input dayX.Input;

INSERT @Input
SELECT *
FROM dayX.test_input

DECLARE @Result TABLE (Result int)

INSERT @Result
EXEC dayX.Part2 @Input;

SELECT
    @Expected AS Expected,
    Result AS Got,
    CASE WHEN Result = @Expected THEN 1 ELSE 0 END AS Passed
FROM @Result;