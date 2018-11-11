IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id(N'[dbo].[uspSearchAllTablesExact]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[uspSearchAllTablesExact]
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*======================================================================================
** File			:	[dbo].[uspSearchAllTablesExact]    
** Execution	:
					EXEC [dbo].[uspSearchAllTablesExact]
					@Search='Employee'
** ------------------------------------------------------------------------------------
** Change History
** ------------------------------------------------------------------------------------
** Date			Author		Description 
** ----------	----------	-----------------------------------------------------------
** 01/11/2018   Avi			Search exact value availability in tables.
======================================================================================*/

CREATE PROCEDURE [dbo].[uspSearchAllTablesExact]
(
    @Search NVARCHAR(4000),
    @ExactMatch BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Temp TABLE
	(
		RowId		INT IDENTITY(1,1),
		SchemaName	SYSNAME,
		TableName	SYSNAME,
		ColumnName	SYSNAME,
		DataType	VARCHAR(100),
		DataFound	BIT
	)

	INSERT  INTO @Temp
	(
		TableName,
		SchemaName,
		ColumnName,
		DataType
	)
	SELECT	C.Table_Name,
			C.TABLE_SCHEMA,
			C.Column_Name,
			C.Data_Type
	FROM    Information_Schema.Columns AS C
	INNER JOIN Information_Schema.Tables AS T
	ON C.Table_Name = T.Table_Name
	AND C.TABLE_SCHEMA = T.TABLE_SCHEMA
	WHERE Table_Type = 'Base Table'
	AND Data_Type IN ('ntext','text','nvarchar','nchar','varchar','char')

	DECLARE @i INT
	DECLARE @MAX INT
	DECLARE @TableName sysname
	DECLARE @ColumnName sysname
	DECLARE @SchemaName sysname
	DECLARE @SQL NVARCHAR(4000)
	DECLARE @PARAMETERS NVARCHAR(4000)
	DECLARE @DataExists BIT
	DECLARE @SQLTemplate NVARCHAR(4000)

	SELECT  @SQLTemplate = CASE WHEN @ExactMatch = 1
								THEN 'If Exists(Select *
											  From   ReplaceTableName
											  Where  Convert(nVarChar(4000), [ReplaceColumnName])
														   = ''' + @Search + '''
											  )
										 Set @DataExists = 1
									 Else
										 Set @DataExists = 0'
								ELSE 'If Exists(Select *
											  From   ReplaceTableName
											  Where  Convert(nVarChar(4000), [ReplaceColumnName])
														   Like ''%' + @Search + '%''
											  )
										 Set @DataExists = 1
									 Else
										 Set @DataExists = 0'
								END,
			@PARAMETERS = '@DataExists Bit OUTPUT',
			@i = 1

	SELECT @i = 1, @MAX = MAX(RowId)
	FROM   @Temp

	WHILE @i <= @MAX
		BEGIN
			SELECT  @SQL = REPLACE(REPLACE(@SQLTemplate, 'ReplaceTableName', QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName)), 'ReplaceColumnName', ColumnName)
			FROM    @Temp
			WHERE   RowId = @i


			PRINT @SQL
			EXEC SP_EXECUTESQL @SQL, @PARAMETERS, @DataExists = @DataExists OUTPUT

			IF @DataExists =1
				UPDATE @Temp SET DataFound = 1 WHERE RowId = @i

			SET @i = @i + 1
		END

	SELECT  SchemaName,TableName, ColumnName
	FROM    @Temp
	WHERE   DataFound = 1
END
GO