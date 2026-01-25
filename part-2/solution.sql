
IF NOT EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'RollsRows' AND schema_id = SCHEMA_ID('day4'))
	CREATE TYPE day4.RollsRows AS TABLE (
		id int,
		rollsRow varchar(150)
	);
GO

CREATE OR ALTER PROC day4.SolutionPart2
	@RollsRows day4.RollsRows READONLY
AS
BEGIN
    SELECT rr.id [row], roll.ordinal [column], roll.value
    INTO #Rolls
    FROM @RollsRows rr
		CROSS APPLY REGEXP_SPLIT_TO_TABLE(rollsRow, '') roll
	WHERE roll.[value] = '@' -- we are interested only in the cells with rolls -> reduce the dataset

	CREATE INDEX idx_rolls ON #Rolls ([row], [column])
		INCLUDE ([value]);

	DECLARE
		@TotalDeleted int = 0,
		@Deleted int = 1 -- Just to start the loop

	WHILE @Deleted > 0
	BEGIN
		DELETE toBeDeleted
		FROM #Rolls toBeDeleted
			JOIN (
				SELECT checkedValue.[row], checkedValue.[column]
				FROM #Rolls checkedValue
				JOIN #Rolls nearbyRolls ON
					nearbyRolls.[row] BETWEEN checkedValue.[row] - 1 AND checkedValue.[row] + 1
					AND nearbyRolls.[column] BETWEEN checkedValue.[column] - 1 AND  checkedValue.[column] + 1
			GROUP BY checkedValue.[row], checkedValue.[column]
			HAVING COUNT(*) < 5
		) selectForDelete ON toBeDeleted.[row] = selectForDelete.[row]
			AND toBeDeleted.[column] = selectForDelete.[column]

		SET @Deleted = @@ROWCOUNT
		SET @TotalDeleted += @Deleted
	END

	SELECT @TotalDeleted AS Result;
END;