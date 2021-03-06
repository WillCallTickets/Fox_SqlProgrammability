USE [Fox_2014]
GO
/****** Object:  Table [dbo].[VdShowExpense]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VdShowExpense](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[tShowId] [int] NOT NULL,
	[dtIncurred] [datetime] NULL,
	[ExpenseCategory] [varchar](256) NULL,
	[ExpenseName] [varchar](256) NOT NULL,
	[Notes] [varchar](500) NULL,
	[mAmount] [money] NOT NULL,
	[iOrdinal] [int] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_VdShowExpense] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[VdShowExpense]  WITH CHECK ADD  CONSTRAINT [FK_VdShowExpense_Show] FOREIGN KEY([tShowId])
REFERENCES [dbo].[Show] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VdShowExpense] CHECK CONSTRAINT [FK_VdShowExpense_Show]
GO
ALTER TABLE [dbo].[VdShowExpense] ADD  CONSTRAINT [DF_VdShowExpense_dtDateIncurred]  DEFAULT (getdate()) FOR [dtIncurred]
GO
ALTER TABLE [dbo].[VdShowExpense] ADD  CONSTRAINT [DF_VdShowExpense_mAmount]  DEFAULT ((0)) FOR [mAmount]
GO
ALTER TABLE [dbo].[VdShowExpense] ADD  CONSTRAINT [DF_VdShowExpense_iOrdinal]  DEFAULT ((-1)) FOR [iOrdinal]
GO
ALTER TABLE [dbo].[VdShowExpense] ADD  CONSTRAINT [DF_VdShowExpense_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
