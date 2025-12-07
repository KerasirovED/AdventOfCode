
WITH
	rotations AS (
		SELECT id, IIF(LEFT(rotation, 1) = 'L', -1, 1) * CAST(STUFF(rotation, 1, 1, '') AS int) % 100 rotation
		FROM day1.input
	),
	positions AS (
		SELECT 0 AS id, 0 AS rotation, 50 AS position
		UNION ALL
		SELECT r.id, r.rotation,
			CASE
				WHEN rawPosition >= 100 THEN rawPosition - 100
				WHEN rawPosition < 0 THEN rawPosition + 100
				ELSE rawPosition
			END
		FROM rotations r
			JOIN positions p ON p.id + 1 = r.id
			CROSS APPLY (SELECT position + r.rotation) rawPosition (rawPosition)
	)
SELECT COUNT(*) AS result
FROM positions p
WHERE p.position = 0
OPTION (MAXRECURSION 5000)