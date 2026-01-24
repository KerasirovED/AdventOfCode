
DECLARE
	@NumberOfBatteries int = 12,
	@BankLength int = 100

DROP TABLE IF EXISTS #batteries

CREATE TABLE #batteries (
	id tinyint,
	position tinyint,
	battery tinyint
)

CREATE INDEX IX_batteries_id_position ON #batteries (id, position) INCLUDE (battery)
CREATE INDEX IX_batteries_position_id ON #batteries (position) INCLUDE (id, battery)

;WITH batteries AS (
	SELECT id, bank, SUBSTRING(bank, 1, 1) battery, position = 1
	FROM day3.input
	UNION ALL
	SELECT id, bank, SUBSTRING(bank, position + 1, 1), position + 1
	FROM batteries
	WHERE position < @BankLength
)
INSERT INTO #batteries (id, position, battery)
SELECT id, position, battery
FROM batteries

;WITH digits AS (
	SELECT b.id, b.battery * POWER(CAST(10 AS bigint), digitPosition) digit, digitPosition, MIN(b.position) batteryPosition
	FROM #batteries b
		CROSS APPLY (SELECT @NumberOfBatteries - 1) digitPosition (digitPosition)
	WHERE position <= @BankLength - digitPosition AND b.battery = (
		SELECT MAX(battery) maxBattery
		FROM #batteries
		WHERE id = b.id AND position <= @BankLength - digitPosition
	)
	GROUP BY id, battery, digitPosition

	UNION ALL

	SELECT id, digit, digitPosition, batteryPosition
	FROM (
		SELECT b.id, b.battery * POWER(CAST(10 AS bigint), digitPosition - 1) digit, digitPosition - 1 digitPosition,
			b.position batteryPosition, ROW_NUMBER() OVER (PARTITION BY b.id ORDER BY battery DESC, b.position) r
		FROM digits d
			JOIN #batteries b ON b.id = d.id
				AND b.position BETWEEN d.batteryPosition + 1 AND @BankLength - d.digitPosition + 1
		WHERE d.digitPosition > 0
	) x
	WHERE r = 1
)
SELECT SUM(digit) joltage
FROM digits