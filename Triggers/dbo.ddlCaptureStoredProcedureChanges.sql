IF EXISTS (SELECT 1 FROM sys.triggers WHERE Name = N'ddlCaptureStoredProcedureChanges')
BEGIN
	DROP TRIGGER ddlCaptureStoredProcedureChanges ON DATABASE
END
GO

CREATE TRIGGER [ddlCaptureStoredProcedureChanges]
    ON DATABASE
    FOR CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EventData XML = EVENTDATA(), @ip VARCHAR(32);

    SELECT @ip = client_net_address
        FROM sys.dm_exec_connections
        WHERE session_id = @@SPID;

    INSERT [dbo].[ProcedureChanges]
    (
        EventType,
        EventDDL,
        SchemaName,
        ObjectName,
        DatabaseName,
        HostName,
        IPAddress,
        ProgramName,
        LoginName
    )
    SELECT
        @EventData.value('(/EVENT_INSTANCE/EventType)[1]',   'NVARCHAR(100)'), 
        @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)'),
        @EventData.value('(/EVENT_INSTANCE/SchemaName)[1]',  'NVARCHAR(255)'), 
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]',  'NVARCHAR(255)'),
        DB_NAME(), HOST_NAME(), @ip, PROGRAM_NAME(), SUSER_SNAME();
END
GO