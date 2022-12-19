from django.http import JsonResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
import json
import pyodbc

"""
This file is the Logic where the Django is connected to the SQL Server and the JSON is processed
First : 
Connecting our Database with the ODBC Driver 17 with Host (Personal mssql server) and Database as corteva_database
"""
cnxn = pyodbc.connect(driver='{ODBC Driver 17 for SQL Server}', host='RONAK_LAPTOP\MSSQLSERVER01', database='corteva_database',trusted_connection='Yes', user='RONAK_LAPTOP\ronak')
cursor = cnxn.cursor()

"""
REST API for /api/weather/
A simple SQL Select statement is executed to extract all the data in the WEATHER table
The rows are run in a loop to create a dictionary to represent the real world data in the following format
{
    W_DATE : MMDDYYYY
    MAX_TEMP : Maximum temperature in celsius
    MIN_TEMP : Minimum temperature in celsius
    PRECIPITATION : Precipitation in Int
    STATION_ID : Station ID where the data is taken
}
All the data is converted into JSON and returned.
"""
@api_view(['GET'])
def weather_list(request, format = None):
    if request.method == 'GET':
        cursor.execute("SELECT * FROM WEATHER")
        tables = cursor.fetchall()
        data = []
        for row in tables:
            data.append({ 'W_DATE' : row[0].strftime("%m%d%Y"), 'MAX_TEMP' : row[1] / 10, 'MIN_TEMP' :row[2] / 10, 'PRECIPITATION' : row[3], 'STATION_ID' : row[4] })
        final_data = json.dumps(data)
        return JsonResponse({'Weather_data' : final_data}, safe = False)

"""
REST API for /api/yield/
A simple SQL Select statement is executed to extract all the data in the YIELD table
The rows are run in a loop to create a dictionary to represent the real world data in the following format
{
    Y_YEAR : YYYY as Int
    YIELD : Yield as Int
}
All the data is converted into JSON and returned.
"""
@api_view(['GET'])
def yield_list(request, format = None):
    if request.method == 'GET':
        cursor.execute("SELECT * FROM YIELD")
        tables = cursor.fetchall()
        data = []
        for row in tables:
            data.append({ 'Y_YEAR' : row[0], 'YIELD' : row[1]})
        final_data = json.dumps(data)
        return JsonResponse({'Yield_Data' : final_data}, safe = False)

"""
REST API for /api/weather/year/station_id/
The SQL statement uses the year and station_id passed in the GET request and extracts the data using WHERE clause
The rows are run in a loop to create a dictionary similar to /api/weather/
All the data is converted into JSON and returned.
"""
@api_view(['GET'])
def weather_stats(request, year, station_id, format = None):
    if request.method == 'GET':
        try:
            select_stmt = "SELECT * FROM WEATHER WHERE YEAR(W_DATE) = " + str(year) + " AND STATION_ID = '" + station_id + "'"
            cursor.execute(select_stmt)
            weather_data = cursor.fetchall()
            data = []
            for row in weather_data:
                data.append({ 'W_DATE' : row[0].strftime("%m%d%Y"), 'MAX_TEMP' : row[1] / 10, 'MIN_TEMP' :row[2] / 10, 'PRECIPITATION' : row[3], 'STATION_ID' : row[4] })
            final_data = json.dumps(data)
            return JsonResponse({'Weather_stats' : final_data}, safe = False)
        except :
            return Response(status = status.HTTP_404_NOT_FOUND)
        return Response(status = status.HTTP_404_NOT_FOUND)