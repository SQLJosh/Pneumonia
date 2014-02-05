USE PERC
Create Table PostalCode_Staging
(
	[PostalCode] char(5) NOT NULL
	, [City] nvarchar(20) NOT NULL
	, [State] char(2) NOT NULL
)
GO

BULK INSERT PostalCode_Staging
FROM 'c:\users\Josh\Documents\zipcodes.csv'

WITH
(
	FieldTerminator = ','
	,RowTerminator = '\n'
)

GO

INSERT INTO PostalCode (PostalCode, City, State)
SELECT DISTINCT PostalCode_Staging.PostalCode, PostalCode_Staging.City, PostalCode_Staging.State
FROM PostalCode_Staging
GO

DROP TABLE PostalCode_Staging
GO