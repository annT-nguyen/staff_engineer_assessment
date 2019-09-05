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
select CC.PersonID, CC.AttributionStartDate, CC.AttributionEndDate
from 
(
select 
C.personid, c.contractstartdate as AttributionStartDate,
C.contractenddate as AttributionEndDate,
D.DateDayofMonth as StartDoM, d2.DateDayofMonth as EndDoM,
D.DateDayofYear as StartDoY, d2.dateDayofYear as EndDoY, 
D.DateYearMonth as StartYM, d2.DateYearMonth as EndYM
from PersonDatabase.dbo.contacts C with (nolock)
join PersonDatabase.dbo.Dates D on C.ContractStartDate = D.DateValue
join PersonDatabase.dbo.Dates d2 on C.contractenddate = d2.DateValue
group by C.personid, c.Contractstartdate, C.ContractendDate, 
D.DateDayofMonth , d2.DateDayofMonth ,
D.DateDayofYear , d2.dateDayofYear , 
D.DateYearMonth , d2.DateYearMonth 
--order by C.PersonID, D.DateYearMonth, C.contractstartdate desc;
) AS CC
order by CC.PersonID, CC.AttributionStartDate, CC.AttributionEndDate
