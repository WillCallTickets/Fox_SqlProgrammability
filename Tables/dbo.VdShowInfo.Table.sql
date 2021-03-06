USE [Fox_2014]
GO
/****** Object:  Table [dbo].[VdShowInfo]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VdShowInfo](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[tShowId] [int] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[dtModified] [datetime] NOT NULL,
	[Agent] [nvarchar](256) NULL,
	[Buyer] [nvarchar](256) NULL,
	[mTicketGross] [money] NULL,
	[iTicketsSold] [int] NULL,
	[iCompsIn] [int] NULL,
	[mFacilityFee] [money] NULL,
	[mConcessions] [money] NULL,
	[mBarTotal] [money] NULL,
	[mBarPerHead] [money] NULL,
	[iMarketingDays] [int] NULL,
	[MOD] [nvarchar](256) NULL,
	[mProdLabor] [money] NULL,
	[mSecurityLabor] [money] NULL,
	[mHospitality] [money] NULL,
	[iMarketPlays] [int] NULL,
	[Notes] [varchar](2000) NULL,
 CONSTRAINT [PK_VdShowInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[VdShowInfo]  WITH CHECK ADD  CONSTRAINT [FK_VdShowInfo_Show] FOREIGN KEY([tShowId])
REFERENCES [dbo].[Show] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VdShowInfo] CHECK CONSTRAINT [FK_VdShowInfo_Show]
GO
ALTER TABLE [dbo].[VdShowInfo] ADD  CONSTRAINT [DF_VdShowInfo_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[VdShowInfo] ADD  CONSTRAINT [DF_VdShowInfo_dtModified]  DEFAULT (getdate()) FOR [dtModified]
GO
