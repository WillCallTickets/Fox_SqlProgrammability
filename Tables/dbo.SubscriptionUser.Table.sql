USE [Fox_2014]
GO
/****** Object:  Table [dbo].[SubscriptionUser]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubscriptionUser](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[TSubscriptionId] [int] NOT NULL,
	[bSubscribed] [bit] NOT NULL,
	[dtLastActionDate] [datetime] NULL,
	[bHtmlFormat] [bit] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_EmailSubscriptionJoinProfile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubscriptionUser]  WITH CHECK ADD  CONSTRAINT [FK_EmailUserSubscription_aspnet_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
ALTER TABLE [dbo].[SubscriptionUser] CHECK CONSTRAINT [FK_EmailUserSubscription_aspnet_Users]
GO
ALTER TABLE [dbo].[SubscriptionUser]  WITH CHECK ADD  CONSTRAINT [FK_EmailUserSubscription_EmailSubscription] FOREIGN KEY([TSubscriptionId])
REFERENCES [dbo].[Subscription] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SubscriptionUser] CHECK CONSTRAINT [FK_EmailUserSubscription_EmailSubscription]
GO
ALTER TABLE [dbo].[SubscriptionUser] ADD  CONSTRAINT [DF_EmailSubscriptionJoinProfile_bSubscribed]  DEFAULT ((0)) FOR [bSubscribed]
GO
ALTER TABLE [dbo].[SubscriptionUser] ADD  CONSTRAINT [DF_EmailSubscriptionJoinProfile_bHtmlFormat]  DEFAULT ((1)) FOR [bHtmlFormat]
GO
ALTER TABLE [dbo].[SubscriptionUser] ADD  CONSTRAINT [DF_EmailSubscriptionJoinProfile_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
