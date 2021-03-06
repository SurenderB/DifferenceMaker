USE DifferenceMaker;

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Creating schemata'
GO
CREATE SCHEMA [CodesStatic]
AUTHORIZATION [dbo]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
CREATE SCHEMA [CodesDynamic]
AUTHORIZATION [dbo]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Award]'
GO
CREATE TABLE [dbo].[Award]
(
[Award_ID] [int] NOT NULL IDENTITY(5001, 3),
[Presenter_ID] [int] NOT NULL,
[PresenterLocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Recipient_ID] [int] NOT NULL,
[RecipientLocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PresentedOn] [smalldatetime] NOT NULL,
[Reason] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RedeemedOn] [smalldatetime] NULL,
[RedemptionLocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RedemptionComment] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_dbo_Award_CreatedOn] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_dbo_Award_CreatedBy] DEFAULT (suser_sname()),
[UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_dbo_Award_UpdatedOn] DEFAULT (getdate()),
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_dbo_Award_UpdatedBy] DEFAULT (suser_sname()),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_dbo_Award_IsActive] DEFAULT ((1)),
[IsDifferenceMaker] [bit] NULL,
[Amount] [money] NULL,
[AmountGross] [money] NULL,
[AwardDescription] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_dbo_Award] on [dbo].[Award]'
GO
ALTER TABLE [dbo].[Award] ADD CONSTRAINT [PK_dbo_Award] PRIMARY KEY CLUSTERED  ([Award_ID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_dbo_Award_Presenter_ID] on [dbo].[Award]'
GO
CREATE NONCLUSTERED INDEX [IX_dbo_Award_Presenter_ID] ON [dbo].[Award] ([Presenter_ID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_dbo_Award_PresenterLocation] on [dbo].[Award]'
GO
CREATE NONCLUSTERED INDEX [IX_dbo_Award_PresenterLocation] ON [dbo].[Award] ([PresenterLocation])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_dbo_Award_Recipient_ID] on [dbo].[Award]'
GO
CREATE NONCLUSTERED INDEX [IX_dbo_Award_Recipient_ID] ON [dbo].[Award] ([Recipient_ID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_dbo_Award_RecipientLocation] on [dbo].[Award]'
GO
CREATE NONCLUSTERED INDEX [IX_dbo_Award_RecipientLocation] ON [dbo].[Award] ([RecipientLocation])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_dbo_Award_PresentedOn] on [dbo].[Award]'
GO
CREATE NONCLUSTERED INDEX [IX_dbo_Award_PresentedOn] ON [dbo].[Award] ([PresentedOn])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_dbo_Award_RedemptionLocation] on [dbo].[Award]'
GO
CREATE NONCLUSTERED INDEX [IX_dbo_Award_RedemptionLocation] ON [dbo].[Award] ([RedemptionLocation])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Award_Deactivate]'
GO
SET ANSI_NULLS OFF
GO



CREATE PROCEDURE [dbo].[Award_Deactivate]
  ( @Award_ID int
)
AS

/***********************************************************************
PROCEDURE: Award_Deactivate<Usage>

   exec Award_Deactivate {@Award_ID}
   -- deactivates an award based on Award_ID, so it's not viewable, but still in the system.

<Modification History>
2/2/2007:	Bridges - Initial Entry
12/23/2014: Kent	Rename Proceedure and Parameters

***********************************************************************/

BEGIN

  
  SET NOCOUNT ON

  UPDATE dbo.Award
  SET	IsActive	=	0
  WHERE Award_ID = @Award_ID


END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [CodesDynamic].[Employee]'
GO
SET ANSI_NULLS ON
GO
CREATE TABLE [CodesDynamic].[Employee]
(
[Employee_ID] [int] NOT NULL IDENTITY(1, 1),
[NetworkId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameDisplay] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobTitle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobTitle_ID] [int] NULL,
[NameFirst] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameMiddle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameLast] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameGoesBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameFull] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameTitle] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficerCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorNumber] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneExtension] [int] NULL,
[Email] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkLocation] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkLocation_ID] [int] NULL,
[LocationCostCenterName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCostCenter_ID] [int] NULL,
[LocationCostCenter] [smallint] NULL,
[TeamCostCenterName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TeamCostCenter_ID] [int] NULL,
[TeamCostCenter] [smallint] NULL,
[DivisionName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Division_ID] [int] NULL,
[DivisionCostCenter] [smallint] NULL,
[LeaderEmployee_ID] [int] NULL,
[LeaderDisplayName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LeaderEmail] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsEmployee] [bit] NULL,
[IsBoardDirector] [bit] NULL,
[IsContractor] [bit] NULL,
[IsTerminated] [bit] NULL,
[IsSupervisor] [bit] NULL,
[EmploymentStatus] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmploymentStatus_ID] [int] NULL,
[EmploymentStatusUpdatedOn] [datetime] NULL,
[HiredOn] [datetime] NULL,
[TerminatedOn] [datetime] NULL,
[ClockNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalDocumentTitle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditDeskAnalystCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScoreOffset] [tinyint] NULL,
[LendingLimit] [money] NULL,
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_CodesDynamic_Employee_CreatedOn] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CodesDynamic_Employee_CreatedBy] DEFAULT (suser_sname()),
[UpdatedOn] [datetime] NULL CONSTRAINT [DF_CodesDynamic_Employee_UpdatedOn] DEFAULT (getdate()),
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CodesDynamic_Employee_UpdatedBy] DEFAULT (suser_sname()),
[StartingOn] [datetime] NOT NULL CONSTRAINT [DF_CodesDynamic_Employee_StartingOn] DEFAULT ('1-1-1900'),
[EndingOn] [datetime] NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_CodesDynamic_Employee_Deleted] DEFAULT ((0)),
[CodeStatus] AS (case when [Deleted]=(1) then (3) when [StartingOn]>getdate() then (0) when [StartingOn]<=getdate() AND getdate()<=isnull([EndingOn],'1-1-9999') then (1) when getdate()>isnull([EndingOn],'1-1-9999') then (2)  end),
[ImageURL] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImageURLLarge] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_CodesDynamic_Employee] on [CodesDynamic].[Employee]'
GO
ALTER TABLE [CodesDynamic].[Employee] ADD CONSTRAINT [PK_CodesDynamic_Employee] PRIMARY KEY CLUSTERED  ([Employee_ID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Location_OfEmployee]'
GO
/*

Function: Location_OfEmployee <Usage>
@MyLocation = Select dbo.Location_OfEmployee (@Employee_ID)
@MyLocation = Select  dbo.Location_OfEmployee (819)
returns office location of requested employee

<Modification History>
10/25/2006  RonY: Initial Entry
12/16/2015 Webbk: Refactored to use CodesDynamic.Employee
12/23/2014 WebbK: Rename Proceedure and Parameters
2014-12-29 webbK: 
***********************************************************************/

CREATE FUNCTION [dbo].[Location_OfEmployee] 
(
	@Employee_ID int
)
RETURNS VARCHAR(150)
AS
BEGIN
	DECLARE @Location VARCHAR(150)


	SELECT @Location = @Employee_ID
	
        SELECT
            @Location = WorkLocation
        FROM
            CodesDynamic.Employee
        WHERE
            Employee_ID = @Employee_ID
       
	       
        IF ( @Location IS NULL )
            BEGIN
                SET @Location = 'Unknown'
            END



	RETURN @Location

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[AwardGrossUp]'
GO
CREATE TABLE [dbo].[AwardGrossUp]
(
[AwardGrossUp_ID] [int] NOT NULL IDENTITY(1, 1),
[AwardAmount] [money] NOT NULL,
[GrossUpAmount] [money] NOT NULL,
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_dbo_AwardGrossUp_CreatedOn] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_dbo_AwardGrossUp_CreatedBy] DEFAULT (suser_sname()),
[UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_dbo_AwardGrossUp_UpdatedOn] DEFAULT (getdate()),
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_dbo_AwardGrossUp_UpdatedBy] DEFAULT (suser_sname())
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_dbo_AwardGrossUp] on [dbo].[AwardGrossUp]'
GO
ALTER TABLE [dbo].[AwardGrossUp] ADD CONSTRAINT [PK_dbo_AwardGrossUp] PRIMARY KEY CLUSTERED  ([AwardGrossUp_ID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Award_I]'
GO

CREATE PROCEDURE [dbo].[Award_I]
    (
     @Presenter_ID INT
    ,@Recipient_ID INT
    ,@PresentedOn DATETIME
    ,@Reason VARCHAR(3000)
    ,@IsDifferenceMaker BIT
    ,@Amount MONEY
    ,@AwardDescription VARCHAR(300)
    ,@Award_ID INT OUTPUT
    )
AS /*-------------------------------------------------------------------------------------------------------------------------------
 PROCEDURE: Award_I 
 
 
 Application Processing System (APS)
 
 <Usage>
 
    exec Award_I {Parameter List}
    -- inserts a record for the At Your Best Tracking table
 
 <Modification History>
 10/09/2006 RonY: Initial Entry
 10/25/2006 RonY: Added PresenterLocation, RecipientLocation, RedemptionLocation, RedemptionComment; 
			  
 07/11/2007 Naras	Added 4 new columns IsDifferenceMaker, Amount, AmountGross and  Description
 07/16/2007 Naras	Award is other, make redeemed date as current date 
            Tim		Default Description added for AYB and other awards
 07/17/2007 Michael if it is other award, store RedemptionComments_tx as 'Auto Redeemed' and RedemptionLoc as Presenter Loc
            Naras   Changed Gross amt as Award amt if it is other awards
 12/01/2014 Kent	corrected Raise error syntax
 12/23/2014 Kent	Rename Proceedure and Parameters
 --------------------------------------------------------------------------------------------------------------------------------*/
 
    BEGIN
        SET NOCOUNT ON
 
        DECLARE @AmountGross MONEY
 
 --DECLARE @SQLErrorNumber_VAL int
        DECLARE @SQLErrorDesc_TX VARCHAR(1000)

        DECLARE @PresenterLocation VARCHAR(50)
        DECLARE @RecipientLocation VARCHAR(50)

        DECLARE @RedeemedOn DATETIME
        DECLARE @RedemptionLocation VARCHAR(50)
        DECLARE @RedemptionComment VARCHAR(3000)
        DECLARE @Employee_ID INT


 -- get Presenters location  
        SET @Employee_ID = @Presenter_ID
        SELECT
            @PresenterLocation = dbo.Location_OfEmployee(@Employee_ID)

 -- get Recipients Location
        SET @Employee_ID = @Recipient_ID
        SELECT
            @RecipientLocation = dbo.Location_OfEmployee(@Employee_ID)
 
        IF @IsDifferenceMaker = 1
            BEGIN
		-- Calculate gross amount
                SELECT
                    @AmountGross = AwardAmount + GrossUpAmount
                FROM
                    dbo.AwardGrossUp
                WHERE
                    AwardAmount = @Amount
		-- Always set description to 'Difference Maker Award'
                SELECT
                    @AwardDescription = 'Difference Maker Award'
            END
        ELSE
            BEGIN
		-- Set AmountGross 
                SELECT
                    @AmountGross = @Amount
            END	
	
-- Award is other, set Current date as RedeemedOn
        IF @IsDifferenceMaker = 0
            BEGIN
                SELECT
                    @RedeemedOn = CONVERT(VARCHAR(10), GETDATE(), 101)
                   ,@RedemptionComment = 'Auto Redeemed'
                   ,@RedemptionLocation = @PresenterLocation	
            END
        ELSE
            BEGIN
                SELECT
                    @RedeemedOn = NULL
                   ,@RedemptionComment = NULL
                   ,@RedemptionLocation = NULL
            END
	
      
        BEGIN TRAN
 
        INSERT  INTO dbo.Award
                ( Presenter_ID
                ,PresenterLocation
                ,Recipient_ID
                ,RecipientLocation
                ,RedemptionComment
                ,RedemptionLocation
                ,PresentedOn
                ,RedeemedOn
                ,Reason
                ,IsDifferenceMaker
                ,Amount
                ,AmountGross
                ,AwardDescription
              
                )
        VALUES
                ( @Presenter_ID
                ,@PresenterLocation
                ,@Recipient_ID
                ,@RecipientLocation
                ,@RedemptionComment
                ,@RedemptionLocation
                ,@PresentedOn
                ,@RedeemedOn
                ,@Reason
                ,@IsDifferenceMaker
                ,@Amount
                ,@AmountGross
                ,@AwardDescription
                )
 
        IF ( @@error != 0 )
            BEGIN
                SET @SQLErrorDesc_TX = 'Award_I: Cannot insert into dbo.Award'
            
                RAISERROR(@SQLErrorDesc_TX, 16,1)
                ROLLBACK TRAN
                SELECT
                    @Award_ID = -1
            END
        ELSE
            BEGIN
                COMMIT TRAN
                SELECT
                    @Award_ID = SCOPE_IDENTITY()
            END

    
    END
 -- Stored Procedure


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Award_Redeem]'
GO

CREATE PROCEDURE [dbo].[Award_Redeem]
    (
     @RedeemedOn SMALLDATETIME
    ,@RedemptionLocation VARCHAR(50)
    ,@RedemptionComment VARCHAR(3000)
    ,@Award_ID INT
    )
AS /***********************************************************************
PROCEDURE: Award_Redeem <Usage>

   exec Award_Redeem {Parameter List}
   -- updates redemption data for a record in the dbo.Award table 
      based on the Award_ID

<Modification History>
12/08/2006 Jerry: Initial Entry
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/
    BEGIN

        SET NOCOUNT ON	

        UPDATE
            dbo.Award
        SET
            RedeemedOn = @RedeemedOn
           ,RedemptionLocation = @RedemptionLocation
           ,RedemptionComment = @RedemptionComment
        WHERE
            Award_ID = @Award_ID

    END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Award_S]'
GO


CREATE PROCEDURE [dbo].[Award_S] ( @Award_ID INT )
AS /*-----------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE: Award_S <Usage>

   exec Award_S (@Award_ID)
exec Award_S 1

<Modification History>
11/09/2006 Jerry: Initial Entry
11/17/2006 RonY: Changed to LEFT join to pull records back even when location is NULL
07/12/2007 Naras Added 4 new columns IsAYB_yn, AwardAmt_cur, GrossAwardAmt_cur and  Description_tx in tbl_ayb_AtYourBest
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
-----------------------------------------------------------------------------------------------------------------------------------------------*/

    BEGIN

        SET NOCOUNT ON
        
        

        SELECT
            a.Award_ID 
           ,a.Presenter_ID 
           ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
           ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
           ,a.PresenterLocation 
           ,a.Recipient_ID 
           ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
           ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
           ,a.RecipientLocation 
           ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
           ,a.Reason
           ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
           ,a.RedemptionLocation 
           ,a.RedemptionComment 
           ,a.CreatedOn 
           ,a.CreatedBy 
           ,a.UpdatedOn 
           ,a.UpdatedBy 
           ,a.IsDifferenceMaker 
           ,a.Amount 
           ,a.AmountGross 
           ,a.AwardDescription 
        FROM
            dbo.Award a
        LEFT JOIN CodesDynamic.Employee e1
        ON  a.Presenter_ID = e1.Employee_ID
        LEFT JOIN CodesDynamic.Employee e2
        ON  a.Recipient_ID = e2.Employee_ID
        WHERE
            a.Award_ID = @Award_ID
            AND a.IsActive = 1

     		 
    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Team_OfEmployee]'
GO


CREATE PROCEDURE [dbo].[Team_OfEmployee] ( @Employee_ID INT )
AS 
/*---------------------------------------------------------------------------------------------------
PROCEDURE: Team_OfEmployee <Usage>

   exec Team_OfEmployee {@Employee_ID}
   -- returns team location of requested employee

<Modification History>
10/09/2006 RonY: Initial Entry
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
---------------------------------------------------------------------------------------------------*/

    BEGIN

        SET NOCOUNT ON
        
        

        SELECT
            COALESCE(e.[TeamCostCenterName], e.[WorkLocation]) AS EmployeeTeam
        FROM
            CodesDynamic.Employee e
        WHERE
            e.Employee_ID = @Employee_ID 


    END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PaySchedule]'
GO
CREATE TABLE [dbo].[PaySchedule]
(
[PaySchedule_ID] [int] NOT NULL IDENTITY(1, 1),
[PayPeriodEndsOn] [datetime] NOT NULL,
[DateCheckOn] [datetime] NOT NULL,
[PayrollDeadlineOn] [datetime] NOT NULL,
[PayPeriod] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_dbo_PaySchedule_CreatedOn] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_dbo_PaySchedule_CreatedBy] DEFAULT (suser_sname()),
[UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_dbo_PaySchedule_UpdatedOn] DEFAULT (getdate()),
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_dbo_PaySchedule_UpdatedBy] DEFAULT (suser_sname())
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK_dbo_PaySchedule] on [dbo].[PaySchedule]'
GO
ALTER TABLE [dbo].[PaySchedule] ADD CONSTRAINT [PK_dbo_PaySchedule] PRIMARY KEY CLUSTERED  ([PaySchedule_ID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PaySchedule_OfYear]'
GO


CREATE PROCEDURE [dbo].[PaySchedule_OfYear]
/*--------------------------------------------------------------------------------------------------------------------------------
Proc		:	[dbo].[PaySchedule_OfYear]
Purpose		:	Get the PayrollDeadlineDate and PayPeriodNumber for a given year
System		:	Rewards Tracking (AYB - At your best)
Usage		:	Exec [dbo].[PaySchedule_OfYear] 2007
Author		:	Naras
Date		:	07/09/2007

Modification History

12/23/2014 Kent: Rename Proceedure and Parameters
--------------------------------------------------------------------------------------------------------------------------------*/
    @PayrollYear SMALLINT = NULL
AS
    BEGIN

		SET NOCOUNT ON
		
        IF ISNULL(@PayrollYear, 0) = 0
		BEGIN
            SELECT @PayrollYear = YEAR(GETDATE())
		END 

        SELECT
            PayrollDeadlineOn AS PayrollDeadlineDate_dt
           ,PayPeriod AS PayPeriodNumber_tx
        FROM
            dbo.PaySchedule
        WHERE
            YEAR(PayPeriodEndsOn) = @PayrollYear

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PayPeriod_OfPayrollDeadlineOn]'
GO


CREATE PROCEDURE [dbo].[PayPeriod_OfPayrollDeadlineOn]
/*--------------------------------------------------------------------------------------------------------------------------------
Proc		:	[dbo].[PayPeriod_OfPayrollDeadlineOn]
Purpose		:	Get the PayPeriodNumber for a given PayrollDeadlineDate
System		:	Rewards Tracking (AYB - At your best)
Usage		:	Exec [dbo].[PayPeriod_OfPayrollDeadlineOn] '07/02/2007 12:00AM'
Author		:	Naras
Date		:	07/05/2007

Modification History
07/09/2007 Naras Storing payroll dead line date is always be 12:00 PM noon. Bur the date calculation starts with day midnight 
				 ie day spans on 07/09/2007 00:00 to 07/09/2007 11:59 = day 07/09/2007 -

12/23/2014 Kent: Rename Proceedure and Parameters
--------------------------------------------------------------------------------------------------------------------------------*/
@PayrollDeadlineOn DATETIME

	
AS
BEGIN
SET NOCOUNT ON
	
	select top (1) PayPeriod AS PayPeriodNumber_TX
	FROM dbo.PaySchedule 
	WHERE DATEADD(hh,-12,PayrollDeadlineOn) > @PayrollDeadlineOn
		ORDER BY PayrollDeadlineOn

END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Leader_S]'
GO
SET ANSI_NULLS OFF
GO


CREATE PROCEDURE [dbo].[Leader_S] ( @Employee_ID INT )

/***********************************************************************
PROCEDURE :Leader_S
<Usage>

   exec Leader_S {@Employee_ID}
   -- Returns the name and employee id of the specified employee id

<Modification History>
2/19/2007:  Bridges - Initial Entry
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/
AS
    BEGIN
	SET NOCOUNT ON
	
        IF ( @Employee_ID = -1 )
            BEGIN
                SET @Employee_ID = ( SELECT
                                    Employee_ID
                                FROM
                                    CodesDynamic.Employee
                                WHERE
                                    Employee_ID = LeaderEmployee_ID
                              )
            END
			

        SELECT
            Employee_ID 
           ,NameDisplay AS 'Leader Name'
        FROM
            CodesDynamic.Employee
        WHERE
            Employee_ID = @Employee_ID

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Employees_OfLeaderRecursive]'
GO

CREATE FUNCTION [dbo].[Employees_OfLeaderRecursive]
    (
     @LeaderEmployee_ID INT
    ,@IsPartentIncluded BIT
    ,@IsTerminatedIncluded BIT = 0
    )
RETURNS @returnEmployeeList TABLE
    (
     Employee_ID INT
    ,LeaderEmployee_ID INT
    )
AS
    BEGIN 


/***********************************************************************
Employees_OfLeaderRecursive {@LeaderEmployee_ID}


AYB<Usage>
For the specified leader ID (@LeaderEmployee_ID), return all those who report 
to that person, and all those who report to all those who report to that person,
and so on.  This proc adapted code in an existing proc, ufn_getReports, to suit
the needs of this AYB function.

The parent bit returns the root element, if needed.
819 = kent
2245 = jeff
2660 = dennis 725 = russ
444 = dave  202 = ann
661 = doug
SELECT * FROM [Employees_OfLeaderRecursive]( 725, 1,0)
SELECT * FROM [Employees_OfLeaderRecursive]( 819, 1,0)
SELECT * FROM [Employees_OfLeaderRecursive]( 2245, 1,0)
SELECT * FROM [Employees_OfLeaderRecursive]( 2245, 0,0)  excludes jeff's record (the root)
SELECT * FROM [Employees_OfLeaderRecursive]( 2245, 1,1)  includes term records
SELECT * FROM [Employees_OfLeaderRecursive]( 2660, 1,0)

<history>
2/7/2007 BridgesJ :Adapted this proc from ufn_getReports.
7/9/2007 BridgesJ: Added functionality to send back terminated employees, or keep them hidden.
		If the flag @IsTerminatedIncluded is set to 1, this allows for awards received by terminated employees to appear on reports.
		Otherwise, only currently active employees and their awards will appear.
12/16/2014 Webbk: Converted to use CodesDynamic.Employee
***********************************************************************/
        DECLARE
            @subEmployeeID INT
           ,@subEmployee_LeaderID INT
			
		
        IF ( @IsTerminatedIncluded = 0 )
            BEGIN
	/*If the @IsTerminatedIncluded bitflag is 0, then don't allow terminated employees in the result set.
		This is the default behavior of this user-defined function.
	*/
                IF ( @IsPartentIncluded = 1 )
                    BEGIN
	
                        INSERT  INTO @returnEmployeeList
                                SELECT
                                    Employee_ID
                                   ,LeaderEmployee_ID
                                FROM
                                    CodesDynamic.Employee
                                WHERE
                                    Employee_ID = @LeaderEmployee_ID
                                    AND IsTerminated = 0 
                    END
	
	
		/*If the @LeaderEmployee_ID is -1, or if it's the same as the person's Employee_ID(Meaning it's the ceo of the company)
			Return all awards
		*/


                IF ( @LeaderEmployee_ID = -1 )
                    OR @LeaderEmployee_ID IN ( SELECT
                                            Employee_ID
                                          FROM
                                            CodesDynamic.Employee
                                          WHERE
                                            Employee_ID = LeaderEmployee_ID )
                    BEGIN
                        INSERT  INTO @returnEmployeeList
                                SELECT
                                    Employee_ID
                                   ,LeaderEmployee_ID
                                FROM
                                    CodesDynamic.Employee
                                WHERE
                                    IsTerminated = 0
                                    AND Employee_ID <> LeaderEmployee_ID
                    END
                ELSE
                    BEGIN
		/*Otherwise, run through the entire chain of employees from the leader supplied, on down.
		*/
			
			
		
                        DECLARE Retrieval CURSOR STATIC LOCAL READ_ONLY FORWARD_ONLY
                        FOR
                            SELECT
                                Employee_ID
                               ,LeaderEmployee_ID
                            FROM
                                CodesDynamic.Employee
                            WHERE
                                LeaderEmployee_ID = @LeaderEmployee_ID
                                AND IsTerminated = 0
                            ORDER BY
                                LeaderEmployee_ID
                               ,Employee_ID
                        OPEN Retrieval
			
                        FETCH NEXT FROM Retrieval
			INTO @subEmployeeID, @subEmployee_LeaderID
                        WHILE ( @@FETCH_STATUS = 0 )
                            BEGIN
                                IF ( @subEmployeeID <> @subEmployee_LeaderID )
				/* if the person's supervisor is his/herself(Meaning they are the CEO), it will cause an infinite loop, because the function can't find a root element.. */
                                    BEGIN			
		
                                        INSERT  INTO @returnEmployeeList
                                                SELECT
                                                    Employee_ID
                                                   ,LeaderEmployee_ID
                                                FROM
                                                    dbo.[Employees_OfLeaderRecursive](@subEmployeeID,
                                                              0,
                                                              @IsTerminatedIncluded)
						
                                        INSERT  INTO @returnEmployeeList
                                        VALUES
                                                ( @subEmployeeID,
                                                  @subEmployee_LeaderID )
                                    END
	
                                FETCH NEXT FROM Retrieval
				INTO @subEmployeeID, @subEmployee_LeaderID
				
		
                            END
		
                        CLOSE Retrieval
                        DEALLOCATE Retrieval

                    END
	
            END
        ELSE
            BEGIN
	/*otherwise, if the @IsTerminatedIncluded bitflag is 1, then return every employee, whether they are active or terminated. */
                IF ( @IsPartentIncluded = 1 )
                    BEGIN
	

                        INSERT  INTO @returnEmployeeList
                                SELECT
                                    Employee_ID
                                   ,LeaderEmployee_ID
                                FROM
                                    CodesDynamic.Employee
                                WHERE
                                    Employee_ID = @LeaderEmployee_ID
                    END
	
	
		--If the LeaderEmployee_ID is -1, or if it's the same as the person's Employee_ID(Meaning it's the ceo of the company) Return all awards
                IF ( @LeaderEmployee_ID = -1 )
                    OR @LeaderEmployee_ID IN ( SELECT
                                            Employee_ID
                                          FROM
                                            CodesDynamic.Employee
                                          WHERE
                                            Employee_ID = LeaderEmployee_ID )
                    BEGIN
                        INSERT  INTO @returnEmployeeList
                                SELECT
                                    Employee_ID
                                   ,LeaderEmployee_ID
                                FROM
                                    CodesDynamic.Employee
                                WHERE
                                    Employee_ID <> LeaderEmployee_ID
                    END
                ELSE
                    BEGIN
		--Otherwise, run through the entire chain of employees from the leader supplied, on down.
		

                        DECLARE Retrieval CURSOR STATIC LOCAL
                        FOR
                            SELECT
                                Employee_ID
                               ,LeaderEmployee_ID
                            FROM
                                CodesDynamic.Employee
                            WHERE
                                LeaderEmployee_ID = @LeaderEmployee_ID
                            ORDER BY
                                LeaderEmployee_ID
                               ,Employee_ID		
                        OPEN Retrieval
			
                        FETCH NEXT FROM Retrieval
			INTO @subEmployeeID, @subEmployee_LeaderID
                        WHILE ( @@FETCH_STATUS = 0 )
                            BEGIN
                                IF ( @subEmployeeID <> @subEmployee_LeaderID )
				--if the person's supervisor is his/herself(Meaning they are the CEO), it will cause an infinite loop, because the function can't find a root element.. 
                                    BEGIN			
		
                                        INSERT  INTO @returnEmployeeList
                                                SELECT
                                                    Employee_ID
                                                   ,LeaderEmployee_ID
                                                FROM
                                                    dbo.[Employees_OfLeaderRecursive](@subEmployeeID,
                                                              0,
                                                              @IsTerminatedIncluded)
						
                                        INSERT  INTO @returnEmployeeList
                                        VALUES
                                                ( @subEmployeeID,
                                                  @subEmployee_LeaderID )
                                    END
	
                                FETCH NEXT FROM Retrieval
				INTO @subEmployeeID, @subEmployee_LeaderID
				
		
                            END
		
                        CLOSE Retrieval
                        DEALLOCATE Retrieval
                    END
	

            END
	
        RETURN

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Employees_OfLeader]'
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Employees_OfLeader]
    (
     @LeaderEmployee_ID INT
    )
AS /***********************************************************************
PROCEDURE: dbo.Employees_OfLeader
<Usage>

   exec Employees_OfLeader {@LeaderEmployee_ID}
   -- returns all emloyees that employees that report to that leader,
	and everyone that reports to those people.

The parent bit returns the root element, if needed.

<Modification History>
02/08/2007: Bridges : Initial Entry
07/09/2007: Bridges: Added 0 to the function call of Employees_OfLeaderRecursive to let the function know not to return terminated employees in this list.
			That's because this only returns the list of employees, so we don't want terminated ones.  Other functions return awards as oppsed to the employees themselves,
			So they will need to take advantage of this capability.
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters, 
			eliminated self join to Employee table, since the Leader Name is already on the row.
			Remove AS alias in the result set
***********************************************************************/

    BEGIN

        SET NOCOUNT ON
        
        

        BEGIN
            SELECT
                empList.Employee_ID
               ,e.NameDisplay
               ,e.LeaderEmployee_ID
               ,e.LeaderDisplayName
            FROM
                CodesDynamic.Employee e
            INNER JOIN dbo.Employees_OfLeaderRecursive(@LeaderEmployee_ID, 0,
                                                       0) empList
            ON  e.Employee_ID = empList.Employee_ID
            ORDER BY
                empList.LeaderEmployee_ID ASC
        END


    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Employee_HasNetworkID]'
GO


CREATE PROCEDURE [dbo].[Employee_HasNetworkID]
    (
     @NetworkID VARCHAR(50)
    )
AS /*---------------------------------------------------------------------------------------------------------------------------
PROCEDURE: Employee_HasNetworkID 
<Usage>

   exec Employee_HasNetworkID {@NetworkID}
   -- returns employee seed value by network id

<Modification History>
11/21/2006 RonY: Initial Entry
07/10/2007 Naras IsLeader_yn column added to find whether the Employee is leader or not 
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
---------------------------------------------------------------------------------------------------------------------------*/

    BEGIN

        SET NOCOUNT ON
        
        

        SELECT
            Employee_ID 
           ,NameDisplay 
           ,IsSupervisor
        FROM
            CodesDynamic.Employee
        WHERE
            NetworkId = @NetworkID
        

         

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_TeamRedeemedDuringPeriod]'
GO


CREATE PROCEDURE [dbo].[Awards_TeamRedeemedDuringPeriod]
    (
     @LeaderEmployee_ID INT
    ,@StartingOn DATETIME = 0
    ,@EndingOn DATETIME = 0
    )

/***********************************************************************
PROCEDURE: Awards_TeamRedeemedDuringPeriod 
<Usage>

   exec Awards_TeamRedeemedDuringPeriod  {@LeaderEmployee_ID, @StartDate, @EndDate}
   -- if @Employee_ID is -1, returns all records
   -- otherwise, returns just the record identified

<Modification History>
03/19/2007 Bridges: Initial Entry
04/09/2007 Bridges: Changed Date Presented and Date Redeemed fields to varchar to remove possibility of truncating data.
04/09/2007 Ken : changed RedemptionComments_TX from varchar(50) to varchar(3000) to match the data 
                    type of the column from which it's pulled (tbl_ayb_atyourbest.RedemptionComments_TX)
07/09/2007 Bridges: Applied Ken Johnson's redesign of stored procedure to increase speed and stability.
			Also, added 1 to the function call of Employees_OfLeaderRecursive in the @allowtermed field,
			 in order to allow for awards received by users that have been terminated to be returned in the result set.
			Finally. the @Parent flag(the second parameter in the Employees_OfLeaderRecursive function call) was set to 1, to return the awards information
			of the person who's employee ID was submitted as well.
07/13/2007 Naras Added two columns Amount and Description
                 Modified where condition to DateRedeemed_dt instead of datePrestented_dt
                 Money column changed into decimal two places
07/17/2007 Naras Changed current date check with redeemed instead of prestented
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/
AS
    BEGIN

        SET NOCOUNT ON

        SELECT DISTINCT
            Award_ID 
           ,Presenter
           ,PresenterTeam
           ,PresenterLocation
           ,Recipient
           ,RecipientTeam
           ,RecipientLocation
           ,PresentedOn
           ,Reason
           ,RedeemedOn
           ,RedemptionLocation
           ,RedemptionComment
           ,Amount
		   ,AmountGross
           ,AwardDescription
        FROM
            ( SELECT DISTINCT
                a.Award_ID
               ,a.Presenter_ID
               ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
               ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
               ,a.PresenterLocation
               ,a.Recipient_ID
               ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
               ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
               ,a.RecipientLocation
               ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
               ,a.Reason
               ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
               ,a.RedemptionLocation
               ,a.RedemptionComment
               ,CONVERT(DECIMAL(17, 2), a.Amount) AS Amount
               ,CONVERT(DECIMAL(17, 2), a.AmountGross) AS AmountGross
               ,a.AwardDescription
               ,a.CreatedOn
               ,a.CreatedBy
               ,a.UpdatedOn
               ,a.UpdatedBy
              FROM
               dbo.Award a
              LEFT JOIN CodesDynamic.Employee e1
              ON
                a.Presenter_ID = e1.Employee_ID
              LEFT JOIN CodesDynamic.Employee e2
              ON
                a.Recipient_ID = e2.Employee_ID
              INNER JOIN Employees_OfLeaderRecursive(@LeaderEmployee_ID, 1,
                                                           1) AS EmployeeList
              ON
                EmployeeList.Employee_ID = a.Recipient_ID
              WHERE
                ( ( a.RedeemedOn IS NOT NULL )
                  AND ( CONVERT(CHAR(11), GETDATE(), 112) >= CONVERT(CHAR(11), a.RedeemedOn, 112) )
                )
                AND ( ( a.RedeemedOn BETWEEN @StartingOn AND @EndingOn )
                      OR ( @StartingOn = 0
                           AND @EndingOn = 0
                         )
                    )
                AND ( a.IsActive = 1 )
            ) AS source
        ORDER BY
            Award_ID DESC

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_TeamReceivedDuringPeriod]'
GO


CREATE  PROCEDURE [dbo].[Awards_TeamReceivedDuringPeriod]
    (
     @LeaderEmployee_ID INT
    ,@StartingOn DATETIME = 0
    ,@EndingOn DATETIME = 0
    )

/***********************************************************************
PROCEDURE: Awards_TeamReceivedDuringPeriod 
<Usage>

   exec Awards_TeamReceivedDuringPeriod {@LeaderEmployee_ID, @StartDate, @EndDate}
   -- if @Employee_ID is -1, returns all records
   -- otherwise, returns just the record identified

<Modification History>
11/17/2006 RonY: Initial Entry
02/01/2007 Bridges: Added Functionality for returning based on a certain start and end date
04/09/2007 Bridges: Changed date presented and date redeemed to varchar to remove possibility of truncating data.
04/09/2007 Ken : changed RedemptionComments_TX from varchar(50) to varchar(3000) to match the data 
                    type of the column from which it's pulled (tbl_ayb_atyourbest.RedemptionComments_TX)
07/09/2007 Bridges: Applied Ken Johnson's redesign of stored procedure to increase speed and stability.
			Also, added 1 to the function call of Employees_OfLeaderRecursive in the @allowtermed field,
			 in order to allow for awards received by users that have been terminated to be returned in the result set.
			Finally. the @Parent flag(the second parameter in the Employees_OfLeaderRecursive function call) was set to 1, to return the awards information
			of the person who's employee ID was submitted as well.
07/13/2007 Naras Added two columns Amount and Description
			Money column changed into decimal two places

12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/
AS
    BEGIN

        SET NOCOUNT ON

        SELECT DISTINCT
            Award_ID 
           ,Presenter
           ,PresenterTeam
           ,PresenterLocation
           ,Recipient
           ,RecipientTeam
           ,RecipientLocation
           ,PresentedOn
           ,Reason
           ,RedeemedOn
           ,RedemptionLocation
           ,RedemptionComment
           ,Amount
		   ,AmountGross
           ,AwardDescription
        FROM
            ( SELECT DISTINCT
                a.Award_ID
               ,a.Presenter_ID
               ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
               ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
               ,a.PresenterLocation
               ,a.Recipient_ID
               ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
               ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
               ,a.RecipientLocation
               ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
               ,a.Reason
               ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
               ,a.RedemptionLocation
               ,a.RedemptionComment
               ,CONVERT(DECIMAL(17, 2), a.Amount) AS Amount
               ,CONVERT(DECIMAL(17, 2), a.AmountGross) AS AmountGross
               ,a.AwardDescription
               ,a.CreatedOn
               ,a.CreatedBy
               ,a.UpdatedOn
               ,a.UpdatedBy
              FROM
               dbo.Award a
              LEFT JOIN CodesDynamic.Employee e1
              ON
                a.Presenter_ID = e1.Employee_ID
              LEFT JOIN CodesDynamic.Employee e2
              ON
                a.Recipient_ID = e2.Employee_ID
              INNER JOIN Employees_OfLeaderRecursive(@LeaderEmployee_ID, 1,
                                                           1) AS EmployeeList
              ON
                EmployeeList.Employee_ID = a.Recipient_ID
              WHERE
                ( ( CONVERT(CHAR(11), GETDATE(), 112) >= CONVERT(CHAR(11), a.PresentedOn, 112) ) )
                AND ( ( a.PresentedOn BETWEEN @StartingOn AND @EndingOn )
                      OR ( @StartingOn = 0
                           AND @EndingOn = 0
                         )
                    )
                AND ( a.IsActive = 1 )
            ) AS Source
        ORDER BY
            Award_ID DESC


    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_TeamPresentedDuringPeriod]'
GO



CREATE  PROCEDURE [dbo].[Awards_TeamPresentedDuringPeriod]
    (
     @LeaderEmployee_ID INT
    ,@StartingOn DATETIME = 0
    ,@EndingOn DATETIME = 0
    )

/***********************************************************************
PROCEDURE: Awards_TeamPresentedDuringPeriod <Usage>

   exec Awards_TeamPresentedDuringPeriod 1948,'09/25/2006','09/25/2006'
   {@LeaderEmployee_ID, @StartDate, @EndDate}
   -- if @Employee_ID is -1, returns all records
   -- otherwise, returns just the record identified

<Modification History>
11/17/2006 RonY: Initial Entry
02/01/2007 Bridges: Added Functionality for returning based on a certain start and end date
04/09/2007 Bridges: Changed date redeemed and date presented to varchar, to remove possibility of truncating data.
04/09/2007 Ken : changed RedemptionComment from varchar(50) to varchar(3000) to match the data 
                    type of the column from which it's pulled (Award.RedemptionComment)
07/09/2007 Bridges: Applied Ken Johnson's redesign of stored procedure to increase speed and stability.
			Also, added 1 to the function call of Employees_OfLeaderRecursive in the @allowtermed field,
			 in order to allow for awards received by users that have been terminated to be returned in the result set.
			Finally. the @Parent flag(the second parameter in the Employees_OfLeaderRecursive function call) was set to 1, to return the awards information
			of the person who's employee ID was submitted as well.
07/13/2007 Naras Added two columns Amount and Description
				  Money column changed into decimal two places
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/
AS

    BEGIN
	SET NOCOUNT ON
	
        SELECT DISTINCT
            Award_ID 
           ,Presenter
           ,PresenterTeam
           ,PresenterLocation
           ,Recipient
           ,RecipientTeam
           ,RecipientLocation
           ,PresentedOn
           ,Reason
           ,RedeemedOn
           ,RedemptionLocation
           ,RedemptionComment
           ,Amount
		   ,AmountGross
           ,AwardDescription
        FROM
            ( SELECT DISTINCT
                a.Award_ID
               ,a.Presenter_ID
               ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
               ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
               ,a.PresenterLocation
               ,a.Recipient_ID
               ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
               ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
               ,a.RecipientLocation
               ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
               ,a.Reason
               ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
               ,a.RedemptionLocation
               ,a.RedemptionComment
               ,CONVERT(DECIMAL(17, 2), a.Amount) AS Amount
               ,CONVERT(DECIMAL(17, 2), a.AmountGross) AS AmountGross
               ,a.AwardDescription
               ,a.CreatedOn
               ,a.CreatedBy
               ,a.UpdatedOn
               ,a.UpdatedBy
              FROM
               dbo.Award a
              LEFT JOIN CodesDynamic.Employee e1
              ON
                a.Presenter_ID = e1.Employee_ID
              LEFT JOIN CodesDynamic.Employee e2
              ON
                a.Recipient_ID = e2.Employee_ID
              INNER JOIN Employees_OfLeaderRecursive(@LeaderEmployee_ID, 1,
                                                           1) AS EmployeeList
              ON
                EmployeeList.Employee_ID = a.Presenter_ID
              WHERE
                ( ( a.PresentedOn BETWEEN @StartingOn AND @EndingOn )
                  OR ( @StartingOn = 0
                       AND @EndingOn = 0
                     )
                )
                AND ( a.IsActive = 1 )
            ) AS source
        ORDER BY
            Award_ID DESC



    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_RedeemedDuringPayPeriod]'
GO


CREATE  PROCEDURE [dbo].[Awards_RedeemedDuringPayPeriod]
/*--------------------------------------------------------------------------------------------------------------------------------
Proc		:	[dbo].[Awards_RedeemedDuringPayPeriod]
Purpose		:	To retrieves rewards information for a given PayPeriodNumber
Usage		:	Exec [dbo].[Awards_RedeemedDuringPayPeriod] '2007-14',0
				Exec [dbo].[Awards_RedeemedDuringPayPeriod] null,0
Author		:	Naras
Date		:	07/11/2007
Modification History
07/13/2007 Naras  Result set has been modified as per story task - TK-02224
07/17/2007 Naras  if payperiodnumber is null, get the pay period number from the current date
02/29/2008 Naras  Check IsActive =  1 - to pull only active awards
05/03/2011 Paul Setting 'Gross Amount' to 25 if IsDifferenceMaker
12/01/2014 Kent  Corrected Raise error Syntax
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
----------------------------------------------------------------------------------------------------------------------------------*/
    (
     @PayPeriod VARCHAR(7) = NULL
    ,@IsDifferenceMaker BIT
    )
AS
    BEGIN

        SET NOCOUNT ON

        DECLARE
            @PayrollEndDate_dt DATETIME
           ,@PayrollStartDate_dt DATETIME
           ,@PayPeriodEndDate_dt DATETIME
        DECLARE @PayrollDeadlineOn DATETIME

-- Get the PayPeriodNumber if it is null 
        IF @PayPeriod IS NULL
            BEGIN
                SELECT
                    @PayrollDeadlineOn = GETDATE()
	
                select top (1)
                    @PayPeriod = PayPeriod
                FROM
                    dbo.PaySchedule
                WHERE
                    DATEADD(hh, -12, PayrollDeadlineOn) > @PayrollDeadlineOn
                ORDER BY
                    PayrollDeadlineOn
            END 

-- Get the PayPeriodEndDate and date ranges for the PayPeriodNumber

        SELECT
            @PayrollEndDate_dt = PayrollDeadlineOn
           ,@PayPeriodEndDate_dt = PayPeriodEndsOn
        FROM
            dbo.PaySchedule
        WHERE
            PayPeriod = @PayPeriod

        select top (1)
            @PayrollStartDate_dt = PayrollDeadlineOn
        FROM
            dbo.PaySchedule
        WHERE
            PayrollDeadlineOn < @PayrollEndDate_dt
        ORDER BY
            PayrollDeadlineOn DESC
        IF @@rowcount = 0
            BEGIN
	
                RAISERROR('Error - There is no previous row in tbl_AYB_PaySchedule table...!',16,1)
                RETURN 1
            END

--  Since dates are stored as 12:00PM noon in PaySchedule table - make it to midnight - 00:00:00
        SELECT
            @PayrollStartDate_dt = DATEADD(hh, -12, @PayrollStartDate_dt)
           ,@PayrollEndDate_dt = DATEADD(hh, -12, @PayrollEndDate_dt)

-- Get all the details
        SELECT
            'W11 AYB' AS [Batch Name]
           ,e.NameFull AS [Employee Name]
           ,e.ClockNumber AS [Clock No]
           ,CONVERT(DECIMAL(17, 2), CASE WHEN @IsDifferenceMaker = 1 THEN 25
                                         ELSE a.AmountGross
                                    END) AS [Gross Amount]
           ,'AYBTF' AS [Payroll Code]
           ,0 AS S1
           ,0 AS S2
           ,'T' AS S3
        FROM
            dbo.Award a
        JOIN CodesDynamic.Employee e
        ON  a.Recipient_ID = e.Employee_ID
        WHERE
            a.RedeemedOn >= @PayrollStartDate_dt
            AND a.RedeemedOn < @PayrollEndDate_dt
            AND a.IsActive = 1
            AND a.IsDifferenceMaker = @IsDifferenceMaker
        ORDER BY
            e.NameFull

        
    END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_EmployeeRedeemedDuringPeriod]'
GO


CREATE  PROCEDURE [dbo].[Awards_EmployeeRedeemedDuringPeriod]
    (
     @Employee_ID INT = -1
    ,@StartingOn DATETIME = 0
    ,@EndingOn DATETIME = 0
    )
AS /***********************************************************************
PROCEDURE: Awards_EmployeeRedeemedDuringPeriod
<Usage>

   exec Awards_EmployeeRedeemedDuringPeriod {@Employee_ID}
   -- Returns rows for all redeemed awards

<Modification History>
03/19/2007 Bridges: Initial Entry
07/13/2007 Naras Added two columns Amount and Description
07/13/2007 Naras Added two columns Amount and Description
                 Modified where condition to DateRedeemed_dt instead of datePrestented_dt
                 Money column changed into decimal two places
07/17/2007 
				 Changed current date check with redeemed instead of prestented
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/

    BEGIN

        SET NOCOUNT ON
        
        

        SELECT
            a.Award_ID 
           ,a.Presenter_ID 
           ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
           ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
           ,a.PresenterLocation 
           ,a.Recipient_ID 
           ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
           ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
           ,a.RecipientLocation 
           ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
           ,a.Reason 
           ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
           ,a.RedemptionLocation 
           ,a.RedemptionComment 
           ,CONVERT(DECIMAL(17, 2), a.Amount) AS Amount
           ,CONVERT(DECIMAL(17, 2), a.AmountGross) AS AmountGross
		   ,a.AwardDescription
           ,a.CreatedOn 
           ,a.CreatedBy 
           ,a.UpdatedOn 
           ,a.UpdatedBy 
        FROM
           dbo.Award a
        LEFT JOIN CodesDynamic.Employee e1
        ON  a.Presenter_ID = e1.Employee_ID
        LEFT JOIN CodesDynamic.Employee e2
        ON  a.Recipient_ID = e2.Employee_ID
        WHERE
            ( ( a.RedeemedOn IS NOT NULL )
              AND ( ( a.Recipient_ID = @Employee_ID )
                    OR ( @Employee_ID = -1 )
                  )
              AND ( CONVERT(CHAR(11), GETDATE(), 112) >= CONVERT(CHAR(11), a.RedeemedOn, 112) )
            )
            AND ( ( a.RedeemedOn BETWEEN @StartingOn
                                 AND     @EndingOn )
                  OR ( @StartingOn = 0
                       AND @EndingOn = 0
                     )
                )
            AND ( a.IsActive = 1 )
        ORDER BY
            a.Award_ID DESC
		 
    END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_EmployeeReceivedDuringPeriod]'
GO


CREATE  PROCEDURE [dbo].[Awards_EmployeeReceivedDuringPeriod]
    (
     @Employee_ID INT = NULL
    ,@StartingOn DATETIME = 0
    ,@EndingOn DATETIME = 0
    )
AS /***********************************************************************
PROCEDURE: Awards_EmployeeReceivedDuringPeriod 
<Usage>

   exec Awards_EmployeeReceivedDuringPeriod {@Employee_ID}
   -- if @Employee_ID is -1, returns all records
   -- otherwise, returns just the record identified

<Modification History>
11/17/2006 RonY: Initial Entry
02/01/2007 Bridges: Added Functionality for returning based on a certain start and end date
03/06/2007 Bridges: Added functionality to not display data if the award is marked as inactive
07/13/2007 Naras Added two columns Amount and Description
				Money column changed into decimal two places
07/17/2007 
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/

    BEGIN

        SET NOCOUNT ON
        
        

        SELECT
            a.Award_ID 
           ,a.Presenter_ID 
           ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
           ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
           ,a.PresenterLocation 
           ,a.Recipient_ID 
           ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
           ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
           ,a.RecipientLocation 
           ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
           ,a.Reason 
           ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
           ,a.RedemptionLocation 
           ,a.RedemptionComment 
           ,CONVERT(DECIMAL(17, 2), a.Amount) AS Amount
           ,CONVERT(DECIMAL(17, 2), a.AmountGross) AS AmountGross
		   ,a.AwardDescription
           ,a.CreatedOn 
           ,a.CreatedBy 
           ,a.UpdatedOn 
           ,a.UpdatedBy 
        FROM
           dbo.Award a
        LEFT JOIN CodesDynamic.Employee e1
        ON  a.Presenter_ID = e1.Employee_ID
        LEFT JOIN CodesDynamic.Employee e2
        ON  a.Recipient_ID = e2.Employee_ID
        WHERE
            ( ( ( a.Recipient_ID = @Employee_ID )
                OR ( @Employee_ID = -1 )
              )
              AND ( CONVERT(CHAR(11), GETDATE(), 112) >= CONVERT(CHAR(11), a.PresentedOn, 112) )
            )
            AND ( ( a.PresentedOn BETWEEN @StartingOn AND @EndingOn )
                  OR ( @StartingOn = 0
                       AND @EndingOn = 0
                     )
                )
            AND ( a.IsActive = 1 )
        ORDER BY
            a.Award_ID DESC

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_EmployeeReceived]'
GO


CREATE  PROCEDURE [dbo].Awards_EmployeeReceived ( @Employee_ID INT = -1 )
AS /*----------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE: Awards_EmployeeReceived <Usage>

   exec Awards_EmployeeReceived {@Employee_ID}
   -- if @Employee_ID is -1, returns all records
   -- otherwise, returns just the record identified
   -- exec Awards_EmployeeReceived 1948

<Modification History>
10/09/2006 RonY: Initial Entry
07/12/2007 Naras Added 4 new columns 
           ,a.IsDifferenceMaker 
           ,a.Amount 
           ,a.AmountGross 
           ,a.AwardDescription 
12/16/2015 Webbk: Refactored to use CodesDynamic.Employee
12/23/2014 WebbK: Rename Proceedure and Parameters
------------------------------------------------------------------------------------------------------------------------------------------------*/

    BEGIN

        SET NOCOUNT ON
        
        

        SELECT
            a.Award_ID 
           ,a.Presenter_ID 
           ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
           ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
           ,a.PresenterLocation 
           ,a.Recipient_ID 
           ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
           ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
           ,a.RecipientLocation 
           ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
           ,a.Reason 
           ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
           ,a.RedemptionLocation 
           ,a.RedemptionComment 
           ,a.CreatedOn 
           ,a.CreatedBy 
           ,a.UpdatedOn 
           ,a.UpdatedBy 
           ,a.IsDifferenceMaker 
           ,a.Amount 
           ,a.AmountGross 
           ,a.AwardDescription 
        FROM
           dbo.Award a
        LEFT JOIN CodesDynamic.Employee e1
        ON  a.Presenter_ID = e1.Employee_ID
        LEFT JOIN CodesDynamic.Employee e2
        ON  a.Recipient_ID = e2.Employee_ID
        WHERE
            ( ( a.Recipient_ID = @Employee_ID )
              OR ( @Employee_ID = -1 )
            )
            AND ( a.IsActive = 1 )
        ORDER BY
            a.Award_ID

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_EmployeePresentedDuringPeriod]'
GO


CREATE PROCEDURE [dbo].[Awards_EmployeePresentedDuringPeriod]
    (
     @Employee_ID INT = NULL
    ,@StartingOn DATETIME = 0
    ,@EndingOn DATETIME = 0
    )
AS /***********************************************************************
PROCEDURE: Awards_EmployeePresentedDuringPeriod <Usage>

   exec Awards_EmployeePresentedDuringPeriod {@Employee_ID}
   -- if @Employee_ID is -1, returns all records
   -- otherwise, returns just the record identified

<Modification History>
11/17/2006 RonY: Initial Entry
02/01/2007 Bridges: Added Functionality for returning based on a certain start and end date
03/06/2007 Bridges: Added functionality to not display data if the award is marked as inactive
07/13/2007 Naras Added two columns Amount and Description
                 Money column changed into decimal two places

12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/

    BEGIN

        SET NOCOUNT ON
        
        

        SELECT
            a.Award_ID 
           ,a.Presenter_ID 
           ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
           ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
           ,a.PresenterLocation 
           ,a.Recipient_ID 
           ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
           ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
           ,a.RecipientLocation 
           ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
           ,a.Reason 
           ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
           ,a.RedemptionLocation 
           ,a.RedemptionComment 
           ,CONVERT(DECIMAL(17, 2), a.Amount) AS Amount
           ,CONVERT(DECIMAL(17, 2), a.AmountGross) AS AmountGross
		   ,a.AwardDescription
           ,a.CreatedOn 
           ,a.CreatedBy 
           ,a.UpdatedOn 
           ,a.UpdatedBy 
        FROM
           dbo.Award a
        LEFT JOIN CodesDynamic.Employee e1
        ON  a.Presenter_ID = e1.Employee_ID
        LEFT JOIN CodesDynamic.Employee e2
        ON  a.Recipient_ID = e2.Employee_ID
        WHERE
            ( ( a.Presenter_ID = @Employee_ID )
              OR ( @Employee_ID = -1 )
            )
            AND ( ( a.PresentedOn BETWEEN @StartingOn AND @EndingOn )
                  OR ( @StartingOn = 0
                       AND @EndingOn = 0
                     )
                )
            AND ( a.IsActive = 1 )
        ORDER BY
            a.Award_ID DESC

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_EmployeeHasNotRedeemedDuringPeriod]'
GO


CREATE PROCEDURE [dbo].[Awards_EmployeeHasNotRedeemedDuringPeriod]
    (
     @Employee_ID INT = NULL
    ,@StartingOn DATETIME = 0
    ,@EndingOn DATETIME = 0
    )
AS /***********************************************************************
PROCEDURE: Awards_EmployeeHasNotRedeemedDuringPeriod <Usage>

   exec Awards_EmployeeHasNotRedeemedDuringPeriod {@Employee_ID}
   -- Returns rows for all non-redeemed awards

<Modification History>
11/17/2006 RonY: Initial Entry
02/01/2007 Bridges: Added Functionality for returning based on a certain start and end date
03/06/2007 Bridges: Added functionality to not display data if the award is marked as inactive
07/13/2007 Naras Added two columns Amount and Description
				Money column changed into decimal two places
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/

    BEGIN

        SET NOCOUNT ON
        
        

        SELECT
            a.Award_ID 
           ,a.Presenter_ID 
           ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
           ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
           ,a.PresenterLocation 
           ,a.Recipient_ID 
           ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
           ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
           ,a.RecipientLocation 
           ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
           ,a.Reason 
           ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
           ,a.RedemptionLocation 
           ,a.RedemptionComment 
           ,CONVERT(DECIMAL(17, 2), a.Amount) AS Amount
           ,CONVERT(DECIMAL(17, 2), a.AmountGross) AS AmountGross
		   ,a.AwardDescription
           ,a.CreatedOn 
           ,a.CreatedBy 
           ,a.UpdatedOn 
           ,a.UpdatedBy 
        FROM
            dbo.Award a
        LEFT JOIN CodesDynamic.Employee e1
        ON  a.Presenter_ID = e1.Employee_ID
        LEFT JOIN CodesDynamic.Employee e2
        ON  a.Recipient_ID = e2.Employee_ID
        WHERE
            ( ( a.RedeemedOn IS NULL )
              AND ( ( a.Recipient_ID = @Employee_ID )
                    OR ( @Employee_ID = -1 )
                  )
              AND ( CONVERT(CHAR(11), GETDATE(), 112) >= CONVERT(CHAR(11), a.PresentedOn, 112) )
            )
            AND ( ( a.PresentedOn BETWEEN @StartingOn AND @EndingOn )
                  OR ( @StartingOn = 0
                       AND @EndingOn = 0
                     )
                )
            AND ( a.IsActive = 1 )
        ORDER BY
            a.Award_ID DESC
		 
    END





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Leader_OfEmployee]'
GO


CREATE PROCEDURE [dbo].[Leader_OfEmployee] ( @Employee_ID INT )

/***********************************************************************
PROCEDURE:	Leader_OfEmployee

<Description>
Gets the supervisor for a specific employee ID.<Usage>

   exec Leader_OfEmployee 99

<Modification History>
7/13/2007:	Initial creation - 
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/
AS
    BEGIN
		SET NOCOUNT ON
		
        SELECT
            LeaderEmployee_ID 
           ,LeaderDisplayName 
           ,LeaderEmail 
        FROM
            CodesDynamic.Employee
        WHERE
            Employee_ID = @Employee_ID

    END



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[ufn_GetSubEmployeesByLeader_EmpSV]'
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[ufn_GetSubEmployeesByLeader_EmpSV] 
(@Leader_EmpSV int, 
@parent bit,
@allowtermed_YN bit = 0)
RETURNS @retAYBstuff TABLE(EmployeeID int, LeaderID int)

 AS  
BEGIN 

/***********************************************************************
ufn_GetSubEmployeesByLeader_EmpSV {@Leader_EmpSV}

<system>
AYB

<usage>
For the specified leader ID (Leader_EmpSV), return all those who report 
to that person, and all those who report to all those who report to that person,
and so on.  This proc adapted code in an existing proc, ufn_getReports, to suit
the needs of this AYB function.

The parent bit returns the root element, if needed.
819 = kent
2245 = jeff
2660 = dennis 725 = russ
444 = dave  202 = ann
661 = doug
SELECT * FROM ufn_GetSubEmployeesByLeader_EmpSV( 725, 1,0)
SELECT * FROM ufn_GetSubEmployeesByLeader_EmpSV( 819, 1,0)
SELECT * FROM ufn_GetSubEmployeesByLeader_EmpSV( 2245, 1,0)
SELECT * FROM ufn_GetSubEmployeesByLeader_EmpSV( 2245, 0,0)  excludes jeff's record (the root)
SELECT * FROM ufn_GetSubEmployeesByLeader_EmpSV( 2245, 1,1)  includes term records
SELECT * FROM ufn_GetSubEmployeesByLeader_EmpSV( 2660, 1,0)

<history>
2/7/2007 BridgesJ :Adapted this proc from ufn_getReports.
7/9/2007 BridgesJ: Added functionality to send back terminated employees, or keep them hidden.
		If the flag @allowtermed_YN is set to 1, this allows for awards received by terminated employees to appear on reports.
		Otherwise, only currently active employees and their awards will appear.
12/16/2014 Webbk: Converted to use CodesDynamic.Employee
***********************************************************************/
DECLARE @subEmployeeID int, @subEmployee_LeaderID int
			
		
	IF (@allowtermed_YN = 0)
	BEGIN
	/*If the @Allowtermed_YN bitflag is 0, then don't allow terminated employees in the result set.
		This is the default behavior of this user-defined function.
	*/
		If (@parent = 1)
			BEGIN
	
                --INSERT  INTO @retAYBstuff
                --        SELECT
                --            Emp_SV
                --           ,Supervisor_RLK
                --        FROM
                --            emp_Employees
                --        WHERE
                --            Emp_SV = @Leader_EmpSV
                --            AND Status_TX <> 'TERM'


             INSERT  INTO @retAYBstuff
                        SELECT
                            Employee_ID
                           ,LeaderEmployee_ID
                        FROM
                            CodesDynamic.Employee
                        WHERE
                            Employee_ID = @Leader_EmpSV
                            AND IsTerminated = 0 
			END
	
	
		/*If the leader_EmpSV is -1, or if it's the same as the person's Emp_SV(Meaning it's the ceo of the company)
			Return all awards
		*/
		--IF (@Leader_EmpSV = -1)
		--	OR @Leader_EmpSV IN
		--		(SELECT Emp_SV
		--		FROM Emp_Employees
		--		WHERE Emp_SV = supervisor_rlk)

		IF (@Leader_EmpSV = -1)
			OR @Leader_EmpSV IN
				(SELECT Employee_ID
				FROM CodesDynamic.Employee
				WHERE Employee_ID = LeaderEmployee_ID)
		BEGIN
			--INSERT INTO @retAYBStuff
			--SELECT Emp_SV, supervisor_rlk
			--FROM Emp_Employees
			--WHERE Status_TX <> 'TERM'
			--	AND Emp_SV <> supervisor_rlk
			INSERT INTO @retAYBStuff
			SELECT Employee_ID ,LeaderEmployee_ID
			FROM CodesDynamic.Employee
			WHERE IsTerminated = 0 
				AND Employee_ID <> LeaderEmployee_ID
		END
		ELSE
		BEGIN
		/*Otherwise, run through the entire chain of employees from the leader supplied, on down.
		*/
			--DECLARE @subEmployeeID int, @subEmployee_LeaderID int
			
		
			DECLARE Retrieval CURSOR STATIC LOCAL FOR
				--SELECT Emp_SV, Supervisor_RLK
				--FROM Emp_Employees
				--WHERE supervisor_RLK = @Leader_EmpSV
				--AND Status_TX <> 'TERM'
				--ORDER BY Supervisor_RLK, Emp_SV
			SELECT Employee_ID ,LeaderEmployee_ID
			FROM CodesDynamic.Employee
				WHERE LeaderEmployee_ID = @Leader_EmpSV
				AND IsTerminated = 0 
				ORDER BY LeaderEmployee_ID, Employee_ID
			OPEN Retrieval
			
			FETCH NEXT FROM Retrieval
			INTO @subEmployeeID, @subEmployee_LeaderID
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				IF (@subEmployeeID <> @subEmployee_LeaderID)
				/* if the person's supervisor is his/herself(Meaning they are the CEO), it will cause an infinite loop, because the function can't find a root element.. */
					BEGIN			
		
						INSERT INTO @retAYBStuff
						SELECT EmployeeID, LeaderID FROM dbo.ufn_GetSubEmployeesByLeader_EmpSV (@subEmployeeID, 0, @allowtermed_YN)
						
						INSERT INTO @retAYBStuff
						VALUES(@subEmployeeID, @subEmployee_LeaderID)
					END
	
				FETCH NEXT FROM Retrieval
				INTO @subEmployeeID, @subEmployee_LeaderID
				
		
			END
		
			CLOSE Retrieval
			DEALLOCATE Retrieval

		END
	
	END
	ELSE
	BEGIN
	/*otherwise, if the @allowtermed_yn bitflag is 1, then return every employee, whether they are active or terminated. */
		If (@parent = 1)
			BEGIN
	
				--INSERT INTO @retAYBStuff
				--SELECT Emp_SV, supervisor_rlk
				--FROM Emp_Employees
				--WHERE Emp_SV = @Leader_EmpSV
				INSERT INTO @retAYBStuff
			SELECT Employee_ID ,LeaderEmployee_ID
			FROM CodesDynamic.Employee
				WHERE Employee_ID = @Leader_EmpSV
			END
	
	
		/*If the leader_EmpSV is -1, or if it's the same as the person's Emp_SV(Meaning it's the ceo of the company)
			Return all awards
		*/
		IF (@Leader_EmpSV = -1)
			OR @Leader_EmpSV IN
				--(SELECT Emp_SV
				--FROM Emp_Employees
				--WHERE Emp_SV = supervisor_rlk)
				(SELECT Employee_ID
				FROM CodesDynamic.Employee
				WHERE Employee_ID = LeaderEmployee_ID)
		BEGIN
			INSERT INTO @retAYBStuff
			--SELECT Emp_SV, supervisor_rlk
			--FROM Emp_Employees
			--WHERE  Emp_SV <> supervisor_rlk
			SELECT Employee_ID, LeaderEmployee_ID
			FROM CodesDynamic.Employee
			WHERE  Employee_ID <> LeaderEmployee_ID
		END
		ELSE
		BEGIN
		/*Otherwise, run through the entire chain of employees from the leader supplied, on down.
		*/
		--	DECLARE @subEmployeeID int, @subEmployee_LeaderID int
			
		

			DECLARE Retrieval CURSOR STATIC LOCAL FOR
				--SELECT Emp_SV, Supervisor_RLK
				--FROM Emp_Employees
				--WHERE supervisor_RLK = @Leader_EmpSV
				--ORDER BY Supervisor_RLK, Emp_SV
			SELECT Employee_ID, LeaderEmployee_ID
			FROM CodesDynamic.Employee
				WHERE LeaderEmployee_ID = @Leader_EmpSV
				ORDER BY LeaderEmployee_ID, Employee_ID		
			OPEN Retrieval
			
			FETCH NEXT FROM Retrieval
			INTO @subEmployeeID, @subEmployee_LeaderID
			WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				IF (@subEmployeeID <> @subEmployee_LeaderID)
				/* if the person's supervisor is his/herself(Meaning they are the CEO), it will cause an infinite loop, because the function can't find a root element.. */
					BEGIN			
		
						INSERT INTO @retAYBStuff
						SELECT EmployeeID, LeaderID FROM dbo.ufn_GetSubEmployeesByLeader_EmpSV (@subEmployeeID, 0, @allowtermed_YN)
						
						INSERT INTO @retAYBStuff
						VALUES(@subEmployeeID, @subEmployee_LeaderID)
					END
	
				FETCH NEXT FROM Retrieval
				INTO @subEmployeeID, @subEmployee_LeaderID
				
		
			END
		
			CLOSE Retrieval
			DEALLOCATE Retrieval
		END
	

	END
	
	RETURN

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Awards_TeamHasNotRedeemedDuringPeriod]'
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Awards_TeamHasNotRedeemedDuringPeriod]
    (
     @LeaderEmployee_ID INT
    ,@StartingOn DATETIME = 0
    ,@EndingOn DATETIME = 0
    )

/***********************************************************************
PROCEDURE: Awards_TeamHasNotRedeemedDuringPeriod 

<System>
At Your Best Tracking System

<Usage>

   exec Awards_TeamHasNotRedeemedDuringPeriod {@Leader_Emp_SV, @StartDate, @EndDate}
   -- if @Employee_ID is -1, returns all records
   -- otherwise, returns just the record identified

<Modification History>
11/17/2006 RonY: Initial Entry
02/01/2007 Bridges: Added Functionality for returning based on a certain start and end date
04/09/2007 Bridges: Changed date redeemed and date presented fields to varchar, to remove possibility of truncating data.
04/09/2007 Ken : changed RedemptionComments_TX from varchar(50) to varchar(3000) to match the data 
                    type of the column from which it's pulled (tbl_ayb_atyourbest.RedemptionComments_TX)
07/09/2007 Bridges: Applied Ken Johnson's redesign of stored procedure to increase speed and stability.
			Also, added 1 to the function call of ufn_GetSubEmployeesByLeader_EmpSV in the @allowtermed field,
			 in order to allow for awards received by users that have been terminated to be returned in the result set.
			Finally. the @Parent flag(the second parameter in the ufn_GetSubEmployeesByLeader_EmpSV function call) was set to 1, to return the awards information
			of the person who's employee ID was submitted as well.
07/16/2007 Naras Added three columns AwardAmt_cur,GrossawardAmt_cur and Description_tx
		      	 Money column changed into decimal two places
07/17/2007 Naras Gross amt has been removed
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/
AS
    BEGIN

        SET NOCOUNT ON

        SELECT DISTINCT
            Award_ID
           ,Presenter
           ,PresenterTeam
           ,PresenterLocation
           ,Recipient
           ,RecipientTeam
           ,RecipientLocation
           ,PresentedOn
           ,Reason
           ,RedeemedOn
           ,RedemptionLocation
           ,RedemptionComment
           ,Amount
		   ,AmountGross
           ,AwardDescription
        FROM
            ( SELECT DISTINCT
                a.Award_ID
               ,a.Presenter_ID
               ,e1.NameGoesBy + ' ' + e1.NameLast AS Presenter
               ,COALESCE(e1.[TeamCostCenterName], e1.[WorkLocation]) AS PresenterTeam
               ,a.PresenterLocation
               ,a.Recipient_ID
               ,e2.NameGoesBy + ' ' + e2.NameLast AS Recipient
               ,COALESCE(e2.[TeamCostCenterName], e2.[WorkLocation]) AS RecipientTeam
               ,a.RecipientLocation
               ,CONVERT(CHAR(10), a.PresentedOn, 111) AS PresentedOn
               ,a.Reason
               ,CONVERT(CHAR(10), a.RedeemedOn, 111) AS RedeemedOn
               ,a.RedemptionLocation
               ,a.RedemptionComment
               ,CONVERT(DECIMAL(17, 2), a.Amount) AS Amount
               ,CONVERT(DECIMAL(17, 2), a.AmountGross) AS AmountGross
               ,a.AwardDescription
               ,a.CreatedOn
               ,a.CreatedBy
               ,a.UpdatedOn
               ,a.UpdatedBy
              FROM
                Award a
              LEFT JOIN CodesDynamic.Employee e1
              ON
                a.Presenter_ID = e1.Employee_ID
              LEFT JOIN CodesDynamic.Employee e2
              ON
                a.Recipient_ID = e2.Employee_ID
              INNER JOIN Employees_OfLeaderRecursive(@LeaderEmployee_ID, 1, 1)
                AS EmployeeList
              ON
                EmployeeList.Employee_ID = a.Recipient_ID
              WHERE
                ( ( a.RedeemedOn IS NULL )
                  AND ( CONVERT(CHAR(11), GETDATE(), 112) >= CONVERT(CHAR(11), PresentedOn, 112) )
                )
                AND ( ( a.PresentedOn BETWEEN @StartingOn AND @EndingOn )
                      OR ( @StartingOn = 0
                           AND @EndingOn = 0
                         )
                    )
                AND ( a.IsActive = 1 )
            ) AS source
        ORDER BY
            Award_ID DESC

    END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[PaySchedule_MinMaxOfYear]'
GO

CREATE PROCEDURE [dbo].[PaySchedule_MinMaxOfYear]
/*--------------------------------------------------------------------------------------------------------------------------------
Proc		:	[dbo].[PaySchedule_MinMaxOfYear]
Purpose		:	To get the min and max pay schedule year 
System		:	Rewards Tracking (AYB - At your best)
Author		:	Naras
Date		:	07/11/2007
Modification History

12/23/2014 Kent: Rename Proceedure and Parameters
----------------------------------------------------------------------------------------------------------------------------------*/
AS
    BEGIN
        SET NOCOUNT ON
        SELECT
            YEAR(MIN(PayPeriodEndsOn)) AS MinPayScheduleYear
           ,YEAR(MAX(PayPeriodEndsOn)) AS MaxPayScheduleYear
        FROM
            dbo.PaySchedule
        
    END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Employees_AllActive]'
GO

CREATE PROCEDURE [dbo].[Employees_AllActive]
AS /***********************************************************************
PROCEDURE: Employees_AllActive 

<System>
At Your Best Tracking System

<Usage>

   exec Employees_AllActive
   -- returns list of active employees

<Modification History>
10/09/2006 RonY: Initial Entry
10/25/2006 RonY: Changed to return first name, middle name, last name instead of full name
10/30/2006 RonY: Added NameFull_TX
11/03/2006 RonY: Change NameFull_TX to DisplayName_TX
01/17/2008 Tim :   Updated WHERE clause to omit contractors from the query results
01/03/2012 Jerry: Updated WHERE clause to omit board members from the query results
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/

    BEGIN

        SET NOCOUNT ON
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED
        SET DEADLOCK_PRIORITY LOW
		
        SELECT
            Employee_ID
           ,NameFirst
           ,NameMiddle
           ,NameLast
           ,NameDisplay
           ,NetworkId
           ,LeaderEmployee_ID
        FROM
            CodesDynamic.Employee
        WHERE
            IsTerminated = 0
            AND IsContractor = 0
            AND IsBoardDirector = 0
        ORDER BY
            NameLast
           ,NameFirst
           ,NameMiddle

    END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[Employee_Location]'
GO
/*

Function: Location_OfEmployee <Usage>
@MyLocation = Select dbo.Location_OfEmployee (@Employee_ID)
@MyLocation = Select  dbo.Location_OfEmployee (99)
returns office location of requested employee

EXEC [dbo].[Employee_Location] 1

<Modification History>
10/25/2006  RonY: Initial Entry
12/16/2015 Kent: Refactored to use CodesDynamic.Employee
12/23/2014 Kent: Rename Proceedure and Parameters
***********************************************************************/

CREATE PROCEDURE [dbo].[Employee_Location] 
(
	@Employee_ID int
)
AS
BEGIN
	SELECT [dbo].[Location_OfEmployee](@Employee_ID) AS Location
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[tbl_AYB_xpRewardTracking_DELETE]'
GO
CREATE TABLE [dbo].[tbl_AYB_xpRewardTracking_DELETE]
(
[PayPeriodNumber_tx] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsAYB_yn] [bit] NULL,
[BatchName_tx] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployeeName_tx] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClockNo_tx] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GrossAmount_cur] [money] NULL,
[PayrollCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[S1] [tinyint] NULL,
[S2] [tinyint] NULL,
[S3] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entry_dt] [datetime] NOT NULL CONSTRAINT [df_tbl_AYB_xpRewardTracking_Entry_dt] DEFAULT (getdate()),
[UserID_tx] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_tbl_AYB_xpRewardTracking_UserID_tx] DEFAULT (suser_sname())
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
