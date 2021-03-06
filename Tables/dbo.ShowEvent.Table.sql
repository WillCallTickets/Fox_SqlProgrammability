USE [Fox_2014]
GO
/****** Object:  Table [dbo].[ShowEvent]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShowEvent](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[tOwnerId] [int] NOT NULL,
	[vcOwnerType] [varchar](256) NOT NULL,
	[tParentId] [int] NOT NULL,
	[vcParentType] [varchar](256) NULL,
	[bActive] [bit] NOT NULL,
	[iOrdinal] [int] NOT NULL,
	[DateString] [varchar](500) NULL,
	[Status] [varchar](500) NULL,
	[ShowTitle] [varchar](500) NULL,
	[Promoter] [varchar](500) NULL,
	[Header] [varchar](500) NULL,
	[Headliner] [varchar](2000) NULL,
	[Opener] [varchar](1000) NULL,
	[Venue] [varchar](500) NULL,
	[Times] [varchar](500) NULL,
	[Ages] [varchar](500) NULL,
	[Pricing] [varchar](256) NULL,
	[Url] [varchar](256) NULL,
	[ImageUrl] [varchar](256) NULL,
 CONSTRAINT [PK_ShowEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Relative links please' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ShowEvent', @level2type=N'COLUMN',@level2name=N'ImageUrl'
GO
ALTER TABLE [dbo].[ShowEvent] ADD  CONSTRAINT [DF_ShowEvent_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[ShowEvent] ADD  CONSTRAINT [DF_ShowEvent_tParentId]  DEFAULT ((0)) FOR [tParentId]
GO
ALTER TABLE [dbo].[ShowEvent] ADD  CONSTRAINT [DF_ShowEvent_bActive]  DEFAULT ((0)) FOR [bActive]
GO
ALTER TABLE [dbo].[ShowEvent] ADD  CONSTRAINT [DF_ShowEvent_iOrdinal]  DEFAULT ((-1)) FOR [iOrdinal]
GO
