USE [Fox_2014]
GO
/****** Object:  Table [dbo].[VdShowGenre]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[VdShowGenre](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[tShowId] [int] NOT NULL,
	[tParentGenreId] [int] NULL,
	[GenreName] [varchar](256) NOT NULL,
	[bIsMainGenre] [bit] NOT NULL,
	[iOrdinal] [int] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_VdShowGenre] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[VdShowGenre]  WITH CHECK ADD  CONSTRAINT [FK_VdShowGenre_Show] FOREIGN KEY([tShowId])
REFERENCES [dbo].[Show] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VdShowGenre] CHECK CONSTRAINT [FK_VdShowGenre_Show]
GO
ALTER TABLE [dbo].[VdShowGenre]  WITH CHECK ADD  CONSTRAINT [FK_VdShowGenre_VdShowGenre] FOREIGN KEY([tParentGenreId])
REFERENCES [dbo].[VdShowGenre] ([Id])
GO
ALTER TABLE [dbo].[VdShowGenre] CHECK CONSTRAINT [FK_VdShowGenre_VdShowGenre]
GO
ALTER TABLE [dbo].[VdShowGenre] ADD  CONSTRAINT [DF_VdShowGenre_bIsMainGenre]  DEFAULT ((1)) FOR [bIsMainGenre]
GO
ALTER TABLE [dbo].[VdShowGenre] ADD  CONSTRAINT [DF_VdShowGenre_iOrdinal]  DEFAULT ((-1)) FOR [iOrdinal]
GO
ALTER TABLE [dbo].[VdShowGenre] ADD  CONSTRAINT [DF_VdShowGenre_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
