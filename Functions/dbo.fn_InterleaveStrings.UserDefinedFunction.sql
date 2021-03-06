USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_InterleaveStrings]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: ?
-- Title:		[fn_InterleaveStrings]
-- Description:	this function is somewhat contrived, but basically it allows
--	us to interleave a string1 and a string2 together
--	bilbo, baggins => bbialgbgoins (or some such pattern)
--	it depends on the returnLength param 
--	This function is used to create semi-random strings
--	TODO find out where this is called from
-- =============================================
 
-- TODO refator for efficiency - possibility...
-- STUFF stuffs a second string into a first string - see msdn
CREATE FUNCTION [dbo].[fn_InterleaveStrings] (

	@first			VARCHAR(250),
	@second			VARCHAR(250),
	@returnLength	INT

) 
RETURNS VARCHAR(500) 
AS
 
BEGIN
 
    DECLARE @bufferLength	INT
    DECLARE @interleave		VARCHAR(100)
 
    SET @bufferLength = @returnLength
    SET @interleave = ''
 
    DECLARE @i INT
    SET @i = 0
    DECLARE @j INT
    SET @j = 0
    
    --cleanup strings - remove dashes
    -- TODO allow a flag to consider dashes
    SET @first  = REPLACE(@first, '-', '')
    SET @second = REPLACE(@second, '-', '')
 
    WHILE (@i < @bufferLength) BEGIN
 
        IF(@j < LEN(@first)) BEGIN
            SET @interleave += SUBSTRING( @first, @j+1, 1)
            SET @i += 1;
        END
               
        IF(@j >= @bufferLength) BEGIN
            BREAK
        END
        
        IF(@j < LEN(@second)) BEGIN
            SET @interleave += SUBSTRING( @second, @j+1, 1)
            SET @i += 1;
        END
        
        SET @j += 1    
 
    END 
 
    RETURN @interleave
 
END
GO
