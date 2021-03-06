USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Act]    Script Date: 10/02/2016 18:21:24 ******/
SET ARITHABORT ON
GO
SET CONCAT_NULL_YIELDS_NULL ON
GO
SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_WARNINGS ON
GO
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
SET ARITHABORT ON
GO
CREATE TABLE [dbo].[Act](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[NameRoot]  AS (case when charindex('the ',[Name])<>(1) then upper([Name]) else upper(substring([Name],(5),len([Name]))) end),
	[DisplayName] [varchar](256) NULL,
	[Website] [varchar](256) NULL,
	[PictureUrl] [varchar](256) NULL,
	[iPicWidth] [int] NOT NULL,
	[iPicHeight] [int] NOT NULL,
	[bListInDirectory] [bit] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Act] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Act]  WITH NOCHECK ADD  CONSTRAINT [FK_Act_Aspnet_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Act] CHECK CONSTRAINT [FK_Act_Aspnet_Applications]
GO
ALTER TABLE [dbo].[Act] ADD  CONSTRAINT [DF_Act_PicWidth]  DEFAULT ((0)) FOR [iPicWidth]
GO
ALTER TABLE [dbo].[Act] ADD  CONSTRAINT [DF_Act_PicHeight]  DEFAULT ((0)) FOR [iPicHeight]
GO
ALTER TABLE [dbo].[Act] ADD  CONSTRAINT [DF_Act_bListInDirectory]  DEFAULT ((1)) FOR [bListInDirectory]
GO
ALTER TABLE [dbo].[Act] ADD  CONSTRAINT [DF_Act_DtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
