
WITH
	rotations AS (
		SELECT
			id,
			IIF(LEFT(rotation, 1) = 'L', -1, 1) * CAST(STUFF(rotation, 1, 1, '') AS int) rotation
		FROM day1.input
	),
	positions AS (
		SELECT 0 AS id, 0 AS rotation, 50 AS position, NULL clicksThroughZero, NULL rawPosition
		UNION ALL
		SELECT r.id, r.rotation,
			IIF(noNegativeCorrection.position < 0, 100 + noNegativeCorrection.position, noNegativeCorrection.position),
			ABS(noNegativeCorrection.clicksThroughZero)
				-- if it is below 0, it is 0 intersection -> + 1, except if we started rolling from 0
				 + IIF(noNegativeCorrection.position < 0 AND previousPosition.position <> 0, 1, 0)
				 -- if we ended on 0, and were rolling to the left, we must add one intersection with 0
				 + IIF(noNegativeCorrection.position = 0 AND r.rotation < 0, 1, 0)
			AS clicksThroughZero
		FROM rotations r
			JOIN positions previousPosition ON previousPosition.id + 1 = r.id
			CROSS APPLY (SELECT position + r.rotation) rawPosition (rawPosition)
			CROSS APPLY (SELECT rawPosition % 100, rawPosition / 100) AS noNegativeCorrection (position, clicksThroughZero)
	)
SELECT SUM(clicksThroughZero)
FROM positions
OPTION (MAXRECURSION 5000)