USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetKiosksInContextCount]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 08/03/24
-- Description:	Gets the count of rotational ads 
-- Returns int
-- exec dbo.[tx_GetKiosksCount] 'all'
-- exec dbo.[tx_GetKiosksCount] 'fox'
-- exec dbo.[tx_GetKiosksCount] 'bt'
-- =============================================

CREATE	PROC [dbo].[tx_GetKiosksInContextCount]

	@Principal		varchar(10),	-- either all or single venue
	@Status 		varchar(25),
	@StartDate		datetime,		--will never be null - think of the combo of the two dates - "running in this date range"
	@EndDate		datetime,
	@SearchTerms	varchar(256)

AS

SET NOCOUNT ON

BEGIN

	DECLARE @now datetime
	SET	@now = (getDate())
	
	SET @StartDate = ISNULL(@StartDate, '1900-01-01 12AM')
	SET @EndDate = ISNULL(@EndDate, '2500-01-01 12AM')
	
	IF (@Status = 'orderable') BEGIN
	
		SELECT	COUNT(Distinct(ent.[Id]))
		FROM	Kiosk ent
		WHERE	CASE 
					WHEN CHARINDEX(@Principal, ent.[vcPrincipal]) >= 1 THEN 1
					ELSE 0
				END = 1 AND 
				ent.[bActive] = 1 AND 
				--disregard the startdate, get all possible future starters
				(
					ent.[dtEndDate] IS NULL OR
					ent.[dtEndDate] IS NOT NULL AND ent.[dtEndDate] >= @now
				)
	
	END ELSE BEGIN
		
		DECLARE @SearchIdx int
		SET @SearchIdx = 0		
		IF(@SearchTerms IS NOT NULL AND CHARINDEX('newIdx-', @SearchTerms) >= 1) BEGIN		
			SELECT @SearchIdx = CAST (SUBSTRING(@SearchTerms, CHARINDEX('newIdx-', @SearchTerms) + 7, LEN(@SearchTerms)) AS int)			
		END	
		
		SELECT	COUNT(Distinct(ent.[Id]))
		FROM	[Kiosk] ent
		WHERE	
		(
			(@SearchIdx > 0 AND @SearchIdx = ent.[Id])				
			OR(
			@SearchIdx = 0 AND
			CASE 
				WHEN @Principal = 'all' THEN 1
				WHEN CHARINDEX(@Principal, ent.[vcPrincipal]) >= 1 THEN 1
				ELSE 0
			END = 1
			AND CASE
				WHEN @Status = 'all' THEN 1
				WHEN @Status = 'active' AND ent.[bActive] = 1 THEN 1
				WHEN @Status = 'notactive' AND ent.[bActive] = 0 THEN 1
				ELSE 0	
			END = 1
			AND CASE 
				--if the dates is not a factor return 1 for this col
				WHEN @StartDate <= '1900-01-01 12AM' AND @EndDate >= '2500-01-01 12AM' THEN 1
				WHEN ent.[dtStartDate] IS NULL AND ent.[dtEndDate] IS NULL THEN 1 --null is always on!
				WHEN ent.[dtStartDate] IS NULL AND ent.[dtEndDate] IS NOT NULL AND ent.[dtEndDate] >= @StartDate THEN 1
				WHEN ent.[dtEndDate] IS NULL AND ent.[dtStartDate] IS NOT NULL AND 
					ent.[dtStartDate] <= @EndDate THEN 1 -- this says that the item will start in that period - it will run at some time
				WHEN ent.[dtStartDate] IS NOT NULL AND ent.[dtStartDate] <= @EndDate AND 
					ent.[dtEndDate] IS NOT NULL AND ent.[dtEndDate] >= @StartDate THEN 1
				ELSE 0
			END = 1
			--	LIKE SEARCHES
			--	searchterms match at beginning of word boundaries
			AND CASE
				WHEN @SearchTerms IS NULL OR LEN(LTRIM(RTRIM(@SearchTerms))) = 0 THEN 1
				WHEN ent.[Name] LIKE (@SearchTerms + '%') OR ent.[Name] LIKE ('% ' + @SearchTerms + '%') OR 
					ent.[EventTitle] LIKE (@SearchTerms + '%') OR ent.[EventTitle] LIKE ('% ' + @SearchTerms + '%') OR 
					ent.[EventHeads] LIKE (@SearchTerms + '%') OR ent.[EventHeads] LIKE ('% ' + @SearchTerms + '%') OR 
					ent.[EventOpeners] LIKE (@SearchTerms + '%') OR ent.[EventOpeners] LIKE ('% ' + @SearchTerms + '%') OR 
					ent.[EventVenue] LIKE (@SearchTerms + '%') OR ent.[EventVenue] LIKE ('% ' + @SearchTerms + '%') OR 
					ent.[EventDescription] LIKE (@SearchTerms + '%') OR ent.[EventDescription] LIKE ('% ' + @SearchTerms + '%') 
				THEN 1
				ELSE 0
			END = 1
			)
		)
	END
END
GO
