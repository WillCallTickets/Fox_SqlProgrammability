USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetEmployeesInContextCount]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 14/09/03
-- Description:	Gets employee count that are within context (banners or not) 
-- exec dbo.[tx_GetEmployeesInContextCount] 'all'
-- =============================================

CREATE	PROC [dbo].[tx_GetEmployeesInContextCount]

	@Principal		varchar(10), -- either all or single venue
	@Status 		varchar(25),
	@SearchTerms	varchar(256)
	
AS

SET NOCOUNT ON

BEGIN

	IF (@Status = 'orderable') BEGIN
	
		SELECT	COUNT(Distinct(ent.[Id]))
		FROM	Employee ent
		WHERE	CASE 
					WHEN CHARINDEX(@Principal, ent.[vcPrincipal]) >= 1 THEN 1
					ELSE 0
				END = 1 AND 
				ent.[bListInDirectory] = 1 
	
	END ELSE BEGIN
	
		DECLARE @SearchIdx int
		SET @SearchIdx = 0		
		IF(@SearchTerms IS NOT NULL AND CHARINDEX('newIdx-', @SearchTerms) >= 1) BEGIN		
			SELECT @SearchIdx = CAST (SUBSTRING(@SearchTerms, CHARINDEX('newIdx-', @SearchTerms) + 7, LEN(@SearchTerms)) AS int)			
		END	

		SELECT	COUNT(Distinct(ent.[Id]))
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
	END

END
GO
