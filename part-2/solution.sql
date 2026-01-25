
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
    SELECT rr.id [row], roll.ordinal [column]
    INTO #Rolls
    FROM @RollsRows rr
		CROSS APPLY REGEXP_SPLIT_TO_TABLE(rollsRow, '') roll
	WHERE roll.[value] = '@' -- we are interested only in the cells with rolls -> reduce the dataset

	CREATE INDEX idx_rolls ON #Rolls ([row], [column]);

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
					-- here we select all eight rolls, this condition is better for index seeks
					-- be aware that the checked roll is included in the nearby rolls
					JOIN #Rolls nearbyRolls ON
						nearbyRolls.[row] BETWEEN checkedValue.[row] - 1 AND checkedValue.[row] + 1
						AND nearbyRolls.[column] BETWEEN checkedValue.[column] - 1 AND  checkedValue.[column] + 1
			GROUP BY checkedValue.[row], checkedValue.[column]
			HAVING COUNT(*) < 5 -- because the checked roll is included, the condition got changed from < 4 to < 5
		) selectForDelete ON toBeDeleted.[row] = selectForDelete.[row]
			AND toBeDeleted.[column] = selectForDelete.[column]

		SET @Deleted = @@ROWCOUNT
		SET @TotalDeleted += @Deleted
	END

	SELECT @TotalDeleted AS Result;
END;