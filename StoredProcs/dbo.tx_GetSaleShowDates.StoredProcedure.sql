USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetSaleShowDates]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 08/10/24
-- Description:	Gets all future shows. Client decides to display based on announceDate. 
/*
Time must be in format of yyyy/MM/dd
exec [tx_GetSaleShowDates] '83C1C3F6-C539-41D7-815D-143FBD40E41F', '2008/12/15'--sts9
exec [tx_GetSaleShows] 'AC36EB0B-152E-4B69-8B39-BB4B6C9B01E6', '2008/10/23', '2008/12/12'--fox
*/
-- =============================================

CREATE	PROC [dbo].[tx_GetSaleShowDates]

	@applicationId	uniqueidentifier,
	@nowName		varchar(50)

AS

SET NOCOUNT ON

BEGIN

	SELECT TOP 100 PERCENT sd.* 
	FROM	ShowDate sd, Show s
	WHERE	s.[ApplicationId] = @applicationId AND 
			s.[Id] = sd.[tShowId] AND
			sd.[dtDateOfShow] >= @nowName
	ORDER BY sd.[dtDateOfShow]
	
END
GO
