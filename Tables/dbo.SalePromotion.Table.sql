USE [Fox_2014]
GO
/****** Object:  Table [dbo].[SalePromotion]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SalePromotion](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[dtStamp] [datetime] NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[bActive] [bit] NOT NULL,
	[iBannerTimeoutMsecs] [int] NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[DisplayText] [varchar](1000) NULL,
	[AdditionalText] [varchar](500) NULL,
	[BannerUrl] [varchar](256) NULL,
	[BannerClickUrl] [varchar](256) NULL,
	[dtStartDate] [datetime] NULL,
	[dtEndDate] [datetime] NULL,
	[vcPrincipal] [varchar](100) NOT NULL,
	[vcJsonOrdinal] [varchar](100) NOT NULL,
 CONSTRAINT [PK_MerchPromotion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SalePromotion]  WITH CHECK ADD  CONSTRAINT [FK_SalePromotion_aspnet_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[SalePromotion] CHECK CONSTRAINT [FK_SalePromotion_aspnet_Applications]
GO
ALTER TABLE [dbo].[SalePromotion] ADD  CONSTRAINT [DF_MerchPromotion_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[SalePromotion] ADD  CONSTRAINT [DF_SalePromotion_bActive]  DEFAULT ((1)) FOR [bActive]
GO
ALTER TABLE [dbo].[SalePromotion] ADD  CONSTRAINT [DF_SalePromotion_iBannerTimeoutMsecs]  DEFAULT ((2400)) FOR [iBannerTimeoutMsecs]
GO
ALTER TABLE [dbo].[SalePromotion] ADD  DEFAULT ('fox') FOR [vcPrincipal]
GO
ALTER TABLE [dbo].[SalePromotion] ADD  DEFAULT ('') FOR [vcJsonOrdinal]
GO
