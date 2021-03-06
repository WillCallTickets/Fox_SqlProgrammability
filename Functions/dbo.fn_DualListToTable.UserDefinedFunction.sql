USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DualListToTable]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      CatInHat
-- CreateDate:	?
-- Title:		fn_DualListToTable
-- Description: Seeds a two-column table from 2 lists
--	eg: one may contain keys and the other values
-- =============================================

CREATE	FUNCTION [dbo].[fn_DualListToTable]( 

	@first	VARCHAR(8000), 
	@second	VARCHAR(8000)

)
RETURNS @lstTable TABLE ( 
	
	Id			INT NULL, 
	ParamName	VARCHAR(256) NULL, 
	ParamValue	VARCHAR(256) NULL
	
)
AS

BEGIN

	DECLARE	@List 	VARCHAR(8000),
			@Two 	VARCHAR(8000),
			@count	INT

	SET @List = @first
	SET @Two = @second
	SET @count = 1

	DECLARE	@iNextToken INT
	SET @iNextToken = CHARINDEX('~', @first)

	WHILE @iNextToken > 0 BEGIN
	
		INSERT	@lstTable ([Id], ParamName, ParamValue)
		VALUES	(@count, left( @List, @iNextToken - 1), left( @Two, @iNextToken - 1))
	
		SET @List	= SUBSTRING( @List, @iNextToken + 1, LEN(@List))
		SET @Two	= SUBSTRING( @Two, @iNextToken + 1, LEN(@Two))

		SET @iNextToken = CHARINDEX( '~', @List)
		SET @count = @count + 1
		
	END

	IF @List IS NOT NULL AND @List <> '' BEGIN
	
		INSERT	@lstTable ([Id], ParamName, ParamValue)
		VALUES	(@count, @List, @Two)
		
	END

	RETURN
	
END
GO
