USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Z2SubscriptionRequest]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Z2SubscriptionRequest](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[tZ2SubscriptionId] [int] NOT NULL,
	[Source] [varchar](50) NOT NULL,
	[SubscriptionRequest] [varchar](25) NOT NULL,
	[IpAddress] [varchar](25) NOT NULL,
 CONSTRAINT [PK_Z2SubscriptionRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Z2SubscriptionRequest]  WITH CHECK ADD  CONSTRAINT [FK_Z2SubscriptionRequest_Z2Subscription] FOREIGN KEY([tZ2SubscriptionId])
REFERENCES [dbo].[Z2Subscription] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Z2SubscriptionRequest] CHECK CONSTRAINT [FK_Z2SubscriptionRequest_Z2Subscription]
GO
ALTER TABLE [dbo].[Z2SubscriptionRequest] ADD  CONSTRAINT [DF_Z2SubscriptionRequest_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
