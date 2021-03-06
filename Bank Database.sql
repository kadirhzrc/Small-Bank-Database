USE [master]
GO
/****** Object:  Database [PROJE]    Script Date: 4.12.2018 01:53:42 ******/
CREATE DATABASE [PROJE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PROJE', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\PROJE.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PROJE_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\PROJE_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [PROJE] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PROJE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PROJE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PROJE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PROJE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PROJE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PROJE] SET ARITHABORT OFF 
GO
ALTER DATABASE [PROJE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PROJE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PROJE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PROJE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PROJE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PROJE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PROJE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PROJE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PROJE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PROJE] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PROJE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PROJE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PROJE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PROJE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PROJE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PROJE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PROJE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PROJE] SET RECOVERY FULL 
GO
ALTER DATABASE [PROJE] SET  MULTI_USER 
GO
ALTER DATABASE [PROJE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PROJE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PROJE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PROJE] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PROJE] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'PROJE', N'ON'
GO
ALTER DATABASE [PROJE] SET QUERY_STORE = OFF
GO
USE [PROJE]
GO
/****** Object:  Table [dbo].[Banker]    Script Date: 4.12.2018 01:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banker](
	[banker_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[surname] [varchar](50) NOT NULL,
	[gender] [char](1) NOT NULL,
	[phone_number] [char](11) NOT NULL,
	[wage] [int] NOT NULL,
	[branch_city] [varchar](50) NOT NULL,
	[branch_district] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Banker] PRIMARY KEY CLUSTERED 
(
	[banker_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Top10BankersWithHigherThanAverageWage]    Script Date: 4.12.2018 01:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Top10BankersWithHigherThanAverageWage]
AS
SELECT DISTINCT TOP 10    b.banker_id, b.name + ' ' + b.surname AS full_name, b.wage
FROM [Banker] b
WHERE b.wage > (SELECT AVG(wage) FROM Banker)
ORDER BY b.wage DESC
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 4.12.2018 01:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[customer_ssn] [char](11) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[surname] [varchar](50) NOT NULL,
	[date_of_birth] [date] NOT NULL,
	[gender] [char](1) NOT NULL,
	[maiden_name] [varchar](50) NOT NULL,
	[phone_number] [char](11) NOT NULL,
	[credit_limit] [int] NOT NULL,
	[city] [varchar](50) NOT NULL,
	[district] [varchar](50) NOT NULL,
	[branch_city] [varchar](50) NOT NULL,
	[branch_district] [varchar](50) NOT NULL,
	[age]  AS (CONVERT([smallint],datediff(year,[date_of_birth],getdate()))),
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[customer_ssn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[FemaleCustomersWithHigherThanAverageCredit]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FemaleCustomersWithHigherThanAverageCredit]
AS
SELECT DISTINCT TOP 10    c.customer_ssn, c.name + ' ' + c.surname AS full_name, c.credit_limit
FROM [Customer] c
WHERE c.credit_limit > (SELECT AVG(credit_limit) FROM Customer WHERE c.gender = 'f')
ORDER BY c.credit_limit DESC
GO
/****** Object:  Table [dbo].[Account]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[account_id] [int] IDENTITY(1,1) NOT NULL,
	[balance] [int] NULL,
	[creation_date] [date] NOT NULL,
	[customer_ssn] [char](11) NOT NULL,
	[debt] [int] NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[account_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[HighestBalanceWithDebtsExcluded]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[HighestBalanceWithDebtsExcluded]
AS
SELECT DISTINCT TOP 10    c.customer_ssn, c.name + ' ' + c.surname AS full_name, a.balance, a.debt, a.balance - a.debt as net
FROM [Customer] c, [Account] a
--(SELECT (a.balance - a.debt) AS net, c.customer_ssn FROM [Customer] c, [Account] a WHERE a.customer_ssn=c.customer_ssn GROUP BY a.customer_ssn) as Final
WHERE a.customer_ssn=c.customer_ssn
--WHERE Final. > (SELECT AVG(credit_limit) FROM Customer WHERE c.gender = 'f')
ORDER BY net DESC
GO
/****** Object:  View [dbo].[PercentageCreditFilled]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PercentageCreditFilled]
AS
SELECT DISTINCT TOP 10    c.customer_ssn, c.name + ' ' + c.surname AS full_name, c.credit_limit, a.debt, (100 * a.debt) / c.credit_limit as percentageFilled
FROM [Customer] c, [Account] a
--(SELECT (a.balance - a.debt) AS net, c.customer_ssn FROM [Customer] c, [Account] a WHERE a.customer_ssn=c.customer_ssn GROUP BY a.customer_ssn) as Final
WHERE a.customer_ssn=c.customer_ssn
--WHERE Final. > (SELECT AVG(credit_limit) FROM Customer WHERE c.gender = 'f')
ORDER BY percentageFilled DESC
GO
/****** Object:  Table [dbo].[Banker-Customer]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banker-Customer](
	[customer_ssn] [char](11) NOT NULL,
	[banker_id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Banker-Customer] PRIMARY KEY CLUSTERED 
(
	[customer_ssn] ASC,
	[banker_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[branch_city] [varchar](50) NOT NULL,
	[branch_district] [varchar](50) NOT NULL,
	[number_of_personel] [int] NOT NULL,
	[phone_number] [char](11) NOT NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[branch_city] ASC,
	[branch_district] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Card]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Card](
	[card_number] [char](16) NOT NULL,
	[valid_thru] [date] NOT NULL,
	[cv_number] [char](3) NOT NULL,
	[password] [char](4) NOT NULL,
	[customer_ssn] [char](11) NOT NULL,
	[account_id] [int] NOT NULL,
 CONSTRAINT [PK_Card] PRIMARY KEY CLUSTERED 
(
	[card_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction](
	[transaction_id] [int] IDENTITY(1,1) NOT NULL,
	[date] [date] NOT NULL,
	[amount] [int] NOT NULL,
	[account_id] [int] NOT NULL,
 CONSTRAINT [PK_Transaction] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF_Account_balance]  DEFAULT ((0)) FOR [balance]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF_Account_debt]  DEFAULT ((0)) FOR [debt]
GO
ALTER TABLE [dbo].[Card] ADD  CONSTRAINT [DF_Card_password]  DEFAULT ((1111)) FOR [password]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Customer] FOREIGN KEY([customer_ssn])
REFERENCES [dbo].[Customer] ([customer_ssn])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_Customer]
GO
ALTER TABLE [dbo].[Banker]  WITH CHECK ADD  CONSTRAINT [FK_Banker_Branch] FOREIGN KEY([branch_city], [branch_district])
REFERENCES [dbo].[Branch] ([branch_city], [branch_district])
GO
ALTER TABLE [dbo].[Banker] CHECK CONSTRAINT [FK_Banker_Branch]
GO
ALTER TABLE [dbo].[Banker-Customer]  WITH CHECK ADD  CONSTRAINT [FK_Banker-Customer_Banker] FOREIGN KEY([banker_id])
REFERENCES [dbo].[Banker] ([banker_id])
GO
ALTER TABLE [dbo].[Banker-Customer] CHECK CONSTRAINT [FK_Banker-Customer_Banker]
GO
ALTER TABLE [dbo].[Banker-Customer]  WITH CHECK ADD  CONSTRAINT [FK_Banker-Customer_Customer] FOREIGN KEY([customer_ssn])
REFERENCES [dbo].[Customer] ([customer_ssn])
GO
ALTER TABLE [dbo].[Banker-Customer] CHECK CONSTRAINT [FK_Banker-Customer_Customer]
GO
ALTER TABLE [dbo].[Card]  WITH CHECK ADD  CONSTRAINT [FK_Card_Account] FOREIGN KEY([account_id])
REFERENCES [dbo].[Account] ([account_id])
GO
ALTER TABLE [dbo].[Card] CHECK CONSTRAINT [FK_Card_Account]
GO
ALTER TABLE [dbo].[Card]  WITH CHECK ADD  CONSTRAINT [FK_Card_Customer] FOREIGN KEY([customer_ssn])
REFERENCES [dbo].[Customer] ([customer_ssn])
GO
ALTER TABLE [dbo].[Card] CHECK CONSTRAINT [FK_Card_Customer]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Branch] FOREIGN KEY([branch_city], [branch_district])
REFERENCES [dbo].[Branch] ([branch_city], [branch_district])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Branch]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_Account] FOREIGN KEY([account_id])
REFERENCES [dbo].[Account] ([account_id])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction_Account]
GO
/****** Object:  StoredProcedure [dbo].[DepositOrDrawMoney]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DepositOrDrawMoney]
	@customerSSN char(11),
	@amount int,
	@balance int OUTPUT
AS

set @balance = (select c.balance from [Account] c where c.customer_ssn = @customerSSN) + @amount;

UPDATE Account
	SET balance = @balance
	WHERE customer_ssn = @customerSSN;
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerInfo]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetCustomerInfo]
	@customerSSN char(11),
	@customerName varchar(50) OUTPUT,
	@customerSurname varchar(50) OUTPUT,
	@customerGender char(1) OUTPUT,
	@customerCreditLimit int OUTPUT,
	@customerCity varchar(50) OUTPUT,
	@customerAge int OUTPUT,
	@customerBranch varchar(50) OUTPUT
AS
declare @anan int;

set @customerName = (select c.name from [Customer] c where c.customer_ssn = @customerSSN);
set @customerSurname = (select c.surname from [Customer] c where c.customer_ssn = @customerSSN);
set @customerGender = (select c.gender from [Customer] c where c.customer_ssn = @customerSSN);
set @customerCreditLimit = (select c.credit_limit from [Customer] c where c.customer_ssn = @customerSSN);
set @customerCity = (select c.city from [Customer] c where c.customer_ssn = @customerSSN);
set @customerAge = (select c.age from [Customer] c where c.customer_ssn = @customerSSN);
set @customerBranch = (select c.branch_city from [Customer] c where c.customer_ssn = @customerSSN);

GO
/****** Object:  StoredProcedure [dbo].[GetTotalDebt]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetTotalDebt]
	@wageSum varchar(50) OUTPUT
AS

set @wageSum = (SELECT SUM(debt) FROM Account);

GO
/****** Object:  StoredProcedure [dbo].[UpdateBankerWage]    Script Date: 4.12.2018 01:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateBankerWage]
	@bankerId int,
	@banker_new_wage int,
	@bankerName varchar(50) OUTPUT,
	@bankerSurname varchar(50) OUTPUT,
	@bankerWage int OUTPUT
AS

set @bankerName = (select c.name from [Banker] c where c.banker_id = @bankerId);
set @bankerSurname = (select c.surname from [Banker] c where c.banker_id = @bankerId);
set @bankerWage = (select c.wage from [Banker] c where c.banker_id = @bankerId);

UPDATE Banker
	SET wage = @banker_new_wage
	WHERE banker_id = @bankerId;


GO
USE [master]
GO
ALTER DATABASE [PROJE] SET  READ_WRITE 
GO
