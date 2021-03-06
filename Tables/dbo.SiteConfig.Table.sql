USE [Fox_2014]
GO
/****** Object:  Table [dbo].[SiteConfig]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SiteConfig](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[DataType] [varchar](50) NOT NULL,
	[MaxLength] [int] NOT NULL,
	[Context] [varchar](256) NULL,
	[Description] [varchar](2000) NULL,
	[Name] [varchar](500) NOT NULL,
	[Value] [varchar](2000) NULL,
	[dtStamp] [datetime] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SiteConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SiteConfig]  WITH NOCHECK ADD  CONSTRAINT [FK_SiteConfig_Aspnet_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[SiteConfig] CHECK CONSTRAINT [FK_SiteConfig_Aspnet_Applications]
GO
ALTER TABLE [dbo].[SiteConfig] ADD  CONSTRAINT [DF_SiteConfig_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
