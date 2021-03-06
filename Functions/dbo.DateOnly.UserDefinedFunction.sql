USE [Fox_2014]
GO
/****** Object:  UserDefinedFunction [dbo].[DateOnly]    Script Date: 10/02/2016 18:20:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: ?
-- Title:		DateOnly
-- Description:	Accepts a date and returns only the date portion as a sql date object.
--  2008-09-22 14:24:56.727 => 2008-09-22 00:00:00.000
-- TODO rename to follow function naming scheme fn_DateOnly
-- =============================================

CREATE FUNCTION [dbo].[DateOnly] ( 
	
	@DateTime DATETIME 
	
)
RETURNS DATETIME
AS

BEGIN
	
	-- TODO - detect version?
	-- For Sql 2008 and higher - SQLServer 2008 now has a 'date' data type which contains only a date with no time component. 
	-- SELECT CONVERT(date, getdate())
	-- See http://stackoverflow.com/questions/113045/how-to-return-the-date-part-only-from-a-sql-server-datetime-datatype
	
    RETURN DATEADD(dd, 0, DATEDIFF(dd, 0, @DateTime))

END
GO
