USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_GetShowByUrl]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 04/24/2013
-- Description:	Gets a show row based on a url that would match one of its children. 
/*
	exec [tx_GetShowByUrl] 'AC36EB0B-152E-4B69-8B39-BB4B6C9B01E6', '2013-05-04-0830PM-Rob-Drabkin', 1	
	select * from show order by name desc
		
	exec [tx_GetShowByUrl] 'AC36EB0B-152E-4B69-8B39-BB4B6C9B01E6', '2013-05-04-0830PM-Rob-Drabkin', 0
	exec [tx_GetShowByUrl] 'AC36EB0B-152E-4B69-8B39-BB4B6C9B01E6', '2013-11-02-0830PM-West-Water-Outlaws', 0

	select CHARINDEX ( REPLACE( 'West-Water-Outlaws', '-', ' ' ), '2013/11/02 08:30 PM - THE FOX THEATRE - WEST WATER OUTLAWS')
	select * from showdate where tshowid = 16469
	select * from show where id = 16469
	
	--PATINDEX ( '%pattern%' , expression )
	--CHARINDEX ( expressionToFind ,expressionToSearch [ , start_location ] )
	--SUBSTRING ( expression ,start , length )
	--REPLACE ( string_expression , string_pattern , string_replacement )
	
*/
-- =============================================

CREATE	PROC [dbo].[tx_GetShowByUrl]

	@applicationId			uniqueidentifier,
	@url					varchar(256),
	@checkActiveDisplayable	bit 

AS

SET NOCOUNT ON

BEGIN

	--Parse input	
	SELECT	[ROWID] as [RowId], [VALUE] as [Value]
	INTO	#spliturl
	FROM	dbo.SPLIT( '-', @url ) 
	
	--return if we do not comply
	IF( @@ROWCOUNT < 4 ) BEGIN 
		SELECT NULL
		RETURN
	END
	
	--next round of comliance - get the date
	DECLARE @matchDate datetime
	DECLARE @name varchar(256)
	DECLARE	@dtBuilder varchar(4000)	
	DECLARE @time char(12)
	
	SELECT	@dtBuilder = COALESCE(@dtBuilder, '') + [Value] + '-'
	FROM	#spliturl
	WHERE	[RowId] < 4
	
	SELECT	@time = [Value] FROM #spliturl WHERE [RowId] = 4

	BEGIN TRY
		SELECT @matchDate = CAST( SUBSTRING( @dtBuilder, 0, LEN(@dtBuilder) ) + ' ' + 
			SUBSTRING( @time, 1, 2 ) + ':' + 
			SUBSTRING( @time, 3, LEN(@time) + 1 )  as DATETIME)
			
		SELECT	@name = COALESCE(@name, '') + [Value] + '-'
		FROM	#spliturl
		WHERE	[RowId] > 4
		
		--trim trailing dash
		SELECT	@name = SUBSTRING( @name, 1, LEN(@name) - 1 )
	
	END TRY
	BEGIN CATCH
		SELECT NULL
		RETURN
	END CATCH
	

	--now that we have a valid date
	--match the show date where the date matches and the name portion
	--is contained within the showdate's parent show's name
	SELECT	s.* 
	FROM	ShowDate sd, Show s
	WHERE	s.[ApplicationId] = @applicationId AND 
			s.[Id] = sd.[tShowId] AND 
			sd.[dtDateOfShow] = @matchDate AND 
			CHARINDEX ( REPLACE( @name, '-', ' ' ), 
				[dbo].[fn_RemoveMultipleSpaces](
					[dbo].[fn_stripcharacters](s.[Name], '^a-z0-9 ')
					) 
					) > 0 AND 
			CASE @checkActiveDisplayable 
				WHEN 1 THEN 
					CASE WHEN 
						(s.[bActive] IS NOT NULL AND s.[bActive] = 1) AND 
						(sd.[bActive] IS NOT NULL AND sd.[bActive] = 1) AND 
						(s.[dtAnnounceDate] IS NULL OR 
						(s.[dtAnnounceDate] IS NOT NULL AND s.[dtAnnounceDate] < (getDate())))
					THEN 1 
					ELSE 0 END
				ELSE 1
			END = 1	
END
GO
