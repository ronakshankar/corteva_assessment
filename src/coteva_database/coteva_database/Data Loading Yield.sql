USE  corteva_database;

--Creating Temporary file to store the file names of the directory

IF OBJECT_ID('TEMPDB..#TEMP_FILES') IS NOT NULL DROP TABLE #TEMP_FILES
CREATE TABLE #TEMP_FILES
(
FileName VARCHAR(MAX),
DEPTH VARCHAR(MAX),
[FILE] VARCHAR(MAX)
)
 
 -- Extracting the files stored inside the Yield directory
 /* 
 NOTE :
 Please change the directory path here.
 */
INSERT INTO #TEMP_FILES
EXEC master.dbo.xp_DirTree 'D:\WPI\Corteva\corteva_assessment\yld_data',1,1

-- Removing files apart from txt files

DELETE FROM #TEMP_FILES WHERE RIGHT(FileName,4) != '.txt'
IF OBJECT_ID('TEMPDB..#TEMP_YIELD') IS NOT NULL DROP TABLE #TEMP_YIELD

-- Creating a tempory table in the same structure as Yield.
SELECT *
INTO #TEMP_YIELD
FROM YIELD
WHERE 1 = 0;

-- Declare Tempory Variables 
/*
@FILENAME : To store the current file being processed
@SQL : For SQL Query
@START_TIME : Get the Current time before querying
@END_Time : Get the Current time after querying
@Rows : Get the number of rows inserted to the database
*/
DECLARE @FILENAME varchar(MAX)
DECLARE @SQL VARCHAR(MAX)
DECLARE @START_TIME DATETIME
DECLARE @END_TIME DATETIME
DECLARE @ROWS INT

WHILE EXISTS(SELECT * FROM #TEMP_FILES)
BEGIN
   BEGIN TRY
      --Get Current file on top of the #Temp_files
	  SET @FILENAME = (SELECT TOP 1 FileName FROM #TEMP_FILES)
	  -- Query to bulk insert from the current text file into the tempory table
	  /* NOTE: 
	   Please change the directory path here.
	   */
	  SET @SQL = 'BULK INSERT  #TEMP_YIELD
      FROM  ''D:\WPI\Corteva\corteva_assessment\yld_data\' + @FILENAME +'''
      WITH (FIELDTERMINATOR = ''\t'', ROWTERMINATOR = ''\n'');'
	  SET @START_TIME = SYSDATETIME()
      EXEC(@SQL)
	  --Insert the Tempory table into Yield table and filter out the null and negative values
	  INSERT INTO YIELD SELECT * FROM #TEMP_YIELD AS TY WHERE TY.YIELD >=0
	  SET @ROWS = @@ROWCOUNT
	  SET @END_TIME = SYSDATETIME()
	  -- Log the Ingestion
	  INSERT INTO LOG_YIELD VALUES (@START_TIME, @END_TIME, @ROWS);
   END TRY
   BEGIN CATCH
      PRINT 'Failed processing : ' + @FILENAME
   END CATCH

   --Delete the top files and the next file will be on Top
   DELETE FROM #TEMP_FILES WHERE FileName = @FILENAME

   -- Clear the tempory table
   TRUNCATE TABLE #TEMP_YIELD
END

SELECT * FROM YIELD;

SELECT * FROM LOG_YIELD;