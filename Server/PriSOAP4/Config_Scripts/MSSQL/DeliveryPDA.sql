GO
/****** Object:  UserDefinedFunction [dbo].[MINTODATE]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MINTODATE]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[MINTODATE]
(
	-- Add the parameters for the function here
	@MIN INT
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT @ResultVar = (DATEADD(MI, @MIN, ''19880101''))

	-- Return the result of the function
	RETURN @ResultVar

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[DATETOMIN8]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATETOMIN8]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[DATETOMIN8] 
(	
	@DT as datetime
)
RETURNS int
AS
BEGIN
		
	declare @d8 datetime 
	set @d8 = DATEADD(MI, 0, ''19880101'')
	set @d8 = (dateadd(YEAR,DATEPART(year,GETDATE()) - 1988, @d8))
	set @d8 = (dateadd(MONTH,month(@DT)-1,@d8))
	set @d8 = (dateadd(DAY,day(@DT)-1,@d8 ))

	RETURN DATEdiff(MI, ''19880101'', @d8)

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[DATETOMIN]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DATETOMIN]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[DATETOMIN] 
(
	-- Add the parameters for the function here
	@DT as datetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar as int

	-- Add the T-SQL statements to compute the return value here
	SELECT @ResultVar = (DATEdiff(MI, ''19880101'',@DT ))

	-- Return the result of the function
	RETURN @ResultVar

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_CustomerRemarks]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_CustomerRemarks]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_CustomerRemarks] ( @CUST INT )
RETURNS VARCHAR(MAX)
AS
BEGIN
   declare @html varchar(max)
   declare @result varchar(max)
   select @html = coalesce(@html + '' '','' '','''') + TEXT
   from CUSTOMERSTEXT 
   where CUST = @CUST
   and TEXTLINE > 0
   order by TEXTORD
   if (@html IS null)
		begin
			set @result = ''''
		end
	else
		begin
			SET @result = replace(replace(@html,''<'','':[''),''>'','']:'')
		end
   RETURN @result
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_CustomerPriceList]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_CustomerPriceList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_CustomerPriceList] (
-- Add the parameters for the function here
@CUST INT)
RETURNS @PL TABLE (
  -- Add the column definitions for the TABLE variable here
  name    VARCHAR(50),
  barcode VARCHAR(50),
  des     VARCHAR(50),
  tquant  numeric,
  price   money )
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @PL
      SELECT dbo.PART.PARTNAME,
             dbo.PART.BARCODE,
             dbo.PART.PARTDES,
             dbo.PARTPRICE.QUANT / 1000,
             CONVERT(MONEY, dbo.ZROD_PARTDISCAMTS.FIXEDDISC)
      FROM   dbo.ZROD_PARTDISCAMTS
             INNER JOIN dbo.PARTPRICE
                        INNER JOIN dbo.PART
                                ON dbo.PARTPRICE.PART = dbo.PART.PART
                     ON dbo.ZROD_PARTDISCAMTS.PART = dbo.PARTPRICE.PART
                        AND dbo.ZROD_PARTDISCAMTS.QTY = dbo.PARTPRICE.QUANT
      WHERE  ( dbo.PARTPRICE.PLIST = -1 )
             AND ( dbo.ZROD_PARTDISCAMTS.CUST = @CUST )
      ORDER  BY dbo.PARTPRICE.QUANT / 1000 DESC

      IF (SELECT COUNT(*)
          FROM   @PL) = 0
        BEGIN
            INSERT INTO @PL
            SELECT ''0'',
                   ''0'',
                   ''0'',
                   0,
                   0
        END

      RETURN
  END 
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_CustomerPartList]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_CustomerPartList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[pda_CustomerPartList] (
-- Add the parameters for the function here
@CUST INT)
RETURNS @PL TABLE (
  -- Add the column definitions for the TABLE variable here
  part    INT,
  family  VARCHAR(50) )
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @PL
      SELECT DISTINCT dbo.PART.PART,
             dbo.FAMILY.FAMILYDES
      FROM   dbo.INVOICES
             INNER JOIN dbo.INVOICEITEMS
                        INNER JOIN dbo.PART
							INNER JOIN dbo.FAMILY
								ON dbo.PART.FAMILY = dbo.FAMILY.FAMILY
                               ON dbo.INVOICEITEMS.PART = dbo.PART.PART
                     ON dbo.INVOICES.IV = dbo.INVOICEITEMS.IV
      WHERE  ( INVOICES.CUST = @CUST )
             AND ( dbo.INVOICES.IVDATE > dbo.DATETOMIN8(GETDATE() - 365))
      ORDER  BY FAMILYDES, dbo.PART.PART

      IF (SELECT COUNT(*)
          FROM   @PL) = 0
        BEGIN
            INSERT INTO @PL
            SELECT ''0'',
                    0
        END

      RETURN
  END 

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_CustomerDetails]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_CustomerDetails]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE  FUNCTION [dbo].[pda_CustomerDetails] (
-- Add the parameters for the function here
@PHONE INT,
@CUST INT)
RETURNS @DETAIL TABLE (
  -- Add the column definitions for the TABLE variable here
  custnumber VARCHAR(50),
  custname   VARCHAR(50),
  contact    VARCHAR(50),
  phone      VARCHAR(50),
  address    VARCHAR(50),
  address2   VARCHAR(50),
  address3   VARCHAR(50),
  address4   VARCHAR(50),
  postcode   VARCHAR(50))
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @DETAIL
		SELECT     CUSTNAME, CUSTDES, (select NAME from PHONEBOOK where PHONE = @PHONE), PHONE, ADDRESS,  ADDRESS2, ADDRESS3, STATE, ZIP
		FROM         dbo.CUSTOMERS
		WHERE CUST = @CUST
      RETURN
  END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_CustomerAccInfo]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_CustomerAccInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_CustomerAccInfo] ( @CUST INT )
RETURNS VARCHAR(MAX)
AS
BEGIN
   DECLARE @result varchar(max)
   declare @html varchar(max)
   select @html = coalesce(@html + '' '','' '','' '') + TEXT
   from ZROD_CUSTACCTTEXT 
   where CUST = @CUST
   and TEXTLINE > 0
   order by TEXTORD
   if (@html IS null)
		begin
			set @result = ''''
		end
	else
		begin
			SET @result = replace(replace(@html,''<'','':[''),''>'','']:'')
		end
   RETURN @result
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[V_ROUTE_PS]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V_ROUTE_PS]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'create function [dbo].[V_ROUTE_PS] (@route varchar)
returns table
as
return
SELECT DISTINCT DOCNO FROM DOCUMENTS, TRANSORDER
WHERE DOCUMENTS.TYPE = ''A''
AND   DOCUMENTS.DOC = TRANSORDER.DOC
AND   TRANSORDER.TYPE = ''A''
AND   TRANSORDER.TQUANT = 0
AND   ORDI IN (SELECT ORDI FROM ORDERITEMS, ORDERS, 
CUSTOMERS, ORDSTATUS
WHERE DUEDATE = (SELECT VALUE FROM LASTS WHERE NAME = ''PICK_DATE'')
AND   TBALANCE > 0
AND   TQUANT - PACKED > 0
AND   ORDERITEMS.CLOSED <> ''C''
AND   ZROD_IN_PICK <> ''Y'' /* only needed if you update the flag after this query*/
AND   ORDERITEMS.ORD = ORDERS.ORD
AND   ORDERS.ORDSTATUS = ORDSTATUS.ORDSTATUS
AND   AUTODISTRIBFLAG = ''Y''
AND   ORDERS.CUST = CUSTOMERS.CUST
AND   CUSTOMERS.ZROD_PICKTYPE = ''S''
AND   ORDERITEMS.ZROD_ROUTE = @route) 
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[REALQUANT]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REALQUANT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Si
-- Create date: 4/12/07
-- Description:	return number to divide by for shifted ints
-- =============================================
CREATE FUNCTION [dbo].[REALQUANT] 
(
@Quant int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int

	set @result = @Quant / (SELECT     POWER(10, VALUE)  
                            FROM          system.dbo.SYSCONST
                            WHERE      (NAME = ''DECIMAL''))

	-- Return the result of the function
	RETURN @result

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[QUESTIONTEXT]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QUESTIONTEXT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[QUESTIONTEXT]
(
	-- Add the parameters for the function here
	@QUESTF int,
	@QUESTNUM int

)
RETURNS varchar(max)
AS
BEGIN

	declare @question varchar(max)
	declare @text varchar(68)

	set @question = (SELECT QUESTDES 
	FROM QUESTIONS 
	WHERE QUESTNUM = @QUESTNUM AND QUESTF = @QUESTF)

	DECLARE qcur CURSOR FOR 
	select TEXT from QUESTIONSTEXT 
	where QUESTNUM = @QUESTNUM AND QUESTF =@QUESTF
	and TEXTORD > 2
	order by TEXTORD

	OPEN qcur

	FETCH NEXT FROM qcur 
	INTO @text

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		set @question = (@question + '' '' + rtrim(@text))

			-- Get the next vendor.
		FETCH NEXT FROM qcur 
		INTO @text
	END 
	CLOSE qcur
	DEALLOCATE qcur

	return @question

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[INTQUANT]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[INTQUANT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Si
-- Create date: 4/12/07
-- Description:	return number to divide by for shifted ints
-- =============================================
create FUNCTION [dbo].[INTQUANT] 
(
@Quant int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result int

	set @result = @Quant * (SELECT     POWER(10, VALUE)  
                            FROM          system.dbo.SYSCONST
                            WHERE      (NAME = ''DECIMAL''))

	-- Return the result of the function
	RETURN @result

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_ROUTE_PS]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_ROUTE_PS]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FUNC_ROUTE_PS]

(	-- Add the parameters for the function here
	@ROUTE VARCHAR(6) 
)
RETURNS VARCHAR(16)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar varchar(16)
set @ResultVar =
	(SELECT DISTINCT DOCNO FROM DOCUMENTS, TRANSORDER
WHERE DOCUMENTS.TYPE = ''A''
AND   DOCUMENTS.DOC = TRANSORDER.DOC
AND   TRANSORDER.TYPE = ''A''
AND   TRANSORDER.TQUANT = 0
AND   ORDI IN (SELECT ORDI FROM ORDERITEMS, ORDERS, 
CUSTOMERS, ORDSTATUS,ZROD_ROUTES
WHERE DUEDATE = (SELECT VALUE FROM LASTS WHERE NAME = ''PICK_DATE'')
AND   TBALANCE > 0
AND   TQUANT - PACKED > 0
AND   ORDERITEMS.CLOSED <> ''C''
AND   ZROD_IN_PICK <> ''Y'' /* only needed if you update the flag after this query*/
AND   ORDERITEMS.ORD = ORDERS.ORD
AND   ORDERS.ORDSTATUS = ORDSTATUS.ORDSTATUS
AND   AUTODISTRIBFLAG = ''Y''
AND   ORDERS.CUST = CUSTOMERS.CUST
AND   ZROD_ROUTES.ZROD_PICKTYPE = ''S''
AND   ORDERITEMS.ZROD_ROUTE = (select ROUTE from ZROD_ROUTES where ROUTENAME = @ROUTE ))
)

	RETURN ISNULL(@ResultVar,'''')

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_WhsParts]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_WhsParts]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[pda_WhsParts] 
(
	-- Add the parameters for the function here
	@WARHS int
)
RETURNS 
@whs TABLE 
(
	-- Add the column definitions for the TABLE variable here
	PART INT,
	PARTNAME VARCHAR(50),
	BARCODE VARCHAR(50)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	insert into @whs
	select 0, ''0'',''0''
	union all
	SELECT DISTINCT dbo.PART.PART, dbo.PART.PARTNAME, dbo.PART.BARCODE
	FROM         dbo.WARHSBAL INNER JOIN
						  dbo.PART ON dbo.WARHSBAL.PART = dbo.PART.PART INNER JOIN
						  dbo.FAMILY ON dbo.PART.FAMILY = dbo.FAMILY.FAMILY
	WHERE     (dbo.WARHSBAL.WARHS = @WARHS) AND (dbo.WARHSBAL.BALANCE > 0) AND (dbo.FAMILY.ZROD_PDAFLAG = ''Y'')
	RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_Survey]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_Survey]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_Survey] (
-- Add the parameters for the function here
@QUESTF INT,
 @QGROUP INT)
RETURNS XML
AS
  BEGIN
      RETURN
        (SELECT QUESTNUM AS number,
                QUESTDES AS text,
                ZROD_MANDATORY AS Madatory,
                (SELECT ANSDES AS text,
                        ANSNUM AS number
                 FROM   ANSWERS
                 WHERE  QUESTF = @QUESTF
                        AND QUESTNUM = Quest.QUESTNUM
                 FOR XML PATH(''option''), type),
                (SELECT '''' AS text,
                        '''' AS value
                 FOR XML path(''response''), type)
         FROM   QUESTIONS AS Quest
         WHERE  QUESTF = @QUESTF
                AND QGROUP = @QGROUP
         ORDER  BY SORT
         FOR XML PATH(''question''), type)
  END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_RouteOrder]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_RouteOrder]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_RouteOrder]
(
	-- Add the parameters for the function here
	@ROUTE INT,
	@CURDATE INT,
	@CUST INT
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar int

	-- Add the T-SQL statements to compute the return value here
	set @ResultVar = (
		Select top 1 ZROD_ROUTEORDER 
		from ORDERITEMS 
		where ZROD_ROUTE = @ROUTE 
		AND DUEDATE = @CURDATE 
		AND ORD in (select ORD from ORDERS where CUST= @CUST))

	-- Return the result of the function
	RETURN @ResultVar

END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_QuestRemarks]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_QuestRemarks]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_QuestRemarks] ( @QUESTF INT )
RETURNS VARCHAR(MAX)
AS
BEGIN
   declare @html varchar(max)
   select @html = coalesce(@html,'' '','''') + TEXT
   from QUESTFORMTEXT as QTEXT
   where QUESTF = @QUESTF
   and TEXTLINE > 0
   order by TEXTORD
   RETURN replace(replace(@html,''<'','':[''),''>'','']:'')
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_Payment]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_Payment]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_Payment]
(
	-- Add the parameters for the function here
	@CUST INT
)
RETURNS 
@PAY TABLE 
(
	-- Add the column definitions for the TABLE variable here
	paymentterms varchar(50), 
	overduepayment MONEY,
	dueamount MONEY,
	todaysinvoicetotal MONEY,
	cash MONEY,
	cheque MONEY
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	INSERT INTO @PAY
	SELECT PAYDES                   AS paymentterms,
	   CONVERT(MONEY, SUM(CASE
							WHEN PAYDATE < datediff(MI, ''1988-01-01 23:59:59.9999999'', GETDATE()) THEN TOTPRICE
							ELSE 0.00
						  END)) AS overduepayment,
	   CONVERT(MONEY, SUM(CASE
							WHEN PAYDATE = datediff(MI, ''1988-01-01 23:59:59.9999999'', GETDATE()) THEN TOTPRICE
							ELSE 0.00
						  END)) AS dueamount,
	   0.0                      AS todaysinvoicetotal,
	   0.00                     AS cash,
	   0.00                     AS cheque
	FROM   INVOICES INV,
	   PAY
	WHERE  TYPE IN ( ''A'', ''C'' )
	   AND DEBIT = ''D''
	   AND FINAL = ''Y''
	   AND STORNOFLAG <> ''Y''
	   AND INV.CUST = @CUST
	   AND (SELECT PAY FROM CUSTOMERS WHERE CUST = @CUST) = PAY.PAY
	   AND FNCTRANS IN (SELECT FNCTRANS
						FROM   FNCITEMS
						WHERE  FRECONNUM = 0
							   AND DEBIT1 > 0.0)
	GROUP  BY PAYDES	
	RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_PartsStdPrice]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_PartsStdPrice]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_PartsStdPrice] (
-- Add the parameters for the function here
@PART INT)
RETURNS @PRICES TABLE (
  -- Add the column definitions for the TABLE variable here
  tquant  MONEY,
  price   MONEY )
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @PRICES
      SELECT 
             QUANT / 1000                    AS tquant,
             CONVERT(MONEY, PARTPRICE.PRICE) AS price
      FROM   PART
             INNER JOIN PARTPRICE
                     ON PARTPRICE.PART = PART.PART
      WHERE  PLIST = -1
             AND PART.PART = @PART
      order by QUANT / 1000

      RETURN
  END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_PartSerials1]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_PartSerials1]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[pda_PartSerials1] 
(
	-- Add the parameters for the function here
	@PART INT,
	@WARHS INT
)
RETURNS 
@PS TABLE 
(
	-- Add the column definitions for the TABLE variable here
	serial varchar(50),
	qty numeric, 
	expdate int
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	DECLARE @ty char(1)
	set @ty = (Select TYPE from PART where PART = @PART)
	
	if @ty=''P'' 
		begin		
			insert into @PS 
			SELECT     ISNULL(dbo.SERIAL.SERIALNAME, ''0'') AS SERIALNAME, SUM(dbo.WARHSBAL.BALANCE / 1000) AS BALANCE, dbo.SERIAL.EXPIRYDATE AS expdate
			FROM         dbo.PART INNER JOIN
								  dbo.WARHSBAL ON dbo.PART.PART = dbo.WARHSBAL.PART LEFT OUTER JOIN
								  dbo.SERIAL ON dbo.WARHSBAL.PART = dbo.SERIAL.PART AND dbo.WARHSBAL.SERIAL = dbo.SERIAL.SERIAL
			WHERE     (dbo.WARHSBAL.WARHS = @WARHS) AND (dbo.WARHSBAL.PART = @PART) AND (dbo.WARHSBAL.BALANCE / 1000 > 0) and (dbo.PART.TYPE IN (N''P''))
			GROUP BY ISNULL(dbo.SERIAL.SERIALNAME, ''0''), dbo.SERIAL.EXPIRYDATE	
		END
	else
		BEGIN
			insert into @PS 
			SELECT     ''0'' AS SERIALNAME, ISNULL(SUM(dbo.WARHSBAL.BALANCE / 1000),0) AS BALANCE, 0 AS expdate
			FROM         dbo.PART INNER JOIN
								  dbo.WARHSBAL ON dbo.PART.PART = dbo.WARHSBAL.PART
			WHERE     (dbo.WARHSBAL.WARHS = @WARHS) AND (dbo.WARHSBAL.PART = @PART) AND (dbo.WARHSBAL.BALANCE / 1000 > 0) and (dbo.PART.TYPE IN (N''R'',N''O''))   
		END
		
	declare @c int
	set @c = (select count (serial) from @PS)
	if @c = 0
		begin
			insert into @PS values (0,null,0)
		end
		
	RETURN 
END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_PartSerials]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_PartSerials]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[pda_PartSerials] 
(
	-- Add the parameters for the function here
	@PART INT,
	@WARHS INT
)
RETURNS 
@PS TABLE 
(
	-- Add the column definitions for the TABLE variable here
	serial varchar(50),
	qty numeric
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	DECLARE @ty char(1)
	set @ty = (Select TYPE from PART where PART = @PART)
	
	if @ty=''P'' 
		begin		
			insert into @PS 
			SELECT     ISNULL(dbo.SERIAL.SERIALNAME, ''0'') AS SERIALNAME, SUM(dbo.WARHSBAL.BALANCE / 1000) AS BALANCE
			FROM         dbo.PART INNER JOIN
								  dbo.WARHSBAL ON dbo.PART.PART = dbo.WARHSBAL.PART LEFT OUTER JOIN
								  dbo.SERIAL ON dbo.WARHSBAL.PART = dbo.SERIAL.PART AND dbo.WARHSBAL.SERIAL = dbo.SERIAL.SERIAL
			WHERE     (dbo.WARHSBAL.WARHS = @WARHS) AND (dbo.WARHSBAL.PART = @PART) AND (dbo.WARHSBAL.BALANCE / 1000 > 0) and (dbo.PART.TYPE IN (N''P''))
			GROUP BY ISNULL(dbo.SERIAL.SERIALNAME, ''0'')		
		END
	else
		BEGIN
			insert into @PS 
			SELECT     ''0'' AS SERIALNAME, ISNULL(SUM(dbo.WARHSBAL.BALANCE / 1000),0) AS BALANCE
			FROM         dbo.PART INNER JOIN
								  dbo.WARHSBAL ON dbo.PART.PART = dbo.WARHSBAL.PART
			WHERE     (dbo.WARHSBAL.WARHS = @WARHS) AND (dbo.WARHSBAL.PART = @PART) AND (dbo.WARHSBAL.BALANCE / 1000 > 0) and (dbo.PART.TYPE IN (N''R'',N''O''))   
		END
		
	declare @c int
	set @c = (select count (serial) from @PS)
	if @c = 0
		begin
			insert into @PS values (0,null)
		end
		
	RETURN 
END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_Invoices]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_Invoices]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_Invoices] (
-- Add the parameters for the function here
@CUST INT)
RETURNS @INV TABLE (
  -- Add the column definitions for the TABLE variable here
  iv      INT,
  ivnum   VARCHAR(30),
  ivdate  INT,
  duedate INT,
  total   MONEY )
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @INV
      SELECT IV                       AS iv,
             IVNUM                    AS ivnum,
             IVDATE                   AS ivdate,
             PAYDATE                  AS duedate,
             CONVERT(MONEY, TOTPRICE) AS total
      FROM   INVOICES AS INV
      WHERE  TYPE IN ( ''A'', ''C'' )
             AND DEBIT = ''D''
             AND FINAL = ''Y''
             AND STORNOFLAG <> ''Y''
             AND INV.CUST = @CUST
             AND FNCTRANS IN (SELECT FNCTRANS
                              FROM   FNCITEMS
                              WHERE  FRECONNUM = 0
                                     AND DEBIT1 > 0.0)

      DECLARE @C INT

      SET @C = (SELECT COUNT(*)
                FROM   @INV)

      IF @C = 0
        BEGIN
            INSERT INTO @INV
            SELECT 0,
                   ''0'',
                   0,
                   0,
                   0.00
        END

      RETURN
  END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_InvoiceItems]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_InvoiceItems]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_InvoiceItems] (
-- Add the parameters for the function here
@IV INT)
RETURNS @II TABLE (
  -- Add the column definitions for the TABLE variable here
  ordi      INT,
  name      VARCHAR(30),
  barcode   VARCHAR(30),
  des       VARCHAR(50),
  qty       numeric,
  unitprice numeric )
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @II
      SELECT INVOICEITEMS.ORDI,
             PARTNAME,
             BARCODE,
             PARTDES,
             TQUANT / 1000,
             CONVERT(MONEY, INVOICEITEMS.PRICE)
      FROM   INVOICEITEMS
             INNER JOIN PART
                     ON INVOICEITEMS.PART = PART.PART
      WHERE  INVOICEITEMS.IV = @IV

      RETURN
  END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_FamilyParts]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_FamilyParts]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[pda_FamilyParts] (
-- Add the parameters for the function here
@FAMILY INT)
RETURNS @PART TABLE (
  -- Add the column definitions for the TABLE variable here
  part    INT,
  name    VARCHAR(50),
  des     VARCHAR(50),
  barcode VARCHAR(50))
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @PART
      SELECT DISTINCT PART.PART AS part,
                      PARTNAME  AS name,
                      PARTDES   AS des,
                      BARCODE   AS barcode
      FROM   PART
             INNER JOIN PARTPRICE
                     ON PARTPRICE.PART = PART.PART
      WHERE  PLIST = -1
             AND FAMILY = @FAMILY

      RETURN
  END 
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_Family]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_Family]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_Family]
()
RETURNS 
@FAMILY TABLE 
(
	-- Add the column definitions for the TABLE variable here
	family int,
	familyname VARCHAR(50)	
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	INSERT INTO @FAMILY
	SELECT FAMILY, FAMILYDES 
	FROM   FAMILY AS family
                WHERE  FAMILY IN (SELECT FAMILY
                                  FROM   PART
                                         INNER JOIN PARTPRICE
                                                 ON PARTPRICE.PART = PART.PART
                                  WHERE  PLIST = -1)
                       AND family.ZROD_PDAFLAG = ''Y''
	RETURN 
END
' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_DeliveryItems]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_DeliveryItems]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_DeliveryItems] (
-- Add the parameters for the function here
@ROUTE INT,
@ORD   INT)
RETURNS @PART TABLE (
  -- Add the column definitions for the TABLE variable here
  ordi      INT,
  name      VARCHAR(50),
  des       VARCHAR(50),
  parttype  VARCHAR(1),
  barcode   VARCHAR(50),
  lotnumber VARCHAR(50),
  tquant    numeric,
  cquant    numeric )
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @PART
      SELECT ORDERITEMS.ORDI,
             PARTNAME,
             PARTDES,
             TYPE,
             BARCODE,
             '''',
             TQUANT / 1000,
             0
      FROM   ORDERITEMS
             INNER JOIN PART
                     ON ORDERITEMS.PART = PART.PART
      WHERE  ORDERITEMS.ORD = @ORD
             AND ORDERITEMS.ZROD_ROUTE = @ROUTE
      ORDER  BY TYPE

      RETURN
  END

' 
END
GO
/****** Object:  UserDefinedFunction [dbo].[pda_Deliveries]    Script Date: 04/15/2013 09:07:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pda_Deliveries]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[pda_Deliveries] (
	@ROUTE   INT,
	@CURDATE int
)
RETURNS @DEL TABLE ( 
  cust			   INT,
  ord              INT,
  ordinal          INT, 
  custnumber       VARCHAR(50),
  postcode         VARCHAR(10),
  sonum            VARCHAR(20),
  showprices       VARCHAR(1),
  delivered        INT,
  nodeliveryreason VARCHAR(1),
  phone            INT
)
AS
  BEGIN
      -- Fill the table variable with the rows for your result set
      INSERT INTO @DEL
      SELECT ORDERS.CUST,
             ORDERS.ORD,
			 dbo.pda_RouteOrder(@ROUTE, @CURDATE, cust.CUST),
             CUSTDES,
             ZIP,
             ORDNAME,
             ISSUEFLAG,
             0,
             '''',
             ORDERS.PHONE
      FROM   ORDERS AS ORDERS
             INNER JOIN CUSTOMERS AS cust
                     ON ORDERS.CUST = cust.CUST
      WHERE  ORD in (select distinct ORD from ORDERITEMS where ZROD_ROUTE = @ROUTE AND DUEDATE = @CURDATE)
             AND cust.ZROD_PICKTYPE = ''B''     
      ORDER BY dbo.pda_RouteOrder(@ROUTE, @CURDATE, cust.CUST)
      
      INSERT INTO @DEL
      SELECT CUSTOMERS.CUST,
             0,
			 999,
             CUSTDES,
             ZIP,
             '''',
             ISSUEFLAG,
             1,
             '''',
             PHONEBOOK.PHONE
      FROM   CUSTOMERS LEFT OUTER JOIN PHONEBOOK
			ON CUSTOMERS.CUST = PHONEBOOK.CUST 
      WHERE  ZROD_ROUTE1 = @ROUTE OR ZROD_ROUTE2 = @ROUTE OR ZROD_ROUTE1 = @ROUTE
      AND    ORDFLAG = ''Y''
      AND    CUSTOMERS.CUST NOT IN (SELECT cust FROM @DEL)
      ORDER BY CUST
             
	  IF (SELECT COUNT(*) FROM @DEL) = 0
		begin
			INSERT INTO @DEL
      	    SELECT 0,0,0, ''0'',''0'',''0'',''0'',0,''0'',''0''
		end
		
      RETURN
  END

' 
END
GO

/*
DECLARE @VANNUM VARCHAR(8)
DECLARE @CURDATE BIGINT
DECLARE @WARHS BIGINT
DECLARE @ROUTENAME VARCHAR(8)
DECLARE @ROUTE INT

SET @VANNUM = 'SA04FVG'
SET @WARHS = (SELECT ZROD_WARHS
              FROM   ZEMG_VEHICLES
              WHERE  VEHICLENO = @VANNUM)
SET @CURDATE = dbo.DATETOMIN8(GETDATE() - 28)
SET @ROUTE = (SELECT ZROD_ROUTEFORVAN.ROUTE
              FROM   ZROD_ROUTEFORVAN
                     INNER JOIN ZROD_ROUTES
                             ON ZROD_ROUTEFORVAN.ROUTE = ZROD_ROUTES.ROUTE
              WHERE  VANNUM = @VANNUM)
SET @ROUTENAME = (SELECT ROUTENAME
                  FROM   ZROD_ROUTEFORVAN
                         INNER JOIN ZROD_ROUTES
                                 ON ZROD_ROUTEFORVAN.ROUTE = ZROD_ROUTES.ROUTE
                  WHERE  VANNUM = @VANNUM)

SELECT '',
       (SELECT '',
               (SELECT dbo.pda_QuestRemarks(SURVEY.QUESTF)
                FOR XML PATH('text'), type),
               (SELECT '',
                       dbo.pda_Survey(SURVEY.QUESTF, 1)
                FOR XML PATH('checks'), type),
               (SELECT '',
                       dbo.pda_Survey(SURVEY.QUESTF, 2)
                FOR XML PATH('cleanliness'), type),
               (SELECT '',
                       dbo.pda_Survey(SURVEY.QUESTF, 3)
                FOR XML PATH('damage'), type),
               (SELECT '',
                       dbo.pda_Survey(SURVEY.QUESTF, 4)
                FOR XML PATH('mileage'), type)
        FROM   QUESTFORM AS SURVEY
        WHERE  QUESTF <> 0
               AND TYPE = 'C'
               AND QUESTFCODE = 'MN'
        FOR XML PATH('maintainance'), type),
       (SELECT '',
               (SELECT familyname,
						(select '', 
                       (SELECT name,
                               des,
                               barcode,
                               part,
                               (SELECT '',
                                       (SELECT tquant,
                                               price
                                        FROM   dbo.pda_PartsStdPrice(part.part)
                                        FOR XML path ('break'), type)
                                FOR XML path ('breaks'), type)
                        FROM   dbo.pda_FamilyParts(family.family) AS part
                        FOR XML path ('part'), type)
                        FOR XML path ('parts'), type)
                FROM   pda_Family() AS family
                FOR XML path ('family'), root('families'), type)
        FOR xml path('stdpricelist'), type),
        
       (SELECT @CURDATE   AS curdate,
               @ROUTENAME AS routenumber,
               @VANNUM    AS vehiclereg,
               (SELECT '',
                       (SELECT ordinal,
                               custnumber,
                               postcode,
                               sonum,
                               showprices,
                               delivered,
                               nodeliveryreason,
                               (SELECT '',
                                       (SELECT ordi,
                                               name,
                                               des,
                                               parttype,
                                               barcode,
                                               lotnumber,
                                               tquant,
                                               cquant
                                        FROM   dbo.pda_DeliveryItems(@ROUTE, delivery.ord)
                                        FOR XML PATH('part'), TYPE)
                                FOR XML PATH('parts'), TYPE),
                               (SELECT ZROD_SIGNATURE AS mandatory,
                                       ''             AS image,
                                       ''             AS [print]
                                FROM   CUSTOMERS
                                WHERE  CUST = delivery.cust
                                FOR xml path ('customersignature'), type),
                               (SELECT custnumber,
                                       custname,
                                       contact,
                                       phone,
                                       address,
                                       address2,
                                       address3,
                                       address4,
                                       postcode,
                                       (SELECT '',
                                               (SELECT ivnum,
                                                       ivdate,
                                                       duedate,
                                                       total,
                                                       (SELECT '',
                                                               (SELECT ordi,
                                                                       name,
                                                                       barcode,
                                                                       des,
                                                                       qty,
                                                                       unitprice
                                                                FROM   dbo.pda_InvoiceItems(invoice.iv)
                                                                FOR xml path ('part'), type)
                                                        FOR xml path ('parts'), type)
                                                FROM   dbo.pda_Invoices(delivery.cust) AS invoice
                                                FOR XML path('invoice'), type)
                                        FOR xml path ('invoices'), type),
                                       (SELECT '',
                                               (SELECT '',
                                                       (SELECT 0   AS ivnum,
                                                               0   AS ordi,
                                                               '0' AS name,
                                                               '0' AS des,
                                                               0   AS qty,
                                                               0.0 AS unitprice,
                                                               0   AS rcvdqty,
                                                               '0' AS reason
                                                        FOR XML path ('part'), type)
                                                FOR XML path ('parts'), type)
                                        FOR XML path ('creditnote'), type),
                                       (SELECT '',
                                               (SELECT 0    AS deliverydate,
                                                       0    AS ponum,
                                                       0.00 AS value,
                                                       (SELECT '',
                                                               (SELECT '0' AS name,
                                                                       '0' AS barcode,
                                                                       '0' AS des,
                                                                       0   AS qty,
                                                                       0.0 AS unitprice
                                                                FOR XML path ('part'), type)
                                                        FOR XML path ('parts'), type)
                                                FOR XML path ('order'), type)
                                        FOR XML path ('orders'), type),
                                       (SELECT dbo.pda_CustomerAccInfo(delivery.cust) AS text
                                        FOR xml path ('accountinfo'), type),
                                       (SELECT dbo.pda_CustomerRemarks(delivery.cust) AS text
                                        FOR xml path ('customerremarks'), type),
                                       (SELECT '' AS text
                                        FOR xml path ('addremark'), type),
                                       (SELECT '',
                                               (SELECT '',
                                                       (SELECT name,
                                                               barcode,
                                                               des,
                                                               tquant,
                                                               price
                                                        FROM   dbo.pda_CustomerPriceList(delivery.cust)
                                                        FOR xml path('part'), type)
                                                FOR xml path('parts'), type)
                                        FOR xml path('customerpricelist'), type),
                                        (SELECT '',
											(SELECT family,
													part
												FROM dbo.pda_CustomerPartList(delivery.cust)
											FOR xml path('families'), type)
                                        FOR xml path('custpart'), type)
                                FROM   dbo.pda_CustomerDetails(delivery.phone, delivery.cust)
                                FOR xml path ('customer'), type),
                               (SELECT paymentterms,
                                       overduepayment,
                                       dueamount,
                                       todaysinvoicetotal,
                                       cash,
                                       cheque
                                FROM   dbo.pda_Payment(delivery.cust)
                                FOR XML path('payment'), type)
                        FROM   dbo.pda_Deliveries(@ROUTE, @CURDATE) AS delivery
                        FOR XML PATH ('delivery'), TYPE)
                FOR xml path ('deliveries'), type)
        FOR xml path('home'), type),
       (SELECT '',
               (SELECT '',
                       (SELECT PARTNAME AS name,
                               BARCODE  AS barcode,
                               (SELECT '',
                                       (SELECT serial AS name,
                                               qty    AS qty,
                                               expdate AS expirydate
                                        FROM   dbo.pda_PartSerials1(warhsbal.PART, @WARHS)
                                        FOR xml path('lot'), type)
                                FOR xml path('lots'), type)
                        FROM   dbo.pda_WhsParts(@WARHS) AS warhsbal
                        FOR xml path ('part'), type)
                FOR xml path('parts'), type)
        FOR xml path ('warehouse'), type),
       (SELECT '',
               (SELECT '',
                       (SELECT REASON AS reason
                        FROM   ZROD_CREDITREASON
                        WHERE  REASON <> ''
                        FOR xml path(''), type)
                FOR xml path('credit'), type),
               (SELECT '',
                       (SELECT REASON AS reason
                        FROM   ZROD_NODELREASON
                        WHERE  REASON <> ''
                        FOR xml path(''), type)
                FOR xml path('nodelivery'), type)
        FOR xml path('reasons'), type)
FOR XML PATH ('pdadata'), type 
*/