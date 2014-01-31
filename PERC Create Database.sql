USE master
IF EXISTS(SELECT * FROM sys.sysdatabases where name='PERC')
DROP DATABASE PERC

CREATE DATABASE PERC
GO

USE PERC
CREATE TABLE [dbo].[PostalCode](
	[PostalCodeID] [INT] PRIMARY KEY IDENTITY
	, [PostalCode] [INT] NOT NULL
	, [City] [nvarchar](20) NOT NULL
	, [State] [char](2) DEFAULT 'UT'
CONSTRAINT [Unique_CityZip] UNIQUE
(
	[PostalCode], [City], [State]
)
)

CREATE TABLE [dbo].[Patron](
	[PatronID] [INT] PRIMARY KEY IDENTITY
	--, [HouseholdID] [INT] References Household
	, [PatronFirstName] [nvarchar](20) NOT NULL
	, [PatronLastName] [nvarchar](30) NOT NULL
	, [SpouseName] [nvarchar](50)
	, [Address1] [nvarchar](70) NOT NULL
	, [Address2] [nvarchar](70) NOT NULL
	, [TelephoneNumber] [varchar](10)
	, [CellNumber] [varchar](10)
	, [EmailAddress] [varchar](20)
	, [PostalCodeID] [INT] REFERENCES PostalCode NOT NULL
)

CREATE TABLE [dbo].[Material](
	[MaterialID] [INT] PRIMARY KEY IDENTITY
	, [MaterialName] [nvarchar](20) UNIQUE NOT NULL
)

CREATE TABLE [dbo].[MaterialType](
	[TypeID] [INT] PRIMARY KEY IDENTITY
	, [TypeName] [varchar](10)
)

CREATE TABLE [dbo].[SpecificMaterial] (
	[BarcodeID] [INT] PRIMARY KEY
	, [MaterialID] [INT] REFERENCES Material NOT NULL
	, [CheckedOut][bit] Not Null
	, [Quality] [VarChar](10)
	, [TypeID][INT] References MaterialType NOT NULL
)

CREATE TABLE [dbo].[Hold](
	[MaterialID][INT] REFERENCES Material
	, [PatronID][INT] REFERENCES Patron
	, [TypeID][INT] REFERENCES MaterialType
PRIMARY KEY([MaterialID], [PatronID], [TypeID])
)

CREATE TABLE [dbo].[Checkout](
	[CheckoutID][INT] PRIMARY KEY IDENTITY
	, [PatronID][INT] REFERENCES Patron NOT NULL
	, [BarcodeID][INT] REFERENCES SpecificMaterial NOT NULL
	, [DueDate][DATE] NOT NULL
	, [CheckoutDate][DATE] NOT NULL
	, [DateReturned][DATE]
	, [RenewDate][DATE]
)

CREATE TABLE [dbo].[Fine](
	[FineID][INT] Primary Key IDENTITY
	, [FineAmount][MONEY] NOT NULL
	, [Reason][NCHAR](20) NOT NULL
	, [CheckoutID][INT] REFERENCES Checkout
)

CREATE TABLE [dbo].[Payment](
	[PaymentID][INT] Primary Key IDENTITY
	, [PaymentAmount][MONEY] NOT NULL
)