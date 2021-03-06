USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPrincipalOrder]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Robert Kurtz
-- Date:		09/01/2014
-- Description: Get the ordinal value in context of the chosen principal
-- Usage:       select dbo.fn_GetPrincipalOrder('SalePromotion', 10452, 'fox')
-- =============================================

CREATE	FUNCTION [dbo].[fn_GetPrincipalOrder](

	@OrdinalCol VARCHAR(256), 
	@Principal	VARCHAR(50) 

)
RETURNS INT

BEGIN

	DECLARE @returnVal INT
	SET	@returnVal = 10000
			
	--we are given json - remove outer brackets
	IF (@OrdinalCol IS NOT NULL AND LEN(LTRIM(RTRIM(@OrdinalCol))) > 0) 
	BEGIN
		
		DECLARE	@firstPass VARCHAR(256)
		
		SELECT	@firstPass = LTRIM(RTRIM(REPLACE(REPLACE([Value], '[',''),']','') ))
		FROM	[dbo].[SPLIT] (',{', @OrdinalCol)		
		WHERE	[Value] IS NOT NULL AND LEN(LTRIM(RTRIM([Value]))) > 0 
				AND CHARINDEX(':"' + @Principal + '"', [Value]) > 0
				
		SELECT	@returnVal = ISNULL(CAST(
				LTRIM(RTRIM(REPLACE(
				SUBSTRING ( REPLACE(REPLACE(@firstPass, '[',''),']','') , CHARINDEX ( '"Ordinal":' ,@firstPass) + LEN('"Ordinal":'), LEN(@firstPass)),
				'}', ''))) AS INT), 10000)
				
	END

	RETURN @returnVal

END
GO
