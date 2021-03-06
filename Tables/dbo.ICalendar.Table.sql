USE [Fox_2014]
GO
/****** Object:  Table [dbo].[ICalendar]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ICalendar](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[DtStamp] [datetime] NOT NULL,
	[UrlKey] [varchar](256) NOT NULL,
	[SerializedCalendar] [varchar](4000) NOT NULL,
 CONSTRAINT [PK_ICalendar] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ICalendar] ADD  CONSTRAINT [DF_ICalendar_DtStamp]  DEFAULT (getdate()) FOR [DtStamp]
GO
