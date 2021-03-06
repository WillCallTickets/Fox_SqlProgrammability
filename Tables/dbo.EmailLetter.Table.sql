USE [Fox_2014]
GO
/****** Object:  Table [dbo].[EmailLetter]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailLetter](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[Subject] [varchar](256) NOT NULL,
	[StyleContent] [varchar](max) NULL,
	[HtmlVersion] [varchar](max) NOT NULL,
	[TextVersion] [varchar](max) NULL,
	[dtStamp] [datetime] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EmailLetter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[EmailLetter]  WITH NOCHECK ADD  CONSTRAINT [FK_EmailLetter_Aspnet_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[EmailLetter] CHECK CONSTRAINT [FK_EmailLetter_Aspnet_Applications]
GO
ALTER TABLE [dbo].[EmailLetter] ADD  CONSTRAINT [DF_EmailLetter_DtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
