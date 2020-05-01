IF EXISTS (SELECT 1 FROM sys.objects
			WHERE  object_id = OBJECT_ID(N'[dbo].[ufnDistinctList]')
           AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
BEGIN
  DROP FUNCTION [dbo].[ufnDistinctList]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*======================================================================================
** File			:	[dbo].[ufnDistinctList]    
** Execution	:
					SELECT [dbo].[ufnDistinctList]('Avi,Avinash,Avi,Varma',',') AS [D]
** ------------------------------------------------------------------------------------
** Change History
** ------------------------------------------------------------------------------------
** Date			Author		Description 
** ----------	----------	-----------------------------------------------------------
** 01/05/2020   Avi			Remove duplicates from CSV seperated string.
======================================================================================*/

CREATE FUNCTION [dbo].[ufnDistinctList]
(
	@List NVARCHAR(MAX),
	@Delimiter CHAR
)
RETURNS
NVARCHAR(MAX)
AS
BEGIN
	DECLARE @ParsedList TABLE
	(
		Item NVARCHAR(MAX)
	)

	DECLARE @ListOne NVARCHAR(MAX)
		,@Position INT
		,@ResultList NVARCHAR(MAX)

	SELECT @List = LTRIM(RTRIM(@List)) + @Delimiter
		,@Position = CHARINDEX(@delimiter, @List, 1)
	
	WHILE @Position > 0
	BEGIN
		SET @ListOne = LTRIM(RTRIM(LEFT(@List, @Position - 1)))
		IF @ListOne <> ''
		INSERT INTO @ParsedList VALUES (CAST(@ListOne AS NVARCHAR(MAX)))
		SET @List = SUBSTRING(@List, @Position+1, LEN(@List))
		SET @Position = CHARINDEX(@delimiter, @List, 1)
	END
	SELECT @ResultList = COALESCE(@ResultList+',','') + item
	FROM (SELECT DISTINCT Item FROM @ParsedList) t
	RETURN @ResultList
END
GO
