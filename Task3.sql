/*
To understand crimes in greater manchester, we will create different time based summaries of the data
*/


-- Time-based summaries
/*
Crimes by day of week
*/
create view day_of_week as
select 
		DATENAME(DW, [Month]) as [weekday],
		DAY([Month]) as [Weeknum],
		COUNT([Crime_ID]) as [Count]

		FROM [dbo].[greater_manchester]
		Group by DATENAME(DW, [Month]),DAY([Month])


/*
Crimes by month
*/
create view monthly_summary as
select 
		DATENAME(MM, [Month]) as [weekday],
		Month([Month]) as [Weeknum],
		COUNT([Crime_ID]) as [Count]

		FROM [dbo].[greater_manchester]
		Group by DATENAME(MM, [Month]),Month([Month])
		order by 2 asc

/*
Crimes by Year
*/
create view year_summary as
select year([Month]) as [year],
		count([Crime_ID]) as [count]

		from [dbo].[greater_manchester]
		group by year([Month])


/*
Top Crimes Location
*/
create view top_location as
select top 10 location, 
		count(crime_id) as [count] 
		
		from [greater_manchester]
		group by location
		order by 2 desc

/*
Least Crimes Location
*/
create view least_location as
select top 10 location, 
		count(crime_id) as [count] 
		
		from [greater_manchester]
		group by location
		order by 2 asc