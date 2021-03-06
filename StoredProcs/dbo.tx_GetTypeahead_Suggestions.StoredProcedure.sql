USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetTypeahead_Suggestions]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 2014/09/22
-- Description:	Returns matching suggestions based on criteria 
-- BE SURE TO REGISTER TABLE QUERIES WITH CALL IN TYPEAHEADSERVICE.CS
-- ACT, EMPLOYEE, FAQITEM, GENRE, KIOSK, POST, PROMOTER, SALEPROMOTION, SHOW, VENUE
/*
exec [tx_Get_Typeahead_Suggestions] 'all', 'show', 'fre', 1, 10
*/
-- =============================================

CREATE	PROC [dbo].[tx_GetTypeahead_Suggestions]

	@Principal		varchar(50),
	@Context		varchar(100),
	@Query			varchar(256),
	@ActiveRequired	bit,
	@Limit			int 

AS

SET NOCOUNT ON

BEGIN
	
	--this will match the start of the column
	SET		@Query = (@Query + '%')
	
	--this will match the start of any word boundaries in a column
	DECLARE @wbQuery varchar(260)
	SET		@wbQuery = ('% ' + @Query)
		
	--*****************************************
	-- ACT - like on word boundary
	--*****************************************	
	IF (@Context = 'Act') BEGIN
		IF(@Principal = 'all') BEGIN
			SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
			FROM	[Act] e
			WHERE	(e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery OR 
					e.[NameRoot] LIKE @Query OR e.[NameRoot] LIKE @wbQuery) --ignore displayname
					AND		CASE    
							WHEN @ActiveRequired = 0 THEN 1 
							WHEN @ActiveRequired = 1 AND e.[bListInDirectory] = 1 THEN 1
							ELSE 0	
					END = 1		
			ORDER BY e.[Name] ASC
		END ELSE BEGIN
			SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
			FROM	[Act] e 
					JOIN [JShowAct] js ON js.[TActId] = e.[Id] 
					JOIN [ShowDate] sd ON js.[TShowDateId] = sd.[Id]
					JOIN [Show] s ON sd.[TShowId] = s.[Id] AND (CHARINDEX(@Principal, s.[vcPrincipal]) >= 1)
			WHERE	(e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery OR 
					e.[NameRoot] LIKE @Query OR e.[NameRoot] LIKE @wbQuery) --ignore displayname
					AND		CASE    
							WHEN @ActiveRequired = 0 THEN 1 
							WHEN @ActiveRequired = 1 AND e.[bListInDirectory] = 1 THEN 1
							ELSE 0	
					END = 1		
			ORDER BY e.[Name] ASC
		END 
	END
	--*****************************************
	-- END ACT
	--*****************************************	
	
	--*****************************************
	-- EMPLOYEE - like on start of first, last
	--*****************************************
	IF (@Context = 'Employee') BEGIN
		SELECT	DISTINCT TOP (@limit) e.[FirstName] + ' ' + e.[LastName] AS [Suggestion], e.[Id]
		FROM	[Employee] e
		WHERE	(e.[FirstName] LIKE @Query OR e.[LastName] LIKE @Query) 
				AND		CASE    
						WHEN @ActiveRequired = 0 THEN 1 
						WHEN @ActiveRequired = 1 AND e.[bListInDirectory] = 1 THEN 1
						ELSE 0	
				END = 1	
				AND		CASE    
						WHEN @Principal = 'all' THEN 1 
						WHEN @Principal <> 'all' AND (CHARINDEX(@Principal, e.[vcPrincipal]) >= 1) THEN 1
						ELSE 0
				END = 1			
		ORDER BY e.[FirstName] + ' ' + e.[LastName] ASC
	END
	--*****************************************
	-- END EMPLOYEE
	--*****************************************	
	
	--*****************************************
	-- FAQITEM - like on word boundary
	--*****************************************
	IF (@Context = 'FaqItem') BEGIN
		SELECT	DISTINCT TOP (@limit) e.[Question] AS [Suggestion], e.[Id]
		FROM	[FaqItem] e
		WHERE	(e.[Question] LIKE @Query OR e.[Question] LIKE @wbQuery)
				AND		CASE    
						WHEN @ActiveRequired = 0 THEN 1 
						WHEN @ActiveRequired = 1 AND e.[bActive] = 1 THEN 1
						ELSE 0	
				END = 1	
				AND		CASE    
						WHEN @Principal = 'all' THEN 1 
						WHEN @Principal <> 'all' AND (CHARINDEX(@Principal, e.[vcPrincipal]) >= 1) THEN 1
						ELSE 0
				END = 1	
		ORDER BY e.[Question] ASC
	END	
	--*****************************************
	-- END FAQ
	--*****************************************
	
	--*****************************************
	-- GENRE - like on word boundary
	--*****************************************
	IF (@Context = 'Genre') BEGIN
		SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
		FROM	[Genre] e
		WHERE	(e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery)
		ORDER BY e.[Name] ASC	
	END	
	--*****************************************
	-- END GENRE
	--*****************************************
	
	--*****************************************
	-- KIOSK - like on word boundary
	--*****************************************
	IF (@Context = 'Kiosk') BEGIN
		SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
		FROM	[Kiosk] e
		WHERE	(
				e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery OR 
				e.[EventTitle] LIKE @Query OR e.[EventTitle] LIKE @wbQuery OR 
				e.[EventHeads] LIKE @Query OR e.[EventHeads] LIKE @wbQuery OR 
				e.[EventOpeners] LIKE @Query OR e.[EventOpeners] LIKE @wbQuery OR 
				e.[EventVenue] LIKE @Query OR e.[EventVenue] LIKE @wbQuery OR 
				e.[EventDescription] LIKE @Query OR e.[EventDescription] LIKE @wbQuery 
				)
				AND		CASE    
						WHEN @ActiveRequired = 0 THEN 1 
						WHEN @ActiveRequired = 1 AND e.[bActive] = 1 THEN 1
						ELSE 0	
				END = 1	
				AND		CASE    
						WHEN @Principal = 'all' THEN 1 
						WHEN @Principal <> 'all' AND (CHARINDEX(@Principal, e.[vcPrincipal]) >= 1) THEN 1
						ELSE 0
				END = 1
		ORDER BY e.[Name] ASC	
	END	
	--*****************************************
	-- END KIOSK
	--*****************************************
	
	--*****************************************
	-- POST - like on word boundary
	--*****************************************
	IF (@Context = 'Post') BEGIN
		SET		@Query = ('%' + @Query + '%')
		SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
		FROM	[Post] e
		WHERE	(e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery)
				AND		CASE    
						WHEN @ActiveRequired = 0 THEN 1 
						WHEN @ActiveRequired = 1 AND e.[bActive] = 1 THEN 1
						ELSE 0	
				END = 1		
				AND		CASE    
						WHEN @Principal = 'all' THEN 1 
						WHEN @Principal <> 'all' AND (CHARINDEX(@Principal, e.[vcPrincipal]) >= 1) THEN 1
						ELSE 0
				END = 1		
		ORDER BY e.[Name] ASC
	END	
	--*****************************************
	-- END POST
	--*****************************************
	
	--*****************************************
	-- PROMOTER - like on word boundary
	--*****************************************
	IF (@Context = 'Promoter') BEGIN
		IF(@Principal = 'all') BEGIN
			SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
			FROM	[Promoter] e
			WHERE	(e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery OR 
					e.[NameRoot] LIKE @Query OR e.[NameRoot] LIKE @wbQuery) --ignore displayname
					AND		
					CASE    
						WHEN @ActiveRequired = 0 THEN 1 
						WHEN @ActiveRequired = 1 AND e.[bListInDirectory] = 1 THEN 1
						ELSE 0	
					END = 1		
			ORDER BY e.[Name] ASC
		END ELSE BEGIN
			SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
			FROM	[Promoter] e 
					JOIN [JShowPromoter] js ON js.[TPromoterId] = e.[Id] 
					JOIN [Show] s ON js.[TShowId] = s.[Id] AND (CHARINDEX(@Principal, s.[vcPrincipal]) >= 1)
			WHERE	(e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery OR 
					e.[NameRoot] LIKE @Query OR e.[NameRoot] LIKE @wbQuery) --ignore displayname
					AND		
					CASE    
						WHEN @ActiveRequired = 0 THEN 1 
						WHEN @ActiveRequired = 1 AND e.[bListInDirectory] = 1 THEN 1
						ELSE 0	
					END = 1		
			ORDER BY e.[Name] ASC
		END 
	END
	--*****************************************
	-- END PROMOTER
	--*****************************************	
	
	--*****************************************
	-- SALEPROMOTION aka banner - like on word boundary
	--*****************************************
	IF (@Context = 'SalePromotion') BEGIN
		SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
		FROM	[SalePromotion] e
		WHERE	(e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery)
				AND		
				CASE    
					WHEN @ActiveRequired = 0 THEN 1 
					WHEN @ActiveRequired = 1 AND e.[bActive] = 1 THEN 1
					ELSE 0	
				END = 1	
				AND		
				CASE    
					WHEN @Principal = 'all' THEN 1 
					WHEN @Principal <> 'all' AND (CHARINDEX(@Principal, e.[vcPrincipal]) >= 1) THEN 1
					ELSE 0
				END = 1		
		ORDER BY e.[Name] ASC
	END
	--*****************************************
	-- END SALEPROMOTION
	--*****************************************	
	
	--*****************************************
	-- SHOW
	-- order shows by most recent
	-- like on word boundary
	--*****************************************
	IF (@Context = 'Show') BEGIN
		SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
		FROM	[Show] e
		WHERE	(
				(LTRIM(SUBSTRING(e.[Name], CHARINDEX(' - ', e.[Name], CHARINDEX(' - ', e.[Name]) + 1) + 3, LEN(e.[Name]))) 
				LIKE @Query)
				OR 
				(LTRIM(SUBSTRING(e.[Name], CHARINDEX(' - ', e.[Name], CHARINDEX(' - ', e.[Name]) + 1) + 3, LEN(e.[Name]))) 
				LIKE @wbQuery)
				)
				AND		
				CASE    
					WHEN @ActiveRequired = 0 THEN 1 
					WHEN @ActiveRequired = 1 AND e.[bActive] = 1 THEN 1
					ELSE 0	
				END = 1	
				AND		
				CASE    
					WHEN @Principal = 'all' THEN 1 
					WHEN @Principal <> 'all' AND (CHARINDEX(@Principal, e.[vcPrincipal]) >= 1) THEN 1
					ELSE 0
				END = 1	
		ORDER BY e.[Name] DESC
	END
	--*****************************************
	-- END SHOW
	--*****************************************	
	
	--*****************************************
	-- VENUE - like on word boundary
	--*****************************************
	IF (@Context = 'Venue') BEGIN
		SELECT	DISTINCT TOP (@limit) e.[Name] AS [Suggestion], e.[Id]
		FROM	[Venue] e
		WHERE	(e.[Name] LIKE @Query OR e.[Name] LIKE @wbQuery OR 
				e.[NameRoot] LIKE @Query OR e.[NameRoot] LIKE @wbQuery) --ignore displayname
				AND		
				CASE    
					WHEN @Principal = 'all' THEN 1 
					WHEN @Principal <> 'all' AND (CHARINDEX(@Principal, e.[vcPrincipal]) >= 1) THEN 1
					ELSE 0
				END = 1	
		ORDER BY e.[Name] ASC
	END
	--*****************************************
	-- END VENUE
	--*****************************************
	
END
GO
