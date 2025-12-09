
;WITH 
	ranges AS (
		SELECT id, CAST(LEFT([range], dashPos - 1) AS bigint) [left], CAST(STUFF([range], 1, dashPos, '') AS bigint) [right]
		FROM day2.input
			CROSS APPLY (SELECT CHARINDEX('-', [range])) dashPos (dashPos)
	),
	rangeValues AS (
		SELECT *
		FROM (
			SELECT ROW_NUMBER() OVER (PARTITION BY id ORDER BY (SELECT 1)) - 1 + r.[left] [value]
			FROM ranges r, (SELECT TOP 235364 1 FROM sys.objects a, sys.objects b, sys.objects c) x (x)
		) x
		WHERE [value] <= [right]
	),
	invalides AS (
		SELECT v.[value]
		FROM rangeValues v
			CROSS APPLY (SELECT CAST([value] AS varchar(100))) string (string)
			CROSS APPLY (SELECT LEN(string) / 2) half (half)
			CROSS APPLY (SELECT LEFT(string, half), STUFF(string, 1, half, '')) halfs ([left], [right])
		WHERE halfs.[left] = halfs.[right]	
	)
SELECT SUM([value])
FROM invalides