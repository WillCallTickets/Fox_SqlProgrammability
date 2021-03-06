USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_Subscription_InsertMailerIntoQueue]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 08/02/12
-- Description:	Sends an email to its subscription. 
/*
exec tx_Subscription_InsertMailerIntoQueue @subscriptionEmailId=10008,@sendDate=N'5/4/2008 12:51:00 AM',
	@fromName=N'Sts9Store Subscriptions',@fromAddress=N'subscriptions@sts9store.com',@priority=10
*/
-- =============================================

CREATE	PROC [dbo].[tx_Subscription_InsertMailerIntoQueue]

	@applicationId			uniqueidentifier,
	@subscriptionEmailId 	int,
	@sendDate				varchar(25),
	@fromName				varchar(256),
	@fromAddress			varchar(256),
	@priority				int

AS

BEGIN
	
	SET NOCOUNT ON

	DECLARE	@emailLetterId	int,
			@subscriptionId	int
	SET		@emailLetterId = 0
	SET		@subscriptionId = 0

	SELECT	@emailLetterId = el.[Id], @subscriptionId = se.[TSubscriptionId]
	FROM	[EmailLetter] el, [SubscriptionEmail] se
	WHERE	se.[Id] = @subscriptionEmailId AND 
			se.[TEmailLetterId] = el.[Id]

	UPDATE	[SubscriptionEmail]
	SET		[dtLastSent] = ((getDate()))
	WHERE	[Id] = @subscriptionEmailId

	CREATE TABLE #tmpSubscribed(UserName varchar(500))
	INSERT  #tmpSubscribed(UserName)
	SELECT	DISTINCT au.[UserName]
	FROM	[SubscriptionUser] su, [Aspnet_Users] au
	WHERE	su.[TSubscriptionId] = @subscriptionId AND 
			su.[bSubscribed] = 1 AND 
			su.[UserId] = au.[UserId]
	ORDER BY au.[UserName]

	INSERT	MailQueue([ApplicationId], [DateToProcess], [FromName], [FromAddress], [ToAddress], [TEmailLetterId], 
		[TSubscriptionEmailId], [Priority], [bMassMailer])
	SELECT	@applicationId, @sendDate, @fromName, @fromAddress, 
			ts.[UserName], 
			@emailLetterId, @subscriptionEmailId, @priority, 1
	FROM	#tmpSubscribed ts
	ORDER BY ts.[UserName]

	SELECT	@@ROWCOUNT

END
GO
