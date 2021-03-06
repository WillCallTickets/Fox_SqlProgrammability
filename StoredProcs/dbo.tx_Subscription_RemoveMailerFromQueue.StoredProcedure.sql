USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_Subscription_RemoveMailerFromQueue]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 08/02/12
-- Description:	Removes a subscription email from the queue.
-- =============================================

CREATE	PROC [dbo].[tx_Subscription_RemoveMailerFromQueue]

	@subscriptionEmailId 	int

AS

BEGIN

	--only delete those that have not been sent - dependent objects are cascaded
	DELETE	FROM [MailQueue]
	WHERE	[TSubscriptionEmailId] = @subscriptionEmailId AND
			([Status] IS NULL OR [Status] <> 'Sent')

END
GO
