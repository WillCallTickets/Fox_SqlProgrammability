USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StripCharacters]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      
-- CreateDate:	?
-- Title:		[fn_StripCharacters]
-- Description: removes chars from a string based on a regex pattern
-- USAGE: http://stackoverflow.com/questions/1007697/how-to-strip-all-non-alphabetic-characters-from-string-in-sql-server
--	select [dbo].[fn_stripcharacters]('DARKSTAR ORCHESTRA & DARK STAR ORCHESTRA', '^a-z0-9 ')
     /*    
    Alphabetic only:
	SELECT dbo.fn_StripCharacters('a1!s2@d3#f4$', '^a-z')
	Numeric only:
	SELECT dbo.fn_StripCharacters('a1!s2@d3#f4$', '^0-9')
	Alphanumeric only:
	SELECT dbo.fn_StripCharacters('a1!s2@d3#f4$', '^a-z0-9')
	Non-alphanumeric:
	SELECT dbo.fn_StripCharacters('a1!s2@d3#f4$', 'a-z0-9')    
    */
-- =============================================

CREATE FUNCTION [dbo].[fn_StripCharacters](

    @String NVARCHAR(MAX), 
    @MatchExpression VARCHAR(255)
    
)
RETURNS NVARCHAR(MAX)
AS

BEGIN

	--Defaults to non-alphanumeric
	IF @MatchExpression IS NOT NULL BEGIN
		SET @MatchExpression =  '%['+@MatchExpression+']%'
	END
    ELSE BEGIN
		SET @MatchExpression =  '^a-z0-9 '--includes a space at end!
		SET @MatchExpression =  '%['+@MatchExpression+']%'
    END

	-- STUFF stuffs a second string into a first string - see msdn
    WHILE PATINDEX(@MatchExpression, @String) > 0
        SET @String = STUFF(@String, PATINDEX(@MatchExpression, @String), 1, '')

    RETURN @String

END
GO
