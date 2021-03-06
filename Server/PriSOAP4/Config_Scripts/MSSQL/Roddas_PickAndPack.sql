GO
/****** Object:  StoredProcedure [dbo].[ZSFDC_MarkPicked]    Script Date: 04/15/2013 09:14:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ZSFDC_MarkPicked]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[ZSFDC_MarkPicked] 
	-- Add the parameters for the stored procedure here
	@PICKREFNUM  int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF EXISTS (SELECT PICKREFNUM FROM ZTRX_PICKMONITOR WHERE PICKREFNUM  = @PICKREFNUM and TOGUN <> ''Y'')
		BEGIN
			update ZTRX_PICKMONITOR set TOGUN = ''Y'' where PICKREFNUM  = @PICKREFNUM 
			select @PICKREFNUM
		END
END

' 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SFDC_UpdatePick]    Script Date: 04/15/2013 09:14:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SFDC_UpdatePick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Andy Mackintosh
-- Create date: 03/04/2013
-- Description:	Procedure to set the ischecked flag to ''y'' after item counted
-- =============================================
Create PROCEDURE [dbo].[SP_SFDC_UpdatePick]
	@PICK AS INTEGER
AS
BEGIN
UPDATE ZROD_PICKS SET ISCHECKED = ''Y'' WHERE PICK = @PICK
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SFDC_UPDATEPACKSLIP]    Script Date: 04/15/2013 09:14:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SFDC_UPDATEPACKSLIP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[SP_SFDC_UPDATEPACKSLIP]
(
@ROUTE bigint,
@PACKSL VARCHAR
)
as
begin
UPDATE ORDERITEMS
SET ZROD_IN_PICK = ''Y''
WHERE DUEDATE = (SELECT VALUE FROM LASTS WHERE NAME = ''PICK_DATE'')
AND   ZROD_ROUTE = @ROUTE
AND   ORDI IN (SELECT ORDI FROM TRANSORDER, DOCUMENTS
WHERE DOCNO = ''@PACKSL''
AND   DOCUMENTS.TYPE = ''A''
AND   DOCUMENTS.DOC = TRANSORDER.DOC
AND   TRANSORDER.TYPE = ''A'')

end' 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SFDC_UPDATEITEMS]    Script Date: 04/15/2013 09:14:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_SFDC_UPDATEITEMS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[SP_SFDC_UPDATEITEMS]
(
@ROUTE VARCHAR
)
as
begin
UPDATE ORDERITEMS
SET ZROD_IN_PICK = ''Y''
WHERE DUEDATE = (SELECT VALUE FROM LASTS WHERE NAME = ''PICK_DATE'')
AND   ZROD_ROUTE = @ROUTE
end' 
END
GO
/****** Object:  View [dbo].[V_UncheckedRoutes]    Script Date: 04/15/2013 09:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_UncheckedRoutes]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[V_UncheckedRoutes]
AS
SELECT     FORROUTE
FROM         dbo.ZROD_PICKS
WHERE     (PICK <> 0) AND (FORDATE =
                          (SELECT     VALUE
                            FROM          dbo.LASTS
                            WHERE      (NAME = ''PICK_DATE''))) AND (ISCHECKED = ''N'')
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'V_UncheckedRoutes', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ZROD_PICKS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 4
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_UncheckedRoutes'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'V_UncheckedRoutes', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_UncheckedRoutes'
GO
/****** Object:  View [dbo].[V_UNPICKED_ROUTE]    Script Date: 04/15/2013 09:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_UNPICKED_ROUTE]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[V_UNPICKED_ROUTE]
AS
SELECT     ROUTENAME, ROUTEDES
FROM         ZROD_ROUTES
WHERE     ROUTE IN
                          (SELECT     ZROD_ROUTE
                            FROM          ORDERITEMS, ORDERS, CUSTOMERS, ORDSTATUS,ZROD_ROUTES
                            WHERE      DUEDATE =
                                                       (SELECT     VALUE
                                                         FROM          LASTS
                                                         WHERE      NAME = ''PICK_DATE'') AND TBALANCE > 0 AND ORDERITEMS.CLOSED <> ''C'' AND ORDERITEMS.ZROD_IN_PICK <> ''Y'' AND 
                                                   ORDERITEMS.ORD = ORDERS.ORD AND ORDERS.ORDSTATUS = ORDSTATUS.ORDSTATUS AND AUTODISTRIBFLAG = ''Y'' AND 
                                                   ORDERS.CUST = CUSTOMERS.CUST AND ZROD_ROUTES.ROUTE = ORDERITEMS.ZROD_ROUTE AND ZROD_ROUTES.ZROD_PICKTYPE = ''B'')
UNION ALL
SELECT     ROUTENAME, ROUTEDES
FROM         ZROD_ROUTES
WHERE     ROUTE IN
                          (SELECT     ZROD_ROUTE
                            FROM          ORDERITEMS, ORDERS, CUSTOMERS, ORDSTATUS
                            WHERE      DUEDATE =
                                                       (SELECT     VALUE
                                                         FROM          LASTS
                                                         WHERE      NAME = ''PICK_DATE'') AND TBALANCE > 0 AND ORDERITEMS.CLOSED <> ''C'' AND ORDERITEMS.ZROD_IN_PICK <> ''Y'' AND 
                                                   ORDERITEMS.ORD = ORDERS.ORD AND ORDERS.ORDSTATUS = ORDSTATUS.ORDSTATUS AND AUTODISTRIBFLAG = ''Y'' AND 
                                                   ORDERS.CUST = CUSTOMERS.CUST AND ZROD_ROUTES.ROUTE = ORDERITEMS.ZROD_ROUTE AND  ZROD_ROUTES.ZROD_PICKTYPE = ''S'' AND ORDI IN
                                                       (SELECT     ORDI
                                                         FROM          TRANSORDER
                                                         WHERE      TYPE = ''A''))
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'V_UNPICKED_ROUTE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[15] 4[8] 2[58] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_UNPICKED_ROUTE'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'V_UNPICKED_ROUTE', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_UNPICKED_ROUTE'
GO
/****** Object:  View [dbo].[V_TELESALES]    Script Date: 04/15/2013 09:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_TELESALES]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[V_TELESALES]
AS
SELECT     COUNT(*) AS [Calls Made], DATEPART(MM, dbo.MINTODATE(dbo.ZROD_TELESALECALLS.DUEDATE)) AS Month, DATEPART(DD, 
                      dbo.MINTODATE(dbo.ZROD_TELESALECALLS.DUEDATE)) AS Day, DATEPART(YYYY, dbo.MINTODATE(dbo.ZROD_TELESALECALLS.DUEDATE)) AS Year, DATEADD(dd, 
                      DATEDIFF(d, 0, dbo.MINTODATE(dbo.ZROD_TELESALECALLS.DUEDATE)), 0) AS T_Date
FROM         dbo.ZROD_TELESALECALLS CROSS JOIN
                      dbo.ZROD_CALLSTATS
WHERE     (dbo.ZROD_CALLSTATS.INITSTATFLAG <> ''Y'') AND (dbo.ZROD_TELESALECALLS.TELESALECALL <> 0)
GROUP BY dbo.ZROD_TELESALECALLS.DUEDATE
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'V_TELESALES', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ZROD_TELESALECALLS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ZROD_CALLSTATS"
            Begin Extent = 
               Top = 6
               Left = 279
               Bottom = 125
               Right = 482
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_TELESALES'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'V_TELESALES', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_TELESALES'
GO
/****** Object:  View [dbo].[V_PICK_MONITOR]    Script Date: 04/15/2013 09:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_PICK_MONITOR]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[V_PICK_MONITOR]
AS
SELECT     ORDI, ZROD_ROUTES.ROUTENAME, '''' AS PSNO, PARTNAME, SUM(TBALANCE / 1000) AS QUANT, PARTDES, dbo.PART.TYPE, FAMILY.ZROD_PICKORDER
FROM         ORDERITEMS, ORDERS, CUSTOMERS, ORDSTATUS, PART, ZROD_ROUTES, FAMILY
WHERE     DUEDATE =
                          (SELECT     VALUE
                            FROM          LASTS
                            WHERE      NAME = ''PICK_DATE'') AND TBALANCE > 0 AND ORDERITEMS.CLOSED <> ''C'' AND ZROD_ROUTES.ROUTE = ORDERITEMS.ZROD_ROUTE AND 
                      ORDERITEMS.ZROD_IN_PICK <> ''Y'' AND ORDERITEMS.ORD = ORDERS.ORD AND ORDERS.ORDSTATUS = ORDSTATUS.ORDSTATUS AND 
                      AUTODISTRIBFLAG = ''Y'' AND ORDERS.CUST = CUSTOMERS.CUST AND ZROD_ROUTES.ZROD_PICKTYPE = ''B'' AND ORDERITEMS.PART = PART.PART AND 
                      FAMILY.FAMILY = PART.FAMILY
GROUP BY ORDI, ZROD_ROUTES.ROUTENAME, PARTNAME, PARTDES, dbo.PART.TYPE, FAMILY.ZROD_PICKORDER
UNION ALL
SELECT     TRANSORDER.ORDI, ZROD_ROUTES.ROUTENAME, DOCNO AS PSNO, PARTNAME, SUM(TBALANCE / 1000) AS QUANT, PARTDES, dbo.PART.TYPE, 
                      FAMILY.ZROD_PICKORDER
FROM         ORDERITEMS, ORDERS, CUSTOMERS, ORDSTATUS, PART, DOCUMENTS, TRANSORDER, ZROD_ROUTES, FAMILY
WHERE     DUEDATE =
                          (SELECT     VALUE
                            FROM          LASTS
                            WHERE      NAME = ''PICK_DATE'') AND TBALANCE > 0 AND ORDERITEMS.CLOSED <> ''C'' AND ZROD_ROUTES.ROUTE = ORDERITEMS.ZROD_ROUTE AND 
                      ORDERITEMS.ZROD_IN_PICK <> ''Y'' AND ORDERITEMS.ORD = ORDERS.ORD AND ORDERS.ORDSTATUS = ORDSTATUS.ORDSTATUS AND 
                      AUTODISTRIBFLAG = ''Y'' AND ORDERS.CUST = CUSTOMERS.CUST AND ZROD_ROUTES.ZROD_PICKTYPE = ''S'' AND ORDERITEMS.PART = PART.PART AND 
                      FAMILY.FAMILY = PART.FAMILY AND ORDERITEMS.ORDI = TRANSORDER.ORDI AND TRANSORDER.TYPE = ''A''
GROUP BY TRANSORDER.ORDI, ZROD_ROUTES.ROUTENAME, DOCNO, PARTDES, PARTNAME, dbo.PART.TYPE, FAMILY.ZROD_PICKORDER
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'V_PICK_MONITOR', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[66] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 5
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2415
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_PICK_MONITOR'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'V_PICK_MONITOR', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_PICK_MONITOR'
GO
/****** Object:  View [dbo].[V_PICKLIST_PARTS]    Script Date: 04/15/2013 09:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_PICKLIST_PARTS]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[V_PICKLIST_PARTS]
AS
SELECT     TOP (100) PERCENT dbo.PART.PART, dbo.PART.PARTNAME, dbo.SERIAL.SERIALNAME, dbo.WARHSBAL.BALANCE / 1000 AS balance, dbo.SERIAL.EXPIRYDATE, 
                      dbo.WAREHOUSES.WARHSNAME, dbo.WAREHOUSES.LOCNAME, dbo.PART.TYPE, dbo.FAMILY.ZROD_PICKORDER, dbo.PART.PARTDES
FROM         dbo.PART INNER JOIN
                      dbo.SERIAL ON dbo.PART.PART = dbo.SERIAL.PART INNER JOIN
                      dbo.WARHSBAL ON dbo.PART.PART = dbo.WARHSBAL.PART AND dbo.SERIAL.SERIAL = dbo.WARHSBAL.SERIAL INNER JOIN
                      dbo.WAREHOUSES ON dbo.WARHSBAL.WARHS = dbo.WAREHOUSES.WARHS INNER JOIN
                      dbo.FAMILY ON dbo.PART.FAMILY = dbo.FAMILY.FAMILY
WHERE     (dbo.WARHSBAL.WARHS <> 0) AND (dbo.SERIAL.EXPIRYDATE >
                          (SELECT     VALUE
                            FROM          dbo.LASTS
                            WHERE      (NAME = ''PICK_DATE'')) OR
                      dbo.SERIAL.EXPIRYDATE = 01 / 01 / 88) AND (dbo.WARHSBAL.BALANCE > 0) AND (dbo.WAREHOUSES.ZROD_HIDEFROMPICK <> ''YES'')
ORDER BY dbo.FAMILY.ZROD_PICKORDER
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'V_PICKLIST_PARTS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4[50] 3) )"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PART"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 218
            End
            DisplayFlags = 280
            TopColumn = 38
         End
         Begin Table = "SERIAL"
            Begin Extent = 
               Top = 6
               Left = 256
               Bottom = 125
               Right = 440
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WARHSBAL"
            Begin Extent = 
               Top = 6
               Left = 478
               Bottom = 125
               Right = 638
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "WAREHOUSES"
            Begin Extent = 
               Top = 6
               Left = 676
               Bottom = 125
               Right = 890
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FAMILY"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_PICKLIST_PARTS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'dbo', N'VIEW',N'V_PICKLIST_PARTS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 7050
         Or = 1080
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_PICKLIST_PARTS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'V_PICKLIST_PARTS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_PICKLIST_PARTS'
GO
/****** Object:  View [dbo].[V_PICKEDITEMS]    Script Date: 04/15/2013 09:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V_PICKEDITEMS]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[V_PICKEDITEMS]
AS
SELECT     dbo.ZROD_PICKS.PICK, dbo.ZROD_PICKS.FORROUTE, dbo.ZROD_PICKLINE.PARTNAME, SUM(dbo.ZROD_PICKLINE.AMOUNTPICKED) / 1000 AS PICKED
FROM         dbo.ZROD_PICKS INNER JOIN
                      dbo.ZROD_PICKLINE ON dbo.ZROD_PICKS.PICK = dbo.ZROD_PICKLINE.PICK
WHERE     (dbo.ZROD_PICKS.FORDATE =
                          (SELECT     VALUE
                            FROM          dbo.LASTS
                            WHERE      (NAME = ''PICK_DATE''))) AND (dbo.ZROD_PICKS.ISCHECKED = ''N'')
GROUP BY dbo.ZROD_PICKLINE.PARTNAME, dbo.ZROD_PICKS.PICK, dbo.ZROD_PICKS.FORROUTE
'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'dbo', N'VIEW',N'V_PICKEDITEMS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ZROD_PICKS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ZROD_PICKLINE"
            Begin Extent = 
               Top = 6
               Left = 252
               Bottom = 125
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_PICKEDITEMS'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'dbo', N'VIEW',N'V_PICKEDITEMS', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_PICKEDITEMS'
GO
/****** Object:  StoredProcedure [dbo].[UpdatePick]    Script Date: 04/15/2013 09:14:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePick]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Andy Mackintosh
-- Create date: 03/04/2013
-- Description:	Procedure to set the ischecked flag to ''y'' after item counted
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePick]
	@PICK AS INTEGER
AS
BEGIN
UPDATE ZROD_PICKS SET ISCHECKED = ''Y'' WHERE PICK = @PICK
END
' 
END
GO
