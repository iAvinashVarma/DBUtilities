IF EXISTS(SELECT *  FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND  TABLE_NAME = 'ApplicationVersion')
BEGIN
	DROP TABLE [dbo].[ApplicationVersion]
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ApplicationVersion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Version] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[Description] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
