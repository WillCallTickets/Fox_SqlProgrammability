USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetProfileValue]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: ?
-- Title:		fn_GetProfileValue
-- Description:	the asp profile system has 2 cols - 1 holds keynames, the other values
--	given the name of a property, return its value from aspnet_profile
-- =============================================

CREATE	FUNCTION [dbo].[fn_GetProfileValue]( 

	@UserId			UNIQUEIDENTIFIER, 
	@PropertyName	VARCHAR(256) 
	
)
RETURNS VARCHAR(300)
AS

BEGIN

	DECLARE	@value		VARCHAR(300)
	DECLARE	@apNames	VARCHAR(8000), @apProps VARCHAR(8000)
	DECLARE	@NameIdx	INT	--first ocurrence of the name

	--get PropertyNames
	SELECT	@apNames = ap.[PropertyNames] FROM Aspnet_Profile ap WHERE ap.[UserId] = @UserId

	SET	@NameIdx = CHARINDEX( @PropertyName+':', @apNames )

	--if we have a valid property name
	--if we are at first position(1) (first property) or the char at the previous index is our separator we are good
	IF(@NameIdx = 1 OR (SUBSTRING(@apNames, @nameIdx-1, 1 ) = ':')) 
	BEGIN

		--set indexes - all of these indexes represent the end of the item in question
		DECLARE	@iPropName INT, @iPropType INT, @iStart INT, @iEnd INT
		SET		@iPropName	= CHARINDEX(':',@apNames, @NameIdx)
		SET		@iPropType	= CHARINDEX(':',@apNames, @iPropName+1)
		SET		@iStart		= CHARINDEX(':',@apNames, @iPropType+1)
		SET		@iEnd		= CHARINDEX(':',@apNames, @iStart+1)

		SELECT	@value = 
				SUBSTRING( ap.[PropertyValuesString], 
				CAST( SUBSTRING( @apNames, @iPropType + 1,	@iStart - @iPropType -1 )+1 AS INT), 
				CAST( SUBSTRING( @apNames, @iStart + 1,	@iEnd - @iStart -1 )		AS INT ) )
		FROM	AspNet_Profile ap
		WHERE	ap.[UserId] = @UserId
		
	END 

	RETURN (@value)

END
GO
