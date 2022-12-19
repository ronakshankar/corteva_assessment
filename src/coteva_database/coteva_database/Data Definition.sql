
-- Creating Database 'corteva_database' if not exist
IF NOT EXISTS 
   (
     SELECT name FROM master.dbo.sysdatabases 
     WHERE name = N'corteva_database'
    )
BEGIN	
CREATE DATABASE corteva_database;
END

USE corteva_database;

/*
Creating Table Yield with following columns
Year : datatype as int as only year is given
Yield is also Int, Not null

Keys :
Year is the Primary key
Constraints : 
Yield cannot be negative
*/
IF OBJECT_ID(N'YIELD', N'U') IS NULL
CREATE TABLE YIELD (
Y_YEAR INT PRIMARY KEY,
YIELD INT NOT NULL CHECK (YIELD>= 0),
    );
GO

/*
Creating Table Weather with following columns
W_Date as one of the primary key
Max_Temp for Minimum Temperature
Min_temp for Maximum Temperature
Precipitation
Station_Id taken from file name

Keys :
W_Date and Station_Id are the primary key for this dataset

Constraints : 
Temperature cannot be less than -273.1 degree celsius and both min_temp and max_temp should be greater than that
Precipitation is always positive
*/
IF OBJECT_ID(N'WEATHER', N'U') IS NULL
CREATE TABLE WEATHER(
W_DATE DATE,
MAX_TEMP INT CHECK (MAX_TEMP >= -2731),
MIN_TEMP INT CHECK (MIN_TEMP >= -2731),
PRECIPITATION INT CHECK (PRECIPITATION >= 0),
STATION_ID VARCHAR(11),
PRIMARY KEY (W_DATE, STATION_ID),
);
GO

/*
Creating Log Tables for both Yield and Weather. 
Columns : 
START_TIME : datatime2 to get the milliseconds to the point of 4
END_TIME :  datatime2 to get the milliseconds to the point of 4
ROWS_Affected : Int
*/

IF OBJECT_ID(N'LOG_YIELD', N'U') IS NULL
CREATE TABLE LOG_YIELD(
START_TIME DATETIME2(4),
END_TIME DATETIME2(4),
ROWS_AFFECTED INT,
);
GO
IF OBJECT_ID(N'LOG_WEATHER', N'U') IS NULL
CREATE TABLE LOG_WEATHER(
START_TIME DATETIME2(4),
END_TIME DATETIME2(4),
ROWS_AFFECTED INT,
);
GO
