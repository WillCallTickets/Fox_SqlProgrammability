USE [Fox_2014]
GO
/****** Object:  Table [dbo].[VdShowTicket]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VdShowTicket](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[tShowId] [int] NOT NULL,
	[TicketDescription] [nvarchar](256) NOT NULL,
	[TicketQualifier] [nvarchar](50) NULL,
	[bReserved] [bit] NOT NULL,
	[mBasePrice] [money] NOT NULL,
	[mServiceCharge] [money] NOT NULL,
	[AdditionalDescription] [nvarchar](256) NULL,
	[mAdditionalCharge] [money] NOT NULL,
	[mEach]  AS (([mBasePrice]+[mServiceCharge])+[mAdditionalCharge]),
	[iOrdinal] [int] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_VdShowTicket] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This might be ages or some other criteria that differentiates a similar TicketDescription' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VdShowTicket', @level2type=N'COLUMN',@level2name=N'TicketQualifier'
GO
ALTER TABLE [dbo].[VdShowTicket]  WITH CHECK ADD  CONSTRAINT [FK_VdShowTicket_Show] FOREIGN KEY([tShowId])
REFERENCES [dbo].[Show] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VdShowTicket] CHECK CONSTRAINT [FK_VdShowTicket_Show]
GO
ALTER TABLE [dbo].[VdShowTicket] ADD  CONSTRAINT [DF_VdShowTicket_bReserved]  DEFAULT ((0)) FOR [bReserved]
GO
ALTER TABLE [dbo].[VdShowTicket] ADD  CONSTRAINT [DF_VdShowTicket_mBasePrice]  DEFAULT ((0)) FOR [mBasePrice]
GO
ALTER TABLE [dbo].[VdShowTicket] ADD  CONSTRAINT [DF_VdShowTicket_mServiceCharge]  DEFAULT ((0)) FOR [mServiceCharge]
GO
ALTER TABLE [dbo].[VdShowTicket] ADD  CONSTRAINT [DF_VdShowTicket_mAdditionalCharge]  DEFAULT ((0)) FOR [mAdditionalCharge]
GO
ALTER TABLE [dbo].[VdShowTicket] ADD  CONSTRAINT [DF_VdShowTicket_iOrdinal]  DEFAULT ((-1)) FOR [iOrdinal]
GO
ALTER TABLE [dbo].[VdShowTicket] ADD  CONSTRAINT [DF_VdShowTicket_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
