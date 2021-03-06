USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Z2Subscription]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Z2Subscription](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[dtCreated] [datetime] NOT NULL,
	[dtModified] [datetime] NULL,
	[Email] [varchar](256) NOT NULL,
	[IpAddress] [varchar](25) NOT NULL,
	[bSubscribed] [bit] NOT NULL,
	[tZ2SubscriptionHistoryId] [int] NULL,
	[InitialSourceQuery] [varchar](256) NULL,
 CONSTRAINT [PK_Z2Subscription] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Z2Subscription] ADD  CONSTRAINT [DF_Z2Subscription_dtCreated]  DEFAULT (getdate()) FOR [dtCreated]
GO
ALTER TABLE [dbo].[Z2Subscription] ADD  CONSTRAINT [DF_Z2Subscription_bSubscribed]  DEFAULT ((0)) FOR [bSubscribed]
GO
