IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[dmlApplicationVersion]'))
BEGIN
	DROP TRIGGER [dbo].[dmlApplicationVersion]
END
GO

CREATE TRIGGER [dbo].[dmlApplicationVersion]
ON [dbo].[ApplicationVersion]
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
    SET NOCOUNT ON;
	DECLARE @LoginName VARCHAR(128)
 
    SELECT TOP 1  @LoginName = login_name
    FROM    sys.dm_exec_sessions
    WHERE   session_id = @@SPID

    IF EXISTS(SELECT 1 FROM DELETED)
    BEGIN
        IF EXISTS(SELECT 0 FROM INSERTED)
		BEGIN
			-- Update
			INSERT INTO [dbo].[ApplicationVersionAudit]
				   ([Id]
				   ,[Version]
				   ,[CreatedDate]
				   ,[UpdatedDate]
				   ,[Description]
				   ,[ModifiedBy]
				   ,[ModifiedDate]
				   ,[Operation])
			 SELECT [D].[Id]
				  ,[D].[Version]
				  ,[D].[CreatedDate]
				  ,[D].[UpdatedDate]
				  ,[D].[Description]
				  ,@LoginName
				  ,GETDATE()
				  ,'+ Updated'
			  FROM Deleted AS [D]
		END
		ELSE
		BEGIN
			-- Delete
			INSERT INTO [dbo].[ApplicationVersionAudit]
				   ([Id]
				   ,[Version]
				   ,[CreatedDate]
				   ,[UpdatedDate]
				   ,[Description]
				   ,[ModifiedBy]
				   ,[ModifiedDate]
				   ,[Operation])
			 SELECT [D].[Id]
				  ,[D].[Version]
				  ,[D].[CreatedDate]
				  ,[D].[UpdatedDate]
				  ,[D].[Description]
				  ,@LoginName
				  ,GETDATE()
				  ,'- Deleted'
			  FROM Deleted AS [D]
		END
    END
	ELSE 
	BEGIN
	   -- Insert
	   INSERT INTO [dbo].[ApplicationVersionAudit]
				   ([Id]
				   ,[Version]
				   ,[CreatedDate]
				   ,[UpdatedDate]
				   ,[Description]
				   ,[ModifiedBy]
				   ,[ModifiedDate]
				   ,[Operation])
		SELECT [I].[Id]
			,[I].[Version]
			,[I].[CreatedDate]
			,[I].[UpdatedDate]
			,[I].[Description]
			,@LoginName
			,GETDATE()
			,'+ Inserted'
		FROM Inserted AS [I]
	END
END
GO
