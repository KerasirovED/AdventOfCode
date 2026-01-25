
DECLARE @Input dayX.Input;

INSERT @Input
SELECT *
FROM dayX.input

EXEC Part1 @Input