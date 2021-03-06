USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_Z2SubscriptionUpdate]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 08/27/2014
-- Description:	Manages a subscription request. Keeps a history of all transactions 

/*

exec [tx_Z2SubscriptionUpdate] 'fred@w.com', 'website signup', 'subscribe', '1234'
exec [tx_Z2SubscriptionUpdate] 'fred@w.com', 'website signup', 'unsubscribe', '1234'

select * from z2subscription
select * from z2subscriptionrequest

--delete from z2subscription
--delete from z2subscriptionrequest
*/
-- =============================================

CREATE	PROC [dbo].[tx_Z2SubscriptionUpdate]

	@email varchar(256),
	@sourcePage varchar(50),
	@subRequest varchar(25),
	@ipAddress varchar(25),
	@initialsourceQuery varchar(256)

AS

SET NOCOUNT ON

BEGIN

	--determine if a Z2sub exists - if not create one - if it does, create a sub request and update the sub
	DECLARE @reqIdx int
	SET		@reqIdx = 0
	DECLARE @subIdx int
	SET		@subIdx = 0
	DECLARE	@current bit
	SET		@current = 0

	SELECT	@subIdx = z.[Id], @current = z.[bSubscribed] FROM [Z2Subscription] z WHERE z.[Email] = @email

	-- VALIDATION
	-- if we are trying to unsubscribe and the email does not exist then warn
	IF (@subRequest <> 'subscribe' AND @subIdx = 0) BEGIN
	
		SELECT @email + ' does not exist in our database.'
		
		RETURN
		
	END
	--if they are trying to unsubscribe an unsubscribed email
	ELSE IF(@subRequest <> 'subscribe' AND @subIdx > 0 AND @current = 0) BEGIN
	
		SELECT @email + ' is currently unsubscribed.'
		
		RETURN
		
	END 
	--ELSE IF(@subRequest <> 'subscribe' AND @subIdx > 0 AND @current = 1) BEGIN -- do the update
	ELSE IF(@subRequest = 'subscribe' AND @subIdx = 0 AND @sourcePage = 'Confirmation Click') BEGIN
	
		SELECT @email + ' is not in our database.'
		
		RETURN
		
	END 
	
	--if they have put in a request and it is pending - they need to get a confirm email again
	ELSE IF(@subRequest = 'subscribe' AND @subIdx > 0 AND @current = 0 AND @sourcePage = 'Website Signup') BEGIN
	
		SELECT @email + ' is currently pending.'
		
		RETURN
		
	END 
	--if they are trying to subscribe a subscribed email
	ELSE IF(@subRequest = 'subscribe' AND @subIdx > 0 AND @current = 1) BEGIN
	
		SELECT @email + ' is currently subscribed.'
		
		RETURN
		
	END 
	
	--If we are creating a new record, then create that record as unsubscribed
	--An email confirmation request will be sent to enable the subscription
	IF (@subIdx = 0) BEGIN

		INSERT	[Z2Subscription]([dtCreated], [Email], [IpAddress], [bSubscribed], [InitialSourceQuery])
		VALUES	((getDate()), @email, @ipAddress, 0, @initialsourceQuery)
		
	END

	ELSE BEGIN
		
		INSERT	[Z2SubscriptionRequest]([dtStamp], [tZ2SubscriptionId], [Source], [SubscriptionRequest], [IpAddress])
		VALUES	((getDate()), @subIdx, @sourcePage, @subRequest, @ipAddress)
		
		SELECT	@reqIdx = SCOPE_IDENTITY()
		
		UPDATE	[Z2Subscription]
		SET		[dtModified] = (getDate()),
				[bSubscribed] = CASE WHEN @subRequest = 'subscribe' THEN 1 ELSE 0 END,
				[tZ2SubscriptionHistoryId] = @reqIdx			
		FROM	[Z2Subscription] z
		WHERE	z.[Id] = @subIdx

	END 
	
	SELECT 'SUCCESS'
	
	RETURN
	
END
GO
