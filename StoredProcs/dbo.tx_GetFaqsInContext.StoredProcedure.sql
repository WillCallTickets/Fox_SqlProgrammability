USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetFaqsInContext]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 14/09/03
-- Description:	Gets faqs that are within context (all, future -or- current) 
-- Returns Wcss.Faq
-- exec dbo.[tx_GetFaqsInContext] 1, 50, 'fox', 'all', '', ''
-- =============================================

CREATE	PROC [dbo].[tx_GetFaqsInContext]

	@StartRowIndex  int,			--this is based on what we get from the grid view control
	@PageSize       int,
	@Principal		varchar(10),	-- either all or single venue
	@Status			varchar(25),
	@Category		varchar(50),
	@SearchTerms	varchar(256)

AS

SET NOCOUNT ON

BEGIN
	
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
			FROM	FaqItem ent LEFT OUTER JOIN FaqCategorie cat ON [cat].[Id] = [ent].[tFaqCategorieId]
			WHERE	CASE 
						WHEN CHARINDEX(@Principal, ent.[vcPrincipal]) >= 1 THEN 1
						ELSE 0
					END = 1
					AND 
					CASE WHEN @Category = 'all' THEN 0 --deny all searches for ordering
						WHEN @Category = cat.[Name] THEN 1 ELSE 0 END = 1
					AND
					ent.[bActive] = 1 
					
		) Entities
		WHERE	Entities.RowNum BETWEEN (@StartRowIndex) AND (@StartRowIndex + @PageSize - 1)
		ORDER BY [RowNum] ASC 
		
		SELECT	ent.*
		FROM	[#PageIndexForCollection] p, 
				[FaqItem] ent 					
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
			FROM	FaqItem ent LEFT OUTER JOIN FaqCategorie cat ON [cat].[Id] = [ent].[tFaqCategorieId]
			WHERE	(@SearchIdx > 0 AND @SearchIdx = ent.[Id])
					OR (
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
						WHEN @Category = 'all' THEN 1
						WHEN @Category = cat.[Name] THEN 1 
						ELSE 0 
					END = 1
					AND CASE
						WHEN @SearchTerms IS NULL OR LEN(LTRIM(RTRIM(@SearchTerms))) = 0 THEN 1
						WHEN ent.[Question] LIKE (@SearchTerms + '%') OR ent.[Question] LIKE ('% ' + @SearchTerms + '%') THEN 1
						ELSE 0
					END = 1
					)
		) Entities
		WHERE	Entities.RowNum BETWEEN (@StartRowIndex) AND (@StartRowIndex + @PageSize - 1)
		ORDER BY [EntityId] ASC 
		
		SELECT	p.[IndexId], p.[EntityId], ent.*
		FROM	[#PageIndexForCollection] p, 
				[FaqItem] ent 					
		WHERE	ent.[Id] = p.[EntityId]
		ORDER BY ent.[Id] ASC
	END
END
GO
