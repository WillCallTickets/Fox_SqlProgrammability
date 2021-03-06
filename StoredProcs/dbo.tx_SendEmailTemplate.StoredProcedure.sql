USE [Fox_2014]
GO
/****** Object:  StoredProcedure [dbo].[tx_SendEmailTemplate]    Script Date: 10/02/2016 18:20:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Rob Kurtz
-- Create date: 07/12/05
-- Description:	Sends an email specified by template to criteria. Does replacements in template with name/value pairs.
/*
Config.CustomerForgotPasswordEmail
mq.DataContext.NewEmailParam("UserPass", c.Password, mq);
MailQueue mq = c.DataContext.NewMailQueue(DateTime.Now, "Fox Ticketing Customer Service",
"CustomerService@FoxTheatre.com", c.EmailAddress, 0, SqlBoolean.False, el);
	objError.StackTrace	"   at System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior cmdBehavior, RunBehavior runBehavior, Boolean returnStream)\r\n   at System.Data.SqlClient.SqlCommand.ExecuteReader(CommandBehavior behavior)\r\n   at System.Data.SqlClient.SqlCommand.System.Data.IDbCommand.ExecuteReader(CommandBehavior behavior)\r\n   at System.Data.Common.DbDataAdapter.FillFromCommand(Object data, Int32 startRecord, Int32 maxRecords, String srcTable, IDbCommand command, CommandBehavior behavior)\r\n   at System.Data.Common.DbDataAdapter.Fill(DataSet dataSet, Int32 startRecord, Int32 maxRecords, String srcTable, IDbCommand command, CommandBehavior behavior)\r\n   at System.Data.Common.DbDataAdapter.Fill(DataSet dataSet)\r\n   at OrmLib.DataManagerBase.ExecuteProcedure(String procName, SqlParameter[] paramList)\r\n   at JabbaBiz.StoredProcedures.tx_SendEmailTemplate(String emailTemplate, String sendDate, String fromName, String fromAddress, String toAddress, String paramNames, String paramValues, String& result) in C:\\Source\\Jabba\\JabbaBiz\\do_not_edit\\StoredProcedures.cs:line 1313\r\n   at JabbaBiz.MailQueue.SendEmailTemplate(String templateName, DateTime sendTime, String fromName, String fromAddress, String toAddress, String paramNames, String paramValues) in C:\\Source\\Jabba\\JabbaBiz\\MailQueue.cs:line 75\r\n   at JabbaBiz.MailQueue.SendEmail_CustomerService(String ip, String userInfo, String fromName, String fromAddress, String subject, String msg) in C:\\Source\\Jabba\\JabbaBiz\\MailQueue.cs:line 59\r\n   at Ticks.Controls.Contact.ButtonSubmit_Click(Object sender, EventArgs e) in c:\\source\\jabba\\ticks\\controls\\contact.ascx.cs:line 97\r\n   at System.Web.UI.WebControls.Button.OnClick(EventArgs e)\r\n   at System.Web.UI.WebControls.Button.System.Web.UI.IPostBackEventHandler.RaisePostBackEvent(String eventArgument)\r\n   at System.Web.UI.Page.RaisePostBackEvent(IPostBackEventHandler sourceControl, String eventArgument)\r\n   at System.Web.UI.Page.RaisePostBackEvent(NameValueCollection postData)\r\n   at System.Web.UI.Page.ProcessRequestMain()"	string

declare @P1 varchar(300)
set @P1=NULL
exec tx_SendEmailTemplate @emailTemplate = 
'CustomerServiceEmail.html', 
@sendDate = '05/06/2007 05:40PM', 
@fromName = 'dasdfasd', 
@fromAddress = 'rob@kurtz.net', 
@toAddress = 'customerservice@foxtheatre.com', 
@paramNames = 'IP~UserInfo~FromName~EmailAdress~Subject~Message', 
@paramValues = '127.0.0.1~Browser Type: IE7~dasdfasd~rob@kurtz.net~lkjhlk', 
@result = @P1 output
select @P1
*/
-- =============================================

CREATE	PROC [dbo].[tx_SendEmailTemplate]

	@applicationId	uniqueidentifier,
	@emailTemplate 	varchar(256),
	@sendDate		varchar(25),
	@fromName		varchar(80),
	@fromAddress	varchar(256),
	@toAddress		varchar(256),
	@paramNames		varchar(3000),
	@paramValues	varchar(3000),
	@bccEmail		varchar(300),
	@priority		int,

	@result varchar(300) OUTPUT

AS

SET NOCOUNT ON

BEGIN

	--ensure email template exists
	IF NOT EXISTS(SELECT * FROM EmailLetter e WHERE e.[ApplicationId] = @applicationId AND e.Name = @emailTemplate) BEGIN
		SET 	@result = 'The email template: ' + @emailTemplate + ' is not in our database.'
		RETURN
	END

	DECLARE	@mailId		int,
			@letterId	int

	SELECT	@letterId = e.[Id] FROM EmailLetter e WHERE e.[ApplicationId] = @applicationId AND e.Name = @emailTemplate

	--ensure we don't send it before params (below) are inserted
	DECLARE	@safeDateToSend	DateTime; SET @safeDateToSend = DATEADD(ss, 10, @sendDate);

	IF(CAST(@sendDate as DateTime) < @safeDateToSend)	BEGIN
		SET @sendDate = CONVERT(varchar(25), @safeDateToSend, 100)
	END

	INSERT	MailQueue(ApplicationId, DateToProcess,FromName,FromAddress,ToAddress,BCC,TEmailLetterId,Priority,bMassMailer)
	VALUES	(@applicationId, @sendDate,@fromName,@fromAddress,@toAddress,@bccEmail,@letterId,@priority,0)

	SET	@mailId = Scope_Identity()

	--set up email params by paramnames and values
	IF Len(@paramNames) > 0 BEGIN

		DECLARE @first	int,
				@second	int

		SET	@first = Len(@paramNames) - Len(REPLACE(@paramNames,'~',''))
		SET	@second = Len(@paramValues) - Len(REPLACE(@paramValues,'~',''))

		IF(@first <> @second)	 BEGIN
			SET	@result = 'ParamNames has ' + cast(@first as varchar(25)) + ' entries and ParamValues has ' + 
				cast(@second as varchar(25)) + ' entries.'
			RETURN
		END

		INSERT	EmailParam([Name],[Value],[TMailQueueId])
		SELECT	ParamName, ParamValue, @mailId
		FROM	fn_DualListToTable(@paramNames,@paramValues)
		ORDER BY [Id]

	END

	SET	@result = 'SUCCESS'

	RETURN

END
GO
