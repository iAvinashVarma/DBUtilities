IF EXISTS(SELECT *  FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ProcedureChanges')
BEGIN
	DROP TABLE [dbo].[ProcedureChanges]
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProcedureChanges](
	[EventDate] [datetime] NOT NULL,
	[EventType] [nvarchar](100) NULL,
	[EventDDL] [nvarchar](max) NULL,
	[DatabaseName] [nvarchar](255) NULL,
	[SchemaName] [nvarchar](255) NULL,
	[ObjectName] [nvarchar](255) NULL,
	[HostName] [nvarchar](255) NULL,
	[IPAddress] [varchar](32) NULL,
	[ProgramName] [nvarchar](255) NULL,
	[LoginName] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProcedureChanges] ADD  DEFAULT (getdate()) FOR [EventDate]
GO


