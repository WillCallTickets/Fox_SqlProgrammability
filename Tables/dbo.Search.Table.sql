USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Search]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Search](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[vcContext] [varchar](50) NOT NULL,
	[Terms] [nvarchar](256) NOT NULL,
	[iResults] [int] NOT NULL,
	[EmailAddress] [varchar](256) NOT NULL,
	[IpAddress] [varchar](25) NOT NULL,
	[vcPrincipal] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Search] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Search] ADD  CONSTRAINT [DF_Search_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[Search] ADD  CONSTRAINT [DF_Search_iResults]  DEFAULT ((0)) FOR [iResults]
GO
ALTER TABLE [dbo].[Search] ADD  DEFAULT ('fox') FOR [vcPrincipal]
GO
