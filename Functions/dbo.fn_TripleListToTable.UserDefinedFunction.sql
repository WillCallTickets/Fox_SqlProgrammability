USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_TripleListToTable]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      CatInHat
-- CreateDate:	?
-- Title:		fn_TripleListToTable
-- Description: Seeds a three-column table from 3 lists
-- TODO refactor for efficiency - can we combine all ListToTable funcs?
-- =============================================

CREATE	FUNCTION [dbo].[fn_TripleListToTable]( 

	@first	VARCHAR(3000), 
	@second VARCHAR(3000), 
	@third	VARCHAR(3000)
	
)
RETURNS @lstTable TABLE ( 
	
	[Id]	INT NULL, 
	[val1]	VARCHAR(256), 
	[val2]	VARCHAR(256), 
	[val3]	VARCHAR(256) NULL

)
AS

BEGIN

	DECLARE	@one 	VARCHAR(3000),
			@two 	VARCHAR(3000),
			@three 	VARCHAR(3000),
			@count	INT

	SET @one	= @first
	SET @two	= @second
	SET @three	= @third
	SET @count	= 1

	DECLARE	@iNextToken INT
	SET		@iNextToken = CHARINDEX( '~', @one)


	WHILE @iNextToken > 0 
	BEGIN
	
		INSERT	@lstTable ([Id], [val1], [val2], [val3])
		VALUES	(@count, 
			LEFT( @one, @iNextToken - 1), 
			LEFT( @two, @iNextToken - 1), 
			LEFT( @three, @iNextToken - 1)
		)
	
		SET @one	= SUBSTRING( @one, @iNextToken + 1, LEN(@one))
		SET @two	= SUBSTRING( @two, @iNextToken + 1, LEN(@two))
		SET @three	= SUBSTRING( @three, @iNextToken + 1, LEN(@three))

		SET @iNextToken = CHARINDEX( '~', @one)
		SET @count = @count + 1
		
	END

	--do last value
	IF @one IS NOT NULL AND @one <> '' 
	BEGIN
	
		INSERT	@lstTable ([Id], [val1], [val2], [val3])
		VALUES	(@count, @one, @two, @three)
		
	END

	RETURN
END
GO
