USE PERSONDATABASE

/*********************
Hello! 

Please use the test data provided in the file 'PersonDatabase' to answer the following
questions. Please also import the dbo.Contracts flat file to a table for use. 

All answers should be written in SQL. 


/**********************

QUESTION 1

Create a patient matching stored procedure that accepts (first name, last name, dob and sex) as parameters and 
and calculates a match score from the Person table based on the parameters given. If the parameters do not match the existing 
data exactly, create a partial match check using the weights below to assign partial credit for each. Return PatientIDs and the
 calculated match score. Feel free to modify or create any objects necessary in PersonDatabase.  

FirstName 
	Full Credit = 1
	Partial Credit = .5

LastName 
	Full Credit = .8
	Partial Credit = .4

Dob 
	Full Credit = .75
	Partial Credit = .3

Sex 
	Full Credit = .6
	Partial Credit = .25


**********************/



/**********************

QUESTION 2

Write script to load the dbo.Dates table with all applicable data elements for dates 
between 1/1/2010 and 500 days past the current date.


**********************/
/***** Generate Date ******/
USE PersonDatabase;

DECLARE @StartDate DATE = '1/1/2010', @EndDate DATE = (select DateAdd(d,500,getdate()));
Print @StartDate;
Print @EndDate;
-- prevent set or regional settings from interfering with 
-- interpretation of dates / literals

SET DATEFIRST 7;
SET DATEFORMAT mdy;
SET LANGUAGE US_ENGLISH;

/****Getting the Date Value first****/
INSERT INTO PersonDatabase.dbo.Dates
(DateValue, DateDayofMonth, DateDayofYear, DateQuarter, DateWeekdayName, DateMonthName, DateYearMonth)
SELECT d, Day(d) as DateDayofMonth, Datepart(DAYOFYEAR,d) as DateDayofYear,
datepart(quarter,d) as DateQuarter, DateName(WEEKDAY, d) as DateWeekdayName, 
DATENAME(month,d) as DateMonthName, 
convert(varchar,datepart(yyyy, d))+convert(varchar,datepart(mm, d)) as DateYearMonth
FROM
(
  SELECT d = DATEADD(DAY, rn - 1, @StartDate)
  FROM 
  (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate)) 
      rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    -- on my system this would support > 5 million days
    ORDER BY s1.[object_id]
  ) AS x
) AS y;


/**********************

QUESTION 3

Please import the data from the flat file dbo.Contracts.txt to a table to complete this question. 

Using the data in dbo.Contracts, create a query that returns 

	(PersonID, AttributionStartDate, AttributionEndDate) 

The data should be structured so that rows with contiguous ranges are merged into a single row. Rows that contain a 
break in time of 1 day or more should be entered as a new record in the output. Restarting a row for a new 
month or year is not necessary.

Use the dbo.Dates table if helpful.

**********************/

