IF EXISTS (SELECT 1 FROM sys.objects
			WHERE  object_id = OBJECT_ID(N'[dbo].[ufnGetAge]')
           AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
BEGIN
  DROP FUNCTION [dbo].[ufnGetAge]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*======================================================================================
** File			:	[dbo].[ufnGetAge]    
** Execution	:
					SELECT * FROM [dbo].[ufnGetAge]('04-13-1990')
** ------------------------------------------------------------------------------------
** Change History
** ------------------------------------------------------------------------------------
** Date			Author		Description 
** ----------	----------	-----------------------------------------------------------
** 01/11/2018   Avi			Get the age of specified date.
======================================================================================*/

CREATE FUNCTION [dbo].[ufnGetAge]
(
	@DOB [SMALLDATETIME]
)
RETURNS @Age TABLE 
(
    [AgeYearsDecimal]	[DECIMAL] NOT NULL, 
    [AgeYearsIntRound]	[INT] NOT NULL, 
    [AgeYearsIntTrunc]	[INT] NOT NULL,
	[BirthDate]			[NVARCHAR](55) NOT NULL,
	[CurrentDate]		[NVARCHAR](55) NOT NULL
)
AS 
BEGIN
	IF @DOB IS NOT NULL 
	BEGIN
		INSERT INTO @Age
		SELECT	DATEDIFF(hour,@DOB,GETDATE())/8766.0 AS [AgeYearsDecimal],
				CONVERT(int,ROUND(DATEDIFF(HOUR,@DOB,GETDATE())/8766.0,0)) AS [AgeYearsIntRound],
				DATEDIFF(hour,@DOB,GETDATE())/8766 AS [AgeYearsIntTrunc],
				FORMAT(@DOB, 'dd, MMMM yyyy') AS [BirthDate],
				FORMAT(GETDATE(), 'dd, MMMM yyyy') [CurrentDate]
	END

	RETURN;
END;
GO