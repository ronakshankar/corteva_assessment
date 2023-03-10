USE CORTEVA_DATABASE;

IF OBJECT_ID(N'AVG_MIN_WEATHER', N'U') IS NOT NULL DROP TABLE AVG_MIN_WEATHER
IF OBJECT_ID(N'AVG_MAX_WEATHER', N'U') IS NOT NULL DROP TABLE AVG_MAX_WEATHER
IF OBJECT_ID(N'SUM_PRECIPITATION_WEATHER', N'U') IS NOT NULL DROP TABLE SUM_PRECIPITATION_WEATHER
IF OBJECT_ID(N'AGG_WEATHER', N'U') IS NOT NULL DROP TABLE AGG_WEATHER


-- Aggregating Min_Temp with Average by grouping Year and Station_ID
SELECT YEAR(W_DATE) AS 'YEAR', STATION_ID, AVG(MIN_TEMP) AS 'AVG_MIN_TEMP'
INTO AVG_MIN_WEATHER
FROM WEATHER
GROUP BY YEAR(W_DATE), STATION_ID;

-- Aggregating Max_Temp with Average by grouping Year and Station_ID
SELECT YEAR(W_DATE) AS 'YEAR', STATION_ID, AVG(MAX_TEMP) AS 'AVG_MAX_TEMP'
INTO AVG_MAX_WEATHER
FROM WEATHER
GROUP BY YEAR(W_DATE), STATION_ID;

-- Aggregating PRECIPITATION with SUM by grouping Year and Station_ID
SELECT YEAR(W_DATE) AS 'YEAR', STATION_ID, SUM(PRECIPITATION) AS 'TOTAL_PRECIPITATION_TEMP'
INTO SUM_PRECIPITATION_WEATHER
FROM WEATHER
GROUP BY YEAR(W_DATE), STATION_ID;

-- Aggregating All values in previous statement into single table by grouping Year and Station_ID
SELECT YEAR(W_DATE) AS 'YEAR', STATION_ID, AVG(MIN_TEMP) AS 'AVG_MIN_TEMP',AVG(MAX_TEMP) / 10 AS 'AVG_MAX_TEMP',  SUM(PRECIPITATION) AS 'TOTAL_PRECIPITATION_TEMP'
INTO AGG_WEATHER
FROM WEATHER
GROUP BY YEAR(W_DATE), STATION_ID;
