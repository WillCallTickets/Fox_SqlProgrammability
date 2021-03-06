USE [Fox_2014]
GO
/****** Object:  Table [dbo].[JShowAct]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JShowAct](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[TActId] [int] NOT NULL,
	[TShowDateId] [int] NOT NULL,
	[PreText] [varchar](500) NULL,
	[ActText] [varchar](300) NULL,
	[Featuring] [varchar](1000) NULL,
	[PostText] [varchar](2000) NULL,
	[iDisplayOrder] [int] NOT NULL,
	[bTopBilling] [bit] NULL,
	[dtStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_JShowAct] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[JShowAct]  WITH NOCHECK ADD  CONSTRAINT [FK_JShowAct_Act] FOREIGN KEY([TActId])
REFERENCES [dbo].[Act] ([Id])
GO
ALTER TABLE [dbo].[JShowAct] CHECK CONSTRAINT [FK_JShowAct_Act]
GO
ALTER TABLE [dbo].[JShowAct]  WITH NOCHECK ADD  CONSTRAINT [FK_JShowAct_ShowDate] FOREIGN KEY([TShowDateId])
REFERENCES [dbo].[ShowDate] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[JShowAct] CHECK CONSTRAINT [FK_JShowAct_ShowDate]
GO
ALTER TABLE [dbo].[JShowAct] ADD  CONSTRAINT [DF_JShowAct_bTopBilling]  DEFAULT ((0)) FOR [bTopBilling]
GO
ALTER TABLE [dbo].[JShowAct] ADD  CONSTRAINT [DF_JShowAct_DtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
