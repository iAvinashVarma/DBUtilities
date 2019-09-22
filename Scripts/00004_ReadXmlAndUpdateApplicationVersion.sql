DECLARE @ApplicationXml XML,
		@Handle INT,  
		@PrepareXmlStatus INT,
		@Version VARCHAR(50),
		@Description NVARCHAR(MAX)

SELECT @ApplicationXml = CONVERT(XML, BulkColumn)
FROM OPENROWSET (BULK '$(applicationxml)', SINGLE_CLOB) Application
			   
EXEC @PrepareXmlStatus= sp_xml_preparedocument @Handle OUTPUT, @ApplicationXml  

SELECT  TOP 1 @Version = [Version], @Description = [Description]
FROM OPENXML(@Handle, '//Application', 2)  
WITH
(
	[Name] VARCHAR(55) '@Name',
    [Version] VARCHAR(55) 'Version',
	[Description] VARCHAR(255) 'Description'
)  

EXEC sp_xml_removedocument @Handle 

EXEC [dbo].[uspApplicationVersion]
	@Version=@Version,
	@Description=@Description

SELECT * FROM [ApplicationVersion] 