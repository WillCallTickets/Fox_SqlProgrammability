USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[GetNumbers]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		?
-- Create date: <2008/02/12>
-- Description:	Returns a table containing the numbers from start to end
-- http://sqlserver2000.databases.aspfaq.com/why-should-i-consider-using-an-auxiliary-numbers-table.html
-- great for generating ranges
-- =============================================

CREATE FUNCTION [dbo].[GetNumbers](	

	@Start	BIGINT,
    @End	BIGINT
    
)
RETURNS @ret TABLE(
	
	Number BIGINT

)
AS

BEGIN

	WITH
    L0 AS (SELECT 1 AS C UNION ALL SELECT 1), --2 rows
	L1 AS (SELECT 1 AS C FROM L0 AS A, L0 AS B),--4 rows
	L2 AS (SELECT 1 AS C FROM L1 AS A, L1 AS B),--16 rows
	L3 AS (SELECT 1 AS C FROM L2 AS A, L2 AS B),--256 rows
	L4 AS (SELECT 1 AS C FROM L3 AS A, L3 AS B),--65536 rows
	L5 AS (SELECT 1 AS C FROM L4 AS A, L4 AS B),--4294967296 rows
	num AS (SELECT ROW_NUMBER() OVER(ORDER BY C) AS N FROM L5)
	
	INSERT	INTO @ret(Number) 
	SELECT	N 
	FROM	NUM 
	WHERE	N BETWEEN @Start AND @End

	RETURN

END
GO
