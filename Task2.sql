-- Create vietnam table of all relevant columns\
/*
Select the relevant columns to be used in the query and then interprete based on context provided by the data dictionary
*/
drop view if exists vietnam_table;
create view vietnam_table as
select childid,
		floor(agemon/12) as[age],
		round,
		t2.region_name as [region],
		case -- Classify gender
			when chsex = 1 then 'male'
			when chsex = 2 then 'female'
		else 'unknown'
		end as [gender],
		commsch as [school_commute_time],
		case -- classify preprimary school attendance
			when preprim = 0 then 'no'
			when preprim = 1 then 'yes'
		else 'unknown'
		end as [attended_preprimary],
		agegr1 as [school_start_age],
		case -- child in school
			when enrol = 0 then 'no'
			when enrol = 1 then 'yes'
		end as [in_school],
		case -- education level
			when levlread = 1 then 'Cant read'
			when levlread = 2 then 'read letters'
			when levlread = 3 then 'read words'
			when levlread = 4 then 'read_sentence'
		else 'unknown'
		end as [reading_level],
		case
			when levlwrit = 1 then 'No'
			when levlwrit = 2 then 'yes_withdifficulty'
			when levlwrit = 3 then 'yes_withoutdifficulty'

		else 'unknown'
		end as [writing_level],
		case
			when literate = 0 then 'no'
			when literate = 1 then 'yes'
		else 'unknown'
		end as [literate]

		from [dbo].[vietnam_constructed] as t1
		inner join [dbo].[regiondata] as t2
		on t1.region = t2.region_code


select * from vietnam_table
select  literate, count(childid)  from [dbo].[vietnam_constructed] group by literate
