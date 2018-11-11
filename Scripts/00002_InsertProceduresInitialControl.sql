INSERT [dbo].[ProcedureChanges]
(
    [EventType],
    [EventDDL],
    [DatabaseName],
    [SchemaName],
    [ObjectName]
)
SELECT
    N'Initial control',
    OBJECT_DEFINITION([object_id]),
    DB_NAME(),
    OBJECT_SCHEMA_NAME([object_id]),
    OBJECT_NAME([object_id])
FROM
    sys.procedures AS [P]