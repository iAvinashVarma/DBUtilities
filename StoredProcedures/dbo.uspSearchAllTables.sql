IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id(N'[dbo].[uspSearchAllTables]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[uspSearchAllTables]
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*======================================================================================
** File			:	[dbo].[uspSearchAllTables]    
** Execution	:
					EXEC [dbo].[uspSearchAllTables]
					@Search='Avi'
** ------------------------------------------------------------------------------------
** Change History
** ------------------------------------------------------------------------------------
** Date			Author		Description 
** ----------	----------	-----------------------------------------------------------
** 01/11/2018   Avi			Search for the value in tables.
======================================================================================*/

CREATE PROCEDURE [dbo].[uspSearchAllTables]
(
	@Search NVARCHAR(100)
)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Results TABLE
	(
		ColumnName NVARCHAR(370),
		ColumnValue nvarchar(3630)
	)

	DECLARE @TableName NVARCHAR(256), @ColumnName NVARCHAR(128), @SearchTemp NVARCHAR(110)
	SET  @TableName = ''
	SET @SearchTemp = QUOTENAME('%' + @Search + '%','''')

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
			FROM    INFORMATION_SCHEMA.TABLES
			WHERE       TABLE_TYPE = 'BASE TABLE'
				AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
				AND OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
							 ), 'IsMSShipped'
							   ) = 0
		)

		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT MIN(QUOTENAME(COLUMN_NAME))
				FROM    INFORMATION_SCHEMA.COLUMNS
				WHERE       TABLE_SCHEMA    = PARSENAME(@TableName, 2)
					AND TABLE_NAME  = PARSENAME(@TableName, 1)
					AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
					AND QUOTENAME(COLUMN_NAME) > @ColumnName
			)

			IF @ColumnName IS NOT NULL
			BEGIN
				INSERT INTO @Results
				EXEC
				(
					'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
					FROM ' + @TableName + ' (NOLOCK) ' +
					' WHERE ' + @ColumnName + ' LIKE ' + @SearchTemp
				)
			END
		END 
	END

	SELECT ColumnName, ColumnValue FROM @Results
END
GO