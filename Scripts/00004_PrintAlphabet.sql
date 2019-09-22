;WITH [Alphabet] AS
(
	SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS [A] 
	from sys.all_columns
)
SELECT CHAR([A]) AS [Alpha]
FROM 
  [Alphabet]
WHERE
  ([A] > 64 AND [A] < 91) OR
  ([A] > 96 AND [A] < 123);
GO
