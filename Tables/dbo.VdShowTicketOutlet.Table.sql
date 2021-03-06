USE [Fox_2014]
GO
/****** Object:  Table [dbo].[VdShowTicketOutlet]    Script Date: 10/02/2016 18:21:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VdShowTicketOutlet](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[tShowId] [int] NOT NULL,
	[tVdShowTicketId] [int] NOT NULL,
	[OutletName] [varchar](256) NOT NULL,
	[iAllotment] [int] NOT NULL,
	[iSold] [int] NOT NULL,
	[iOrdinal] [int] NOT NULL,
	[dtStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_VdShowTicketOutlet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[VdShowTicketOutlet]  WITH CHECK ADD  CONSTRAINT [FK_VdShowTicketOutlet_Show] FOREIGN KEY([tShowId])
REFERENCES [dbo].[Show] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VdShowTicketOutlet] CHECK CONSTRAINT [FK_VdShowTicketOutlet_Show]
GO
ALTER TABLE [dbo].[VdShowTicketOutlet]  WITH CHECK ADD  CONSTRAINT [FK_VdShowTicketOutlet_VdShowTicket] FOREIGN KEY([tVdShowTicketId])
REFERENCES [dbo].[VdShowTicket] ([Id])
GO
ALTER TABLE [dbo].[VdShowTicketOutlet] CHECK CONSTRAINT [FK_VdShowTicketOutlet_VdShowTicket]
GO
ALTER TABLE [dbo].[VdShowTicketOutlet] ADD  CONSTRAINT [DF_VdShowTicketOutlet_iAllotment]  DEFAULT ((0)) FOR [iAllotment]
GO
ALTER TABLE [dbo].[VdShowTicketOutlet] ADD  CONSTRAINT [DF_VdShowTicketOutlet_iOrdinal]  DEFAULT ((-1)) FOR [iOrdinal]
GO
ALTER TABLE [dbo].[VdShowTicketOutlet] ADD  CONSTRAINT [DF_VdShowTicketOutlet_dtStamp]  DEFAULT (getdate()) FOR [dtStamp]
GO
