USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_Mailer_ProcessCustomEmailerList]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 04/04/2014
-- Description:	Given a list of emails - match emails to fox subscribers and return a list of emails we can send to. 
-- =============================================

CREATE	PROC [dbo].[tx_Mailer_ProcessCustomEmailerList]

	@appId		uniqueidentifier,
	@emailList	varchar(MAX)

AS

SET NOCOUNT ON

SET DEADLOCK_PRIORITY LOW 

BEGIN

	CREATE TABLE #tmpCustEmail 
	(
		[Id]	[int] NOT NULL,
		[email]	varchar(256) NOT NULL,
		[inFoxDb] bit NOT NULL,
		[subscribed] bit NOT NULL,
		[unsubscribed] bit NOT NULL
	)
			
	--list to table to start things off
	INSERT	#tmpCustEmail([Id], [Email], [inFoxDb], [subscribed], [unsubscribed])
	SELECT	fn.[Id], fn.[ListItem] as [Email], 0 as [inFoxDb], 0 as [subscribed], 0 as [unsubscribed]
	FROM	fn_ListToTable( @emailList ) fn
		
	--total emails entered
	SELECT COUNT(*) FROM #tmpCustEmail 
	
	DELETE FROM #tmpCustEmail WHERE [Email] is null or len(RTRIM(ltrim([Email]))) = 0
	
	--total valid emails
	SELECT COUNT(DISTINCT([Email])) FROM #tmpCustEmail 
	
	UPDATE #tmpCustEmail
	SET inFoxDb = 1 
	FROM #tmpCustEmail tmp LEFT OUTER JOIN aspnet_Users u on u.UserName = tmp.[Email]
	WHERE u.UserName IS NOT NULL
		
	UPDATE #tmpCustEmail 
	SET subscribed = 1
	FROM #tmpCustEmail tmp LEFT OUTER JOIN aspnet_Users u on u.UserName = tmp.[Email]
		LEFT OUTER JOIN SubscriptionUser su on su.UserId = u.userid
	WHERE tmp.[inFoxDb] = 1 and su.bSubscribed = 1
		
	UPDATE #tmpCustEmail 
	SET unsubscribed = 1
	FROM #tmpCustEmail tmp LEFT OUTER JOIN aspnet_Users u on u.UserName = tmp.[Email] 
		LEFT OUTER JOIN SubscriptionUser su on su.UserId = u.userid	
	WHERE tmp.[inFoxDb] = 1 and su.bSubscribed = 0
			
	--emails NOT in fox db
	SELECT COUNT(DISTINCT([Email])) FROM #tmpCustEmail WHERE [inFoxDb] = 0
	
	--emails in fox db
	SELECT COUNT(DISTINCT([Email])) FROM #tmpCustEmail WHERE [inFoxDb] = 1 
	
	--subscribed in fox db
	SELECT COUNT(DISTINCT([Email])) FROM #tmpCustEmail WHERE [inFoxDb] = 1 AND [subscribed] = 1
		
	--unsubscribed in fox db
	SELECT COUNT(DISTINCT([Email])) FROM #tmpCustEmail WHERE [inFoxDb] = 1 AND [unsubscribed] = 1	
		
	--Final List
	SELECT DISTINCT([Email]) 
	FROM #tmpCustEmail 
	WHERE [Email] IS NOT NULL AND 
		([inFoxDb] = 0 OR ([inFoxDb] = 1 and [subscribed] = 1))	
		
END
GO
