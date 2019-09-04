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
USE [PersonDatabase]
GO
ALTER TABLE PersonDatabase.dbo.Person
ADD FName varchar(50),LName varchar(50), MatchingScore float;

/*Perform some manuall data cleasing on PersonName to break it up into FName and LName.  
There should be a process to do this automatically.  This is done for this testing purpose only*/

  Update PersonDatabase.dbo.Person set FName = 'Azra', LName = 'Magnus', MatchingScore = 0
  where PersonID = 1
  Update PersonDatabase.dbo.Person set FName = 'Palmer', LName = 'Hales', MatchingScore = 0
  where PersonID = 2
  Update PersonDatabase.dbo.Person set FName = 'Lilla', LName = 'Solano', MatchingScore = 0
  where PersonID = 3
  Update PersonDatabase.dbo.Person set FName = 'Romeo', LName = 'Styles', MatchingScore = 0
  where PersonID = 4
  Update PersonDatabase.dbo.Person set FName = 'Margot', LName = 'Steed', MatchingScore = 0
  where PersonID = 5
  --select * from PersonDatabase.dbo.Person with (nolock)

USE [PersonDatabase]
GO

/****** Object:  UserDefinedFunction [dbo].[udfMatchingPerson]    Script Date: 9/4/2019 11:23:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udfMatchingPerson](

)
RETURNS TABLE
AS
RETURN
    SELECT
        [PersonID], 
		[MatchingScore]
    FROM
        PersonDatabase.dbo.Person with (nolock)
    --WHERE
GO

USE [PersonDatabase]
GO

/****** Object:  StoredProcedure [dbo].[MatchingPersonScore]    Script Date: 9/4/2019 11:25:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[MatchingPersonScore]
@FName as varchar(50), 
@LName as varchar(50),
@DoB as varchar(50),
@Gender as varchar(10)

AS
--select * from dbo.udfMatchingPerson(@FName,@Lname,@DoB,@Gender);
	declare @matchingscore_v float, @personid_v int, @FName_v varchar(50),
	@LName_v varchar(50), @Sex_v varchar(15), @DoB_v varchar(20);
	
	declare person_cursor cursor for select [PersonID],  
	[FName], [LName], LEFT([Sex],1), CONVERT(VARCHAR, [DateofBirth],101), [MatchingScore]
	from PersonDatabase.dbo.Person with (nolock);
	
	open person_cursor;
	FETCH NEXT FROM person_cursor INTO 
    @personid_v, @FName_v, @LName_v, @Sex_v, @DoB_v, @matchingscore_v;

	while @@FETCH_STATUS = 0  
    Begin
		--Print cast(@PersonID_v as varchar) + ' ' + @FName_v + ' ' + @LName_V + ' ' + @DoB_v + ' ' + cast(@matchingscore_v as varchar);
	IF (@matchingscore_v = 0)
	Begin
	Print cast(@PersonID_v as varchar) + ' ' + @FName_v + ' ' + @LName_V + ' ' + @DoB_v + ' ' + cast(@matchingscore_v as varchar);
		If (@FName_v = @FName)
			begin
			set @matchingscore_v = @matchingscore_v + 1;
			Print @matchingscore_v;
			Print 'I am in Fname = FName';
			end
		else If (@FName_v != @Fname)
			begin
			Print 'i am in FName_v != FName'
			set @matchingscore_v = @matchingscore_v + 0.5;
			end
		If (@LName_v = @LName)
			Begin
			set @matchingscore_v = @matchingscore_v + 0.8;
			Print @matchingscore_v;
			Print 'match last name';
			End
		else if (@LName_v != @LName)
			set @matchingscore_v = @matchingscore_v + 0.4;
		If (@DoB_v = @DoB)
			Begin
			Print @DoB_v + ' ' + @DoB;
			set @matchingscore_v = @matchingscore_v + 0.75;
			Print @matchingscore_v;
			Print 'dob match'
			End
		else if (@DoB_v != @DoB)
			set @matchingscore_v = @matchingscore_v + 0.3;	
		If (@Sex_v = @Gender)
			set @matchingscore_v = @matchingscore_v + 0.6;
		else if (@Sex_v != @Gender)
			set @matchingscore_v = @matchingscore_v + 0.25;
		Print 'finally...'
		Print @matchingscore_v;
		Update PersonDatabase.dbo.Person set matchingscore = @matchingscore_v
		where PersonID = @personid_v;
		
	End;
	FETCH NEXT FROM person_cursor INTO @personid_v, @FName_v, @LName_v, @Sex_v, @DoB_v, @matchingscore_v;  
	End;
	CLOSE person_cursor;
	DEALLOCATE person_cursor;
	select * from udfMatchingPerson();


	
	--print @matchingscore;
	--print @personid;
GO


/********************************************/
/* Testing out Store Procedure and Function */

exec MatchingPersonScore N'Azra', N'Magnus', N'07/24/1997', N'F';

select * from udfMatchingPerson();



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

