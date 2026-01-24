
WITH
	banks AS (
		SELECT *
		FROM day3.input
	),
	batteries AS (
		SELECT id, bank, SUBSTRING(bank, 1, 1) battery, position = 1
		FROM banks
		UNION ALL
		SELECT id, bank, SUBSTRING(bank, position + 1, 1), position + 1
		FROM batteries
		WHERE position < 100
	),
	firstDigit AS (
		SELECT x.id, x.maxBattery digit, MIN(b.position) position
		FROM (
			SELECT id, MAX(battery) maxBattery
			FROM batteries b
			WHERE position < 100
			GROUP BY id
		) x 
		JOIN batteries b ON b.id = x.id AND b.battery = x.maxBattery
		GROUP BY x.id, x.maxBattery
	),
	secondDigit AS (
		SELECT b.id, MAX(battery) digit
		FROM batteries b
			JOIN firstDigit f ON f.id = b.id
		WHERE b.position > f.position
		GROUP BY b.id
	)
SELECT SUM(f.digit * 10 + s.digit)
FROM firstDigit f
	JOIN secondDigit s ON s.id = f.id