USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_JOB_MailReport]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 07/12/05
-- Description:	Inserts a reporting event into the eventQ
-- exec [tx_JOB_MailReport] 1
--select top 10 * from eventq order by id desc
--select DATEADD(dd, -1, (getDate()))
-- =============================================

CREATE PROC [dbo].[tx_JOB_MailReport]

	@applicationName varchar(256),
	@isDaily		bit

AS

SET NOCOUNT ON

BEGIN

	IF (@isDaily = 1) BEGIN

		DECLARE @appId uniqueIdentifier
		SELECT	@appId = [ApplicationId] FROM [Aspnet_Applications] WHERE [ApplicationName] = @applicationName
	
		INSERT EventQ ([ApplicationId], [DateToProcess], [iPriority], [Context], [Verb], [CreatorName], [OldValue])
		VALUES (@appId, (getDate()), 5, 'Report', 'Report_Mailer_Daily', 'SqlAgent', CONVERT(varchar, DATEADD(dd, -1, (getDate())), 101))

	END
	ELSE BEGIN
		SELECT 1
	END

END
GO
