IF EXISTS(SELECT 1 FROM sysobjects WHERE id = object_id(N'[dbo].[uspApplicationVersion]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[uspApplicationVersion]
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*======================================================================================
** File			:	[dbo].[uspApplicationVersion]    
** Execution	:
					EXEC [dbo].[uspApplicationVersion]
					@Version='6.71.1.0' ,
					@Description='Test'
** ------------------------------------------------------------------------------------
** Change History
** ------------------------------------------------------------------------------------
** Date			Author		Description 
** ----------	----------	-----------------------------------------------------------
** 01/11/2018   Avi			Update Version.
======================================================================================*/

CREATE PROCEDURE [dbo].[uspApplicationVersion]
(
	@Version VARCHAR(50),
	@Description NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS (SELECT 1 FROM [dbo].[ApplicationVersion] WHERE [Version] = @Version)
	BEGIN
		UPDATE [dbo].[ApplicationVersion]
		SET [UpdatedDate] = GETDATE(),
			[Description] = @Description
		WHERE [Version] = @Version
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[ApplicationVersion]
				([Version]
				,[CreatedDate]
				,[Description])
		VALUES
				(@Version
				,GETDATE()
				,@Description)
	END
END
GO