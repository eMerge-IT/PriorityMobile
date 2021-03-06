GO
/****** Object:  UserDefinedFunction [dbo].[DATETOMIN8]    Script Date: 04/15/2013 10:49:01 ******/
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
/****** Object:  UserDefinedFunction [dbo].[DATETOMIN]    Script Date: 04/15/2013 10:49:01 ******/
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
/****** Object:  UserDefinedFunction [dbo].[MINTODATE]    Script Date: 04/15/2013 10:49:01 ******/
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
/****** Object:  UserDefinedFunction [dbo].[REALQUANT]    Script Date: 04/15/2013 10:49:01 ******/
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
/****** Object:  UserDefinedFunction [dbo].[INTQUANT]    Script Date: 04/15/2013 10:49:01 ******/
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
