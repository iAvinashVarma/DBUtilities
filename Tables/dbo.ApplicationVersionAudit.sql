IF EXISTS(SELECT *  FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ApplicationVersionAudit')
BEGIN
	DROP TABLE [dbo].[ApplicationVersionAudit]
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ApplicationVersionAudit](
	[Id] [int] NOT NULL,
	[Version] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[Description] [nvarchar](max) NULL,
	[ModifiedBy] [varchar](255) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Operation] [nvarchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
