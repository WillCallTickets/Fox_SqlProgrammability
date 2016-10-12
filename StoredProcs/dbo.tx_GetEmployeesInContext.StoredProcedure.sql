USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetEmployeesInContext]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 14/09/03
-- Description:	Gets employees that are within context (all, future -or- current) 
-- Returns Wcss.Employee
-- exec dbo.[tx_GetEmployeesInContext] 1, 50, 'fox', 'all', null, null, ''
-- exec dbo.[tx_GetEmployeesInContext] 1, 50, 'z2', 'running', null, null, ''
-- =============================================

CREATE	PROC [dbo].[tx_GetEmployeesInContext]

	@StartRowIndex  int,--this is based on what we get from the grid view control
	@PageSize       int,
	@Principal		varchar(10), -- either all or single venue
	@Status			varchar(25),
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
			FROM	Employee ent
			WHERE	CASE 
						WHEN CHARINDEX(@Principal, ent.[vcPrincipal]) >= 1 THEN 1
						ELSE 0
					END = 1 AND 
					ent.[bListInDirectory] = 1
					
		) Entities
		WHERE	Entities.RowNum BETWEEN (@StartRowIndex) AND (@StartRowIndex + @PageSize - 1)
		ORDER BY [RowNum] DESC 
		
		SELECT	ent.*
		FROM	[#PageIndexForCollection] p, 
				[Employee] ent 					
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
			FROM	Employee ent
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
						WHEN @Status = 'active' AND ent.[bListInDirectory] = 1 THEN 1
						WHEN @Status = 'notactive' AND ent.[bListInDirectory] = 0 THEN 1
						ELSE 0	
					END = 1
					--limit search to matching start of name
					AND CASE
						WHEN @SearchTerms IS NULL OR LEN(LTRIM(RTRIM(@SearchTerms))) = 0 THEN 1
						WHEN ent.[FirstName] LIKE (@SearchTerms + '%') THEN 1
						WHEN ent.[LastName] LIKE (@SearchTerms + '%') THEN 1
						ELSE 0
					END = 1
					)
		) Entities
		WHERE	Entities.RowNum BETWEEN (@StartRowIndex) AND (@StartRowIndex + @PageSize - 1)
		ORDER BY [EntityId] DESC 
		
		SELECT	p.[IndexId], p.[EntityId], ent.*
		FROM	[#PageIndexForCollection] p, 
				[Employee] ent 					
		WHERE	ent.[Id] = p.[EntityId]
		ORDER BY ent.[Id] DESC
	END
END
GO
