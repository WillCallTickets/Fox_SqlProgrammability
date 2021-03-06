USE [Fox_2014]
GO
/****** Object:  Table [dbo].[EmailParamArchive]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailParamArchive](
	[Id] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Value] [varchar](8000) NULL,
	[TMailQueueId] [int] NULL,
	[dtStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_EmailParamArchive] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
