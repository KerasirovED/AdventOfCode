
-- Split the range into the separate columns

DROP TABLE IF EXISTS #ranges

SELECT id, CAST(LEFT([range], dashPos - 1) AS bigint) [left], CAST(STUFF([range], 1, dashPos, '') AS bigint) [right]
INTO #ranges
FROM day2.input
	CROSS APPLY (SELECT CHARINDEX('-', [range])) dashPos (dashPos)

-- Get the values inside the range

DECLARE @MaxRangeLength int = (SELECT MAX([right] - [LEFT]) + 1 FROM #ranges)
DECLARE @RangeSequencePartLength int = POWER(@MaxRangeLength, 1. / 3) + 1

DROP TABLE IF EXISTS #rangeSequence

;WITH rangeSequencePart AS (SELECT TOP (@RangeSequencePartLength) 1 rangeSequencePart FROM sys.objects)
SELECT 1 a
INTO #rangeSequence
FROM rangeSequencePart a, rangeSequencePart b, rangeSequencePart c

DROP TABLE IF EXISTS #rangeValues

SELECT [value]
INTO #rangeValues
FROM (
	SELECT ROW_NUMBER() OVER (PARTITION BY id ORDER BY (SELECT 1)) - 1 + r.[left] [value], [right]
	FROM #ranges r, (SELECT 1 FROM #rangeSequence) x (x)
) x
WHERE [value] <= [right]

-- Then we need to get values how can we split a number by some repeated sequences
-- Basically, we need to find a length of a number and its deviders, excluding the number itself
-- this is how possible to split a number to even parts
-- E.g.
--     11 has length 2, and 2 can be devided by 1 only: 1 and 1
--     222 has length 3, and 3 can be devided by 1 only: 2, 2 and 2
--     3333 has length 4, and 4 can be devided by 1 and 2 as: 44 44 and 4 4 4 4
-- So, to get the sequense of deviders, I am finding max length of a value

DECLARE @MaxLength int = (SELECT MAX(LEN(CAST([value] AS varchar))) maxLen FROM #rangeValues)

SELECT @MaxLength

DROP TABLE IF EXISTS #devisors

;WITH numbersToCalculateDevisors AS (
	SELECT @MaxLength number

	UNION ALL

	SELECT number - 1
	FROM numbersToCalculateDevisors
	WHERE number > 1
)
SELECT number.number devidend, devisor.number devisor, number.number / devisor.number quotient
INTO #devisors
FROM numbersToCalculateDevisors number
	JOIN numbersToCalculateDevisors devisor ON number.number % devisor.number = 0 AND number.number <> devisor.number

-- Here I am splitting a number by divisors based on the length of the number and get chunks for each string

--SELECT COUNT(*) FROM #rangeValues

--SELECT COUNT(*)
--	FROM #rangeValues r
--		CROSS APPLY (SELECT CAST([value] AS varchar(100))) string (string)
--		JOIN #devisors d  ON d.devidend = LEN(string)

DROP TABLE IF EXISTS #chunks

;WITH chunks AS (
	SELECT r.[value], string, devisor chunkLength, quotient numberOfChunks, 0 AS chunkNumber, SUBSTRING(string, 1, devisor) chunk
	FROM #rangeValues r
		CROSS APPLY (SELECT CAST([value] AS varchar(100))) string (string)
		JOIN #devisors d ON d.devidend = LEN(string) AND (d.devidend > 3 AND d.devisor <> 1 OR d.devidend IN (2, 3, 5, 7))

	UNION ALL 

	SELECT [value], string, chunkLength, numberOfChunks, currentChunkNumber, SUBSTRING(string, currentChunkNumber * chunkLength + 1, chunkLength)
	FROM chunks
		CROSS APPLY (SELECT chunkNumber + 1) currentChunkNumber (currentChunkNumber)
	WHERE currentChunkNumber < numberOfChunks
)
SELECT *
INTO #chunks
FROM chunks

-- And check that the chunk is the same among all chunks for the same size
-- Distinct is needed because value 222222 may be correctly split by 3 different disiors: 1, 2, and 4
-- It will be in the output tree times, but we should sum it only once
SELECT SUM(DISTINCT [value])
FROM #chunks c
WHERE chunkNumber = 0 AND chunk = ALL (
	SELECT chunk
	FROM #chunks
	WHERE [value] = c.[value] AND numberOfChunks = c.numberOfChunks
)