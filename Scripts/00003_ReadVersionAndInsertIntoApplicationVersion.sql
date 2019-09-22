DECLARE @Version VARCHAR(50)
DECLARE @Description NVARCHAR(MAX)

SELECT @Version = BulkColumn
FROM OPENROWSET (BULK '$(versionfile)', SINGLE_CLOB) Version

SELECT @Description = BulkColumn
FROM OPENROWSET (BULK '$(description)', SINGLE_CLOB) Description

EXEC [dbo].[uspApplicationVersion]
	@Version=@Version,
	@Description=@Description

SELECT * FROM [ApplicationVersion] 