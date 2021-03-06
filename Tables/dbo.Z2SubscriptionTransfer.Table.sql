USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Z2SubscriptionTransfer]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Z2SubscriptionTransfer](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[tZ2SubscriptionId] [int] NOT NULL,
	[Email] [varchar](256) NOT NULL,
	[ListSource] [varchar](50) NOT NULL,
	[dtTransferred] [datetime] NULL,
	[TransferSubscribedStatus] [bit] NULL,
	[dtSourceListUpdated] [datetime] NULL,
 CONSTRAINT [PK_Z2SubscriptionTransfer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Z2SubscriptionTransfer]  WITH CHECK ADD  CONSTRAINT [FK_Z2SubscriptionTransfer_Z2Subscription] FOREIGN KEY([tZ2SubscriptionId])
REFERENCES [dbo].[Z2Subscription] ([Id])
GO
ALTER TABLE [dbo].[Z2SubscriptionTransfer] CHECK CONSTRAINT [FK_Z2SubscriptionTransfer_Z2Subscription]
GO
ALTER TABLE [dbo].[Z2SubscriptionTransfer] ADD  CONSTRAINT [DF_Z2SubscriptionTransfer_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
