USE [Fox_2014]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Employee](
	[Id] [int] IDENTITY(10000,1) NOT FOR REPLICATION NOT NULL,
	[Login] [varchar](256) NULL,
	[EmailAddress] [varchar](256) NOT NULL,
	[ePassword] [varchar](256) NULL,
	[Dept] [varchar](50) NULL,
	[TitleDescription] [varchar](75) NULL,
	[Title] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[MI] [varchar](20) NULL,
	[LastName] [varchar](100) NULL,
	[Extension] [varchar](10) NULL,
	[bListInDirectory] [bit] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[vcPrincipal] [varchar](100) NOT NULL,
	[vcJsonOrdinal] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Employee]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_Aspnet_Applications] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[aspnet_Applications] ([ApplicationId])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Aspnet_Applications]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_bListInDirectory]  DEFAULT ((1)) FOR [bListInDirectory]
GO
ALTER TABLE [dbo].[Employee] ADD  CONSTRAINT [DF_Employee_DtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT ('fox') FOR [vcPrincipal]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT ('') FOR [vcJsonOrdinal]
GO
