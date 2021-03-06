USE [Fox_2014]
GO
/****** Object:  Table [dbo].[ShowGenre]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShowGenre](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[TShowId] [int] NOT NULL,
	[TGenreId] [int] NOT NULL,
 CONSTRAINT [PK_ShowGenre] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ShowGenre]  WITH CHECK ADD  CONSTRAINT [FK_ShowGenre_Genre] FOREIGN KEY([TGenreId])
REFERENCES [dbo].[Genre] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShowGenre] CHECK CONSTRAINT [FK_ShowGenre_Genre]
GO
ALTER TABLE [dbo].[ShowGenre]  WITH CHECK ADD  CONSTRAINT [FK_ShowGenre_Show] FOREIGN KEY([TShowId])
REFERENCES [dbo].[Show] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShowGenre] CHECK CONSTRAINT [FK_ShowGenre_Show]
GO
ALTER TABLE [dbo].[ShowGenre] ADD  CONSTRAINT [DF_ShowGenre_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
