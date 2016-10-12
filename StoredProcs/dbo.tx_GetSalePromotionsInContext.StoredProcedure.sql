USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetSalePromotionsInContext]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 08/03/24
-- Description:	Gets sale promotions that are within context (all, future -or- current) 
-- Returns Wcss.SalePromotion
-- exec dbo.[tx_GetSalePromotionsInContext] 1, 50, 'fox', 'all', null, null, ''
-- exec dbo.[tx_GetSalePromotionsInContext] 1, 50, 'bt', 'all', null, null, 'newIdx-10003'
-- select * from salepromotion where id = 10003
-- =============================================

CREATE	PROC [dbo].[tx_GetSalePromotionsInContext]

	@StartRowIndex  int,
	@PageSize       int,
	@Principal		varchar(10),	-- either all or single venue
	@Status			varchar(25),
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
	
	-- Create a temp table TO store the select results
    CREATE TABLE #PageIndexForCollection
    (
        IndexId int IDENTITY (1, 1) NOT NULL,
        RowNum int,
		EntityId int
    )

	--orderable needs to sort by principal
	IF (@Status = 'orderable') BEGIN
	
		INSERT INTO #PageIndexForCollection (EntityId, RowNum)
		SELECT EntityId, RowNum FROM
		(			
			SELECT	Distinct(ent.[Id]) as EntityId, ROW_NUMBER() OVER (ORDER BY dbo.fn_GetPrincipalOrder(ent.[vcJsonOrdinal], @Principal) DESC) AS RowNum
			FROM	SalePromotion ent
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
		) Entities
		WHERE	Entities.RowNum BETWEEN (@StartRowIndex) AND (@StartRowIndex + @PageSize - 1)
		ORDER BY [RowNum] DESC 
		
		SELECT	ent.*
		FROM	[#PageIndexForCollection] p, 
				[SalePromotion] ent 					
		WHERE	ent.[Id] = p.[EntityId]

	
	END ELSE BEGIN
	
		DECLARE @SearchIdx int
		SET @SearchIdx = 0		
		IF(@SearchTerms IS NOT NULL AND CHARINDEX('newIdx-', @SearchTerms) >= 1) BEGIN			
			SELECT @SearchIdx = CAST (SUBSTRING(@SearchTerms, CHARINDEX('newIdx-', @SearchTerms) + 7, LEN(@SearchTerms)) AS int)			
		END		
			
		INSERT INTO #PageIndexForCollection (EntityId)
		SELECT EntityId FROM
		(
			SELECT	Distinct(ent.[Id]) as EntityId, ROW_NUMBER() OVER (ORDER BY ent.[Id] DESC) AS RowNum
			FROM	SalePromotion ent
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
						WHEN ent.[Name] LIKE (@SearchTerms + '%') OR ent.[Name] LIKE ('% ' + @SearchTerms + '%') THEN 1
						ELSE 0
					END = 1
					)
			)			
					
		) Entities
		WHERE	Entities.RowNum BETWEEN (@StartRowIndex) AND (@StartRowIndex + @PageSize - 1)
		ORDER BY [EntityId] DESC 
		
		SELECT	p.[IndexId], p.[EntityId], ent.*
		FROM	[#PageIndexForCollection] p, 
				[SalePromotion] ent 					
		WHERE	ent.[Id] = p.[EntityId]
		ORDER BY ent.[Id] DESC
	END
END
GO
