USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetShowDatesInRange_Count]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 09/11/14
-- Description:	Gets THE COUNT of listing of showdates within a specified range and with specified criteria. 
--	Specifying a [@selectedVenueId] filters the list to the specified venue only
-- Returns int
-- =============================================

CREATE	PROC [dbo].[tx_GetShowDatesInRange_Count]
	
	@applicationId		uniqueidentifier,
	@selectedVenueId	int,
	@startDate			varchar(50),
	@endDate			varchar(50)

AS

SET DEADLOCK_PRIORITY LOW

SET NOCOUNT ON

BEGIN
	
	SELECT	COUNT(DISTINCT(sd.[Id]))

	FROM	[ShowDate] sd, [Show] s, [Venue] v
	WHERE	s.[ApplicationId] = @applicationId AND 
			s.[Id] = sd.[tShowId] AND 
			sd.[dtDateOfShow] BETWEEN @startDate AND @endDate AND
			s.[tVenueId] = v.[Id] AND

			--ALLOW VENUE SELECTIONS
			CASE @selectedVenueId 
				WHEN 0 THEN 1 ELSE CASE WHEN @selectedVenueId > 0 AND v.[Id] = @selectedVenueId THEN 1 ELSE 0 END
			END = 1

END
GO
