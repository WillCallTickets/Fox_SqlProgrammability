USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Show]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Show](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](300) NOT NULL,
	[dtAnnounceDate] [datetime] NULL,
	[dtDateOnSale] [datetime] NULL,
	[bActive] [bit] NOT NULL,
	[bSoldOut] [bit] NOT NULL,
	[ShowAlert] [varchar](500) NULL,
	[TVenueId] [int] NOT NULL,
	[DisplayNotes] [varchar](1000) NULL,
	[ShowTitle] [varchar](300) NULL,
	[DisplayUrl] [varchar](300) NULL,
	[iPicWidth] [int] NOT NULL,
	[iPicHeight] [int] NOT NULL,
	[ShowHeader] [varchar](300) NULL,
	[ShowWriteup] [varchar](max) NULL,
	[dtStamp] [datetime] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[bCtrX] [bit] NOT NULL,
	[bCtrY] [bit] NOT NULL,
	[FacebookEventUrl] [varchar](256) NULL,
	[vcPrincipal] [varchar](100) NOT NULL,
	[vcJustAnnouncedStatus] [varchar](25) NULL,
 CONSTRAINT [PK_Show] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Show]  WITH NOCHECK ADD  CONSTRAINT [FK_Show_Aspnet_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Show] NOCHECK CONSTRAINT [FK_Show_Aspnet_Applications]
GO
ALTER TABLE [dbo].[Show]  WITH NOCHECK ADD  CONSTRAINT [FK_Show_Venue] FOREIGN KEY([TVenueId])
REFERENCES [dbo].[Venue] ([Id])
GO
ALTER TABLE [dbo].[Show] NOCHECK CONSTRAINT [FK_Show_Venue]
GO
ALTER TABLE [dbo].[Show] ADD  CONSTRAINT [DF_Show_bActive]  DEFAULT ((1)) FOR [bActive]
GO
ALTER TABLE [dbo].[Show] ADD  CONSTRAINT [DF_Show_bSoldOut]  DEFAULT ((0)) FOR [bSoldOut]
GO
ALTER TABLE [dbo].[Show] ADD  CONSTRAINT [DF_Show_TVenueId]  DEFAULT ((10000)) FOR [TVenueId]
GO
ALTER TABLE [dbo].[Show] ADD  CONSTRAINT [DF_Show_PicWidth]  DEFAULT ((0)) FOR [iPicWidth]
GO
ALTER TABLE [dbo].[Show] ADD  CONSTRAINT [DF_Show_PicHeight]  DEFAULT ((0)) FOR [iPicHeight]
GO
ALTER TABLE [dbo].[Show] ADD  CONSTRAINT [DF_Show_DtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[Show] ADD  CONSTRAINT [DF_Show_bCtrX]  DEFAULT ((1)) FOR [bCtrX]
GO
ALTER TABLE [dbo].[Show] ADD  CONSTRAINT [DF_Show_bCtrY]  DEFAULT ((1)) FOR [bCtrY]
GO
ALTER TABLE [dbo].[Show] ADD  DEFAULT ('fox') FOR [vcPrincipal]
GO
ALTER TABLE [dbo].[Show] ADD  DEFAULT (NULL) FOR [vcJustAnnouncedStatus]
GO
