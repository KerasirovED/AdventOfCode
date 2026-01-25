
IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'RollsRows' AND schema_id = SCHEMA_ID('day4'))
	CREATE TYPE day4.RollsRows AS TABLE (
		id int,
		rollsRow varchar(150)
	);
GO

CREATE OR ALTER PROC day4.Solution
	@RollsRows day4.RollsRows READONLY
AS
BEGIN
    SELECT rr.id [row], roll.ordinal [column]
    INTO #Rolls
    FROM @RollsRows rr
		CROSS APPLY REGEXP_SPLIT_TO_TABLE(rollsRow, '') roll
	WHERE roll.[value] = '@' -- we are interested only in the cells with rolls -> reduce the dataset

	CREATE INDEX idx_rolls ON #Rolls ([row], [column]);

	SELECT COUNT(*) Result
	FROM (
		SELECT checkedValue.[row], checkedValue.[column]
		FROM #Rolls checkedValue
			JOIN #Rolls nearbyRolls ON
				nearbyRolls.[row] BETWEEN checkedValue.[row] - 1 AND checkedValue.[row] + 1
				AND nearbyRolls.[column] BETWEEN checkedValue.[column] - 1 AND checkedValue.[column] + 1
			GROUP BY checkedValue.[row], checkedValue.[column]
			HAVING COUNT(*) < 5
	) x
END;