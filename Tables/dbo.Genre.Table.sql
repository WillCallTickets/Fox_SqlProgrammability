USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Genre]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Genre](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[Description] [varchar](500) NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Genre] ADD  CONSTRAINT [DF_Genre_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
