USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetShowDatesInRange]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 09/11/14
-- Description:	Gets a listing of showdates within a specified range and with specified criteria. 
--	Specifying a [@defaultVenue] causes the order of venues to be keyed off the specified venue,
--		so that the default venue is listed first.
--	Specifying a [@selectedVenueId] filters the list to the specified venue only
--	Specifying [@returnSimpleRows] indicates that we should send back a simplified version 
--		of the show info - currently ShowDateId,DateOfShow,ShowNamePart
--	Specifying [@returnShowDateRows] indicates that we should send back the showdate objects 
--	Specifying [@returnTicketRows] indicates that we should send back the showticket objects
-- Returns string or Wcss.ShowDateRow
/*
select * from aspnet_applications

exec [dbo].[tx_GetShowDatesInRange] @applicationId='AC36EB0B-152E-4B69-8B39-BB4B6C9B01E6',@defaultVenue='The Fox Theatre',
@selectedVenueId=0,@startDate='10/31/2009 12:00AM',@endDate='12/14/2009 11:59PM',@startRowIndex=1,
@pageSize=30,@returnSimpleRows=1,@returnShowDateRows=1,@returnTicketRows=1
*/
-- =============================================

CREATE	PROC [dbo].[tx_GetShowDatesInRange]
	
	@applicationId		uniqueidentifier,
	@defaultVenue		varchar(500),
	@selectedVenueId	int,
	@startDate			varchar(50),
	@endDate			varchar(50),
	@startRowIndex		int,
	@pageSize			int,
	@returnSimpleRows	bit,
	@returnShowDateRows	bit,
	@returnTicketRows	bit

AS

SET DEADLOCK_PRIORITY LOW

SET NOCOUNT ON

BEGIN

	CREATE TABLE #SD_Pages
    (
        IndexId			int IDENTITY (1, 1) NOT NULL,
        ShowDateId		int,
		DateOfShow		DateTime,
		ShowNamePart	varchar(2000)
    )

	--get showdates that are greater than yesterday
	INSERT #SD_Pages (ShowDateId,DateOfShow,ShowNamePart)
	SELECT ShowDateId,DateOfShow,ShowNamePart FROM
	(	
		SELECT	DISTINCT(sd.[Id]) as ShowDateId, sd.[dtDateOfShow] as DateOfShow, 
			LTRIM(SUBSTRING(s.[Name],22,LEN(s.[Name]))) as ShowNamePart, 

			ROW_NUMBER() OVER ( ORDER BY sd.[dtDateOfShow],
				CASE WHEN (v.[Name] = @defaultVenue) THEN '___' + @defaultVenue ELSE v.[Name] END
			) AS RowNum

		FROM	[ShowDate] sd, [Show] s, [Venue] v
		WHERE	s.[ApplicationId] = @applicationId AND 
				s.[Id] = sd.[tShowId] AND 
				sd.[dtDateOfShow] BETWEEN @startDate AND @endDate AND
				s.[tVenueId] = v.[Id] AND

				--ALLOW VENUE SELECTIONS
				CASE @selectedVenueId 
					WHEN 0 THEN 1 ELSE CASE WHEN @selectedVenueId > 0 AND v.[Id] = @selectedVenueId THEN 1 ELSE 0 END
				END = 1

	) ShowDates
	WHERE	ShowDates.[RowNum] BETWEEN (@startRowIndex) AND (@startRowIndex + @pageSize - 1)
	ORDER BY RowNum

	--IF SPECIFIED - RETURN SHOWDATE ROWS
	IF	(@returnSimpleRows = 1)	
		SELECT ShowDateId, DateOfShow, ShowNamePart 
		FROM #SD_Pages
	ELSE
		SELECT NULL
	
	IF	(@returnShowDateRows = 1)
		SELECT [sd].* 
		FROM [ShowDate] sd, [#SD_Pages] p 
		WHERE sd.[Id] = p.[ShowDateId] 
		ORDER BY p.[IndexId]
	ELSE
		SELECT NULL

	IF	(@returnTicketRows = 1)
		SELECT	st.*
		FROM [vw_ShowTicketWithPending] st, [#SD_Pages] p 
		WHERE st.[tShowDateId] = p.[ShowDateId] 
		ORDER BY st.[tShowDateId], st.[iDisplayOrder]
	ELSE
		SELECT NULL

	--CLEANUP
	DROP TABLE #SD_Pages

END
GO
