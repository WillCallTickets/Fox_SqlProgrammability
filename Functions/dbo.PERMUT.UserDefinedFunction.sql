USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[PERMUT]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- TODO where is this called from?
-- =============================================
-- Author:      
-- CreateDate:	?
-- Title:		PERMUT
-- Description: Part of the Combination/Permutation/Factorial Calculator
--	TODO learn more about this
--	https://www.mathsisfun.com/combinatorics/combinations-permutations.html
--	http://stattrek.com/online-calculator/combinations-permutations.aspx
--	http://weblogs.sqlteam.com/davidm/archive/2003/11/11/475.aspx
-- =============================================

CREATE FUNCTION [dbo].[PERMUT](
	
	@n INT, 
	@r INT
	
) 
RETURNS FLOAT
AS

BEGIN

    DECLARE	@a FLOAT
    SET		@a = 1

    SELECT	@a = @a * Number
    FROM	master..spt_values
    WHERE	Number BETWEEN 1+(@n-@r) AND @n
    		AND Type='P'

    RETURN @a
    
END
GO
