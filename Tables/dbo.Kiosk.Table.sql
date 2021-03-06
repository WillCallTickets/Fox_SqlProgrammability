USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Kiosk]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Kiosk](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[bActive] [bit] NOT NULL,
	[iTimeoutMsecs] [int] NOT NULL,
	[TShowId] [int] NULL,
	[Name] [varchar](500) NOT NULL,
	[DisplayUrl] [varchar](500) NULL,
	[iPicWidth] [int] NOT NULL,
	[iPicHeight] [int] NOT NULL,
	[bCtrX] [bit] NOT NULL,
	[bCtrY] [bit] NOT NULL,
	[EventVenue] [varchar](500) NULL,
	[EventDate] [varchar](500) NULL,
	[EventTitle] [varchar](500) NULL,
	[EventHeads] [varchar](500) NULL,
	[EventOpeners] [varchar](500) NULL,
	[EventDescription] [varchar](2000) NULL,
	[TextCss] [varchar](256) NULL,
	[dtStartDate] [datetime] NULL,
	[dtEndDate] [datetime] NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[vcPrincipal] [varchar](100) NOT NULL,
	[vcJsonOrdinal] [varchar](100) NOT NULL,
 CONSTRAINT [PK_RotationalAd] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Kiosk]  WITH CHECK ADD  CONSTRAINT [FK_RotationalAd_aspnet_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Kiosk] CHECK CONSTRAINT [FK_RotationalAd_aspnet_Applications]
GO
ALTER TABLE [dbo].[Kiosk]  WITH CHECK ADD  CONSTRAINT [FK_RotationalAd_Show] FOREIGN KEY([TShowId])
REFERENCES [dbo].[Show] ([Id])
GO
ALTER TABLE [dbo].[Kiosk] CHECK CONSTRAINT [FK_RotationalAd_Show]
GO
ALTER TABLE [dbo].[Kiosk] ADD  CONSTRAINT [DF_RotationalAd_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[Kiosk] ADD  CONSTRAINT [DF_RotationalAd_bActive]  DEFAULT ((0)) FOR [bActive]
GO
ALTER TABLE [dbo].[Kiosk] ADD  CONSTRAINT [DF_RotationalAd_iTimeoutMsecs]  DEFAULT ((6000)) FOR [iTimeoutMsecs]
GO
ALTER TABLE [dbo].[Kiosk] ADD  CONSTRAINT [DF_RotationalAd_iPicWidth]  DEFAULT ((0)) FOR [iPicWidth]
GO
ALTER TABLE [dbo].[Kiosk] ADD  CONSTRAINT [DF_RotationalAd_iPicHeight]  DEFAULT ((0)) FOR [iPicHeight]
GO
ALTER TABLE [dbo].[Kiosk] ADD  CONSTRAINT [DF_RotationalAd_bCtrX]  DEFAULT ((1)) FOR [bCtrX]
GO
ALTER TABLE [dbo].[Kiosk] ADD  CONSTRAINT [DF_RotationalAd_bCtrY]  DEFAULT ((1)) FOR [bCtrY]
GO
ALTER TABLE [dbo].[Kiosk] ADD  DEFAULT ('fox') FOR [vcPrincipal]
GO
ALTER TABLE [dbo].[Kiosk] ADD  DEFAULT ('') FOR [vcJsonOrdinal]
GO
