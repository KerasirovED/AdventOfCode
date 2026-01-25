
USE AdventOfCode2025
GO

CREATE OR ALTER PROC day5.Part1
    @Ranges day5.Ranges READONLY,
    @Values day5.[Values] READONLY
AS
    SELECT COUNT(DISTINCT v.[value])
    FROM @Values v
        JOIN @Ranges r ON v.[value] BETWEEN r.[start] AND r.[end]
GO