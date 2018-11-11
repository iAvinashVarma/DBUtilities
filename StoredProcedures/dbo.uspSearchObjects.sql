IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id(N'[dbo].[uspSearchObjects]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[uspSearchObjects]
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*======================================================================================
** File			:	[dbo].[uspSearchObjects]    
** Execution	:
					EXEC [dbo].[uspSearchObjects] @Search='Av'
** ------------------------------------------------------------------------------------
** Change History
** ------------------------------------------------------------------------------------
** Date			Author		Description 
** ----------	----------	-----------------------------------------------------------
** 01/11/2018   Avi			Search objects and their availability.
======================================================================================*/

CREATE PROCEDURE [dbo].[uspSearchObjects]
(
    @Search NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	QUOTENAME(SCHEMA_NAME([O].[schema_id])) + '.' + QUOTENAME([O].[name]) AS [ObjectName],
			[O].[modify_date] AS [ModifyDate],
			REPLACE([O].[type_desc], '_', ' ') AS [TypeDescription],
			[M].[definition] AS [Definition]
	FROM sys.sql_modules AS [M]
	INNER JOIN sys.objects AS [O]
	ON [M].[object_id] = [O].[object_id]
	WHERE [M].[definition] LIKE '%' + @Search + '%'
	ORDER BY	[O].[type_desc] ASC,
				[O].[modify_date] DESC
END;
GO
