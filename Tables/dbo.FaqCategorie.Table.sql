USE [Fox_2014]
GO
/****** Object:  Table [dbo].[FaqCategorie]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FaqCategorie](
	[dtStamp] [datetime] NOT NULL,
	[bActive] [bit] NOT NULL,
	[DisplayText] [varchar](500) NULL,
	[Description] [varchar](500) NULL,
	[iDisplayOrder] [int] NOT NULL,
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FaqCategorie] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[FaqCategorie]  WITH CHECK ADD  CONSTRAINT [FK_FaqCategorie_Aspnet_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[FaqCategorie] CHECK CONSTRAINT [FK_FaqCategorie_Aspnet_Applications]
GO
ALTER TABLE [dbo].[FaqCategorie] ADD  CONSTRAINT [DF_FaqCategory_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[FaqCategorie] ADD  CONSTRAINT [DF_FaqCategorie_bActive]  DEFAULT ((0)) FOR [bActive]
GO
ALTER TABLE [dbo].[FaqCategorie] ADD  CONSTRAINT [DF_FaqCategory_iDisplayOrder]  DEFAULT ((0)) FOR [iDisplayOrder]
GO
