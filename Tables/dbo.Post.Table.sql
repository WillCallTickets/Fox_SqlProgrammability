USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Post]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Post](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[vcPrincipal] [varchar](100) NOT NULL,
	[bActive] [bit] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Slug] [varchar](50) NOT NULL,
	[Description] [varchar](256) NULL,
	[Value] [varchar](max) NULL,
	[dtStamp] [datetime] NOT NULL,
	[dtModified] [datetime] NOT NULL,
	[vcJsonOrdinal] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Post] ADD  CONSTRAINT [DF_Post_bActive]  DEFAULT ((1)) FOR [bActive]
GO
ALTER TABLE [dbo].[Post] ADD  CONSTRAINT [DF_Post_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[Post] ADD  CONSTRAINT [DF_Post_dtModified]  DEFAULT (getdate()) FOR [dtModified]
GO
ALTER TABLE [dbo].[Post] ADD  DEFAULT ('') FOR [vcJsonOrdinal]
GO
