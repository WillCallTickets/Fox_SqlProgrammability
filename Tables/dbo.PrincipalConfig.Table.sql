USE [Fox_2014]
GO
/****** Object:  Table [dbo].[PrincipalConfig]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PrincipalConfig](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[vcPrincipal] [varchar](10) NOT NULL,
	[DataType] [varchar](50) NOT NULL,
	[MaxLength] [int] NOT NULL,
	[Context] [varchar](50) NULL,
	[Description] [varchar](256) NULL,
	[Name] [varchar](50) NOT NULL,
	[Value] [varchar](256) NULL,
	[dtStamp] [datetime] NOT NULL,
	[dtModified] [datetime] NOT NULL,
 CONSTRAINT [PK_PrincipalConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PrincipalConfig] ADD  CONSTRAINT [DF_PrincipalConfig_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[PrincipalConfig] ADD  CONSTRAINT [DF_PrincipalConfig_dtModified]  DEFAULT (getdate()) FOR [dtModified]
GO
