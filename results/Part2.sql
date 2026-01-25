
DECLARE @Input dayX.Input;

INSERT @Input
SELECT *
FROM dayX.input

EXEC Part2 @Input