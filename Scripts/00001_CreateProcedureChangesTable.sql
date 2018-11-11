IF NOT EXISTS (SELECT 1 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'ProcedureChanges')
BEGIN
	CREATE TABLE [dbo].[ProcedureChanges]
	(
		[EventDate]    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
		[EventType]    NVARCHAR(100),
		[EventDDL]     NVARCHAR(MAX),
		[DatabaseName] NVARCHAR(255),
		[SchemaName]   NVARCHAR(255),
		[ObjectName]   NVARCHAR(255),
		[HostName]     NVARCHAR(255),
		[IPAddress]    VARCHAR(32),
		[ProgramName]  NVARCHAR(255),
		[LoginName]    NVARCHAR(255)
	);
END
GO