USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_JOB_GetBatch_MailData]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 07/12/05 
-- Description:	see: http://www.codeproject.com/KB/architecture/DatabaseMailQueue.aspx
--	for implementation details. Thanks Dan!
--	Firstly, this procedure removes old SENT mails into the MailQueueArchive
--	It then gathers emails in queue that have not been sent or have possibly
--	errored in an attempt to send.
-- Returns:		<MailQueueCollection>
/*
select * from mailqueue where status is null or status <> 'Sent'

Exec tx_Mailer_RetrieveBatchToSend '83c1c3f6-c539-41d7-815d-143fbd40e41f', 12, 5

exec tx_Mailer_RetrieveBatchToSend @threadGuid='503663A9-7A8B-4CBD-8A7B-ACC684C1C999',@batchSize=2,@retrySeconds=5

select top 10 * from mailqueue order by id desc

update mailqueue set dateprocessed = null, status = null, threadlock = null, attemptsremaining = 3 where id = 10034
*/
-- =============================================

CREATE PROCEDURE [dbo].[tx_JOB_GetBatch_MailData]
	
	@applicationId		uniqueidentifier,
	@threadGuid			uniqueidentifier,
	@batchSize			int,
	@retrySeconds		int,
	@archiveAfterDays	int
	
AS

BEGIN

	SET NOCOUNT ON

	--BEGIN ARCHIVAL

	BEGIN TRANSACTION

	--remove after @archiveAfterDays
	--avoid paused emails (paused emails have attempts remaining at -10000)
	CREATE	TABLE #tmpRemoveOldMail(Id int)
	INSERT	#tmpRemoveOldMail(Id)
	SELECT  TOP (@batchSize) q.[Id]
	FROM	[MailQueue] q 
	WHERE	q.[ApplicationId] = @applicationId AND 
			q.[DateProcessed] IS NOT NULL 
			AND (q.[Status] = 'Sent' 
				OR (q.[AttemptsRemaining] <= 0 AND q.[AttemptsRemaining] > -10000)
				)
			AND (q.[DateProcessed] < DATEADD(dd, -@archiveAfterDays, getDate()))
			
	--move prams prior to copying and deleting parent mailqueues
	INSERT	EmailParamArchive ([Id], [Name], [Value], [TMailQueueId], [dtStamp])
    SELECT	ep.[Id], ep.[Name], ep.[Value], ep.[TMailQueueId], ep.[dtStamp]
    FROM	[EmailParam] ep, [MailQueue] mq 
	WHERE	mq.[ApplicationId] = @applicationId AND 
			mq.[Id] IN (SELECT [Id] FROM #tmpRemoveOldMail) 
			AND mq.[Id] = ep.[TMailQueueId]

	--COPY MailQueue to archive
	INSERT	MailQueueArchive([Id], [dtStamp], [DateToProcess], [DateProcessed], [FromName], 
			[FromAddress], [ToAddress], [CC], [BCC], [Status], [TEmailLetterId], 
			[TSubscriptionEmailId], [Priority], [bMassMailer], [Threadlock], [AttemptsRemaining],
			[ApplicationId] )
	SELECT	mq.[Id], mq.[dtStamp], mq.[DateToProcess], mq.[DateProcessed], mq.[FromName], mq.[FromAddress], 
			mq.[ToAddress], mq.[CC], mq.[BCC], mq.[Status], mq.[TEmailLetterId], mq.[TSubscriptionEmailId], mq.[Priority], 
			mq.[bMassMailer], mq.[Threadlock], mq.[AttemptsRemaining], mq.[ApplicationId]
	FROM	[MailQueue] mq, [#tmpRemoveOldMail] t
	WHERE	t.[Id] = mq.[Id] 
			AND mq.[Id] NOT IN (SELECT mqa.[Id] FROM [MailQueueArchive] mqa)			

	--DELETE the MailQueue rows - emailParams will cascade
	DELETE	FROM [Mailqueue] WHERE [Id] IN (SELECT t.[Id] FROM [#tmpRemoveOldMail] t)

	COMMIT TRANSACTION

	DROP TABLE #tmpRemoveOldMail

	--END ARCHIVAL

	BEGIN TRANSACTION

		 -- retry old mails that failed
		UPDATE	[MailQueue]
		SET		[ThreadLock] = NULL, [DateProcessed] = NULL,
				[AttemptsRemaining] = [AttemptsRemaining] - 1
				--leave status alone so that we have  way to track on error
				--, [Status] = NULL
		WHERE	[ApplicationId] = @applicationId AND 
				[AttemptsRemaining] > 0 
				AND [ThreadLock] = null
				AND [DateProcessed] IS NOT NULL AND [DateProcessed] < DATEADD( second, @retrySeconds, GETDATE() )
				AND ([Status] IS NULL OR ([Status] IS NOT NULL AND [Status] <> 'Sent' ))
				AND [bMassMailer] = 1 

		--uses less cpu and less reads
		CREATE	TABLE #tmpRows(Id int)
		INSERT	#tmpRows(Id)
		SELECT	TOP (@batchSize) q.[Id]
		FROM	[MailQueue] q
		WHERE	q.[ApplicationId] = @applicationId AND 
				q.[ThreadLock] IS NULL
				AND q.[DateProcessed] IS NULL 
				AND q.[DateToProcess] < GETDATE()
				AND (q.[Status] IS NULL OR q.[Status] <> 'Sent')
				AND q.[AttemptsRemaining] > 0
		ORDER BY q.[Priority] ASC, q.[Id] ASC

		 -- update to lock them
		UPDATE	[MailQueue]
		SET		[ThreadLock] = @threadGuid,
				[DateProcessed] = GETDATE()
		FROM	[#tmpRows] r
		WHERE	r.[ID] = [MailQueue].[ID]
				AND [MailQueue].[ThreadLock] IS NULL
				AND [MailQueue].[DateProcessed] IS NULL 
				AND [MailQueue].[DateToProcess] < GETDATE()
				AND ([MailQueue].[Status] IS NULL OR [MailQueue].[Status] <> 'Sent')
				AND [MailQueue].[AttemptsRemaining] > 0

	COMMIT TRANSACTION

	SELECT	*
	FROM	[MailQueue]
	WHERE	[ApplicationId] = @applicationId AND [ThreadLock] = @threadGuid

END
GO
