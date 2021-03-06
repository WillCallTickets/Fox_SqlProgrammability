USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetJustAnnouncedShows]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz>
-- Create date: 02/03/16>
-- Description:	Gets a listing of shows within a specified range and with specified criteria. 
--	@principal specifies which owner should be included - use multiple queries if
--		mult principals are needed	
--	@minShowDate = all show dates must be greater than this date, if greater than todays date, then use this
--		otherwise use today's date at 2am via getdate			
--	@minAnnounceDate = shows must be announced after this date. eg: we can set to only shows announced in last two weeks
--		allow for page sizing	
--  ALSO - allow for shows that we must include or should not include based upon the vcJustAnnouncedStatus column
--		*include will ignore the minAnnounceDate
-- Returns Wcss.ShowRow
/*
select * from aspnet_applications

exec [dbo].[tx_GetJustAnnouncedShows] @applicationId='AC36EB0B-152E-4B69-8B39-BB4B6C9B01E6',@principal='fox', 
	@minAnnounceDate = '1/1/2016',
	@minShowDate = '2/12/2016',
	@startRowIndex=0, @pageSize=10000
	
select vcjustannouncedstatus, * from show where id = 17027
update show set vcjustannouncedstatus = 'include' where id = 17027
*/
-- =============================================

CREATE	PROC [dbo].[tx_GetJustAnnouncedShows]

	
	@applicationId		uniqueidentifier,
	@principal			varchar(10),
	@minAnnounceDate	DateTime,			-- show must be announced greater than this date (aka 2 weeks ago)
	@minShowDate		DateTime,			-- showdate must be greater than this aka tmrw (allow for input a later date than today)
	@startRowIndex		int,
	@pageSize			int

AS

SET DEADLOCK_PRIORITY LOW

SET NOCOUNT ON

BEGIN


		
	DECLARE @today as DateTime,				--baseline - midnight (start) of today
			@maxAnnounceDate datetime		--show announce must be valid, allow leeway for shows that will be announced later today (2am)
			
	SET		@principal	= ISNULL(@principal, 'all')
	SET		@today		= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS datetime)	
	
	-- set to tomorrow at 2am
	IF (@minShowDate IS NULL OR @minShowDate < GETDATE()) BEGIN
			SET @minShowDate = DATEADD(hh, 26, @today)
	END	
	
	-- set to tonight at 2am
	-- allow leeway for shows to be announced in future
	SET		@maxAnnounceDate = DATEADD(hh, 26, @today)	

	CREATE TABLE #Pages
    (
        IndexId			int IDENTITY (1, 1) NOT NULL,
        ShowId			int,
		DateOfShow		DateTime,
		Name			varchar(2000),
		computedAnnounce DateTime
    )

	--get showdates that are greater than yesterday
	-- LEAVE NAME for debugging!!
	INSERT #Pages (ShowId, DateOfShow, Name, computedAnnounce)
	SELECT ShowId, DateOfShow, Name, computedAnnounce FROM
	(			
		SELECT	s.Id as [ShowId], sd.dtDateOfShow as [DateOfShow], s.Name, 
			COALESCE( s.dtAnnounceDate, s.dtStamp ) as [computedAnnounce],		
			ROW_NUMBER() OVER ( ORDER BY COALESCE( s.dtAnnounceDate, s.dtStamp ) DESC) AS RowNum

		FROM	[ShowDate] sd JOIN [Show] s ON sd.tShowId = s.Id

		WHERE	sd.[bActive] = 1 AND s.[bActive] = 1 AND 				
				sd.[dtDateOfShow] >= @minShowDate AND 
				CASE 
					WHEN @principal = 'all' THEN 1
					WHEN CHARINDEX(@principal, s.[vcPrincipal]) >= 1 THEN 1
					ELSE 0
				END = 1
				AND 
				CASE 
					WHEN s.vcJustAnnouncedStatus IS NULL AND
						COALESCE( s.dtAnnounceDate, s.dtStamp) >= @minAnnounceDate AND 
						COALESCE( s.dtAnnounceDate, s.dtStamp) <= @maxAnnounceDate 
					THEN 1 
					WHEN s.vcJustAnnouncedStatus IS NOT NULL AND s.vcJustAnnouncedStatus = 'include' THEN 1  
					WHEN s.vcJustAnnouncedStatus IS NOT NULL AND s.vcJustAnnouncedStatus = 'remove' THEN 0 
					ELSE 0
				END = 1
	) ShowDates
	WHERE	ShowDates.[RowNum] BETWEEN (@startRowIndex) AND (@startRowIndex + @pageSize - 1)
	ORDER BY RowNum

	SELECT s.vcJustAnnouncedStatus, s.* FROM [Show] s, [#Pages] p 
	WHERE	p.[ShowId] = s.[Id] 
	ORDER BY (CASE WHEN (s.dtAnnounceDate is null) THEN s.dtStamp ELSE s.dtAnnounceDate END) DESC, 
		s.Name DESC	
	
	--CLEANUP
	DROP TABLE #Pages

END
GO
