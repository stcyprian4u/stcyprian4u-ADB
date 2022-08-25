Use Smith_database;

Drop Table  if exists four_countries;

/*
We will pick columns relevant to out case study and the create various summaries. These columns will be selected across all tables
*/
Select 
* Into
four_countries
FROM
/*
Some of the column names of choice do not exactly match, but we will alias then into more consistent names before union
*/

	(Select childid, country, yc, round, inround, deceased, cast(dint as date ) as dint, clustid, region,childloc, chsex, chlang,
	chethnic, chldrel, agemon, chweight, chheight, bmi, chhprob, drwaterq as 
	[drwaterq_new], toiletq as [toiletq_new], cookingq as [cookingq_new], credit,foodsec,
	underweight, stunting, thinness, chillness, chinjury, chdisability, elecq as [elecq_new]	
	from dbo.india_constructed

		Union ALL

		Select childid, country, yc, round, inround, deceased, cast(dint as date) as dint, clustid, region,childloc, chsex, chlang, 
		chethnic, chldrel, agemon, chweight, chheight, bmi, chhprob, 
		drwaterq_new, toiletq_new, cookingq_new, credit,foodsec,
		underweight, stunting, thinness, chillness, chinjury, chdisability, elecq_new
		from dbo.ethiopia_constructed

		Union ALL

		Select childid, country, yc, round, inround, deceased, cast(dint as date) as dint, clustid, region,childloc, chsex, chlang, 
		chethnic, chldrel, agemon, chweight, chheight, bmi, chhprob, 
		drwaterq_new, toiletq_new, cookingq_new, credit,foodsec,
		underweight, stunting, thinness, chillness, chinjury, chdisability, elecq_new from dbo.vietnam_constructed

		Union ALL

		Select childid, country, yc, round, inround, deceased, cast(dint as date) as dint, clustid, region,childloc, chsex, chlang, 
		chethnic, chldrel, agemon, chweight, chheight, bmi, chhprob,
		underweight, stunting, thinness, chillness, chinjury,
		drwaterq as [drwaterq_new], toiletq as [toiletq_new], cookingq as [cookingq_new], credit,foodsec, chdisability, elecq as [elecq_new]
		from dbo.peru_constructed) 
AS four_countries
where round = 5
Order by childid;
/*
Add age column to data
*/

/*
Alter the original table to include only the region name. We have created a dimension table that summarises the insights from the data
This will help us add identifiable context to the regions data
*/
Update  t1
	set t1.region = t2.region_name
	from four_countries t1
	inner join [regiondata] t2
		on t1.region = t2.region_code

select top 5 * from four_countries



/*
select *, ROW_NUMBER() over (partition by childid order by round asc) as round_id
from four_countries 
*/
select  top 10 * from four_countries

-- Get Number of children with access to no drinking water
drop view if exists v_drwater_accessno
create view v_drwater_accessno
as
select country, region, [drinkingwater_access], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when drwaterq_new = 1 then 'yes'
			when drwaterq_new = 0 then 'no'
		else 'unknown'
		end as [drinkingwater_access]

		from four_countries
		) as t
		group by country, region, [drinkingwater_access]
		--order by country desc
select * from v_drwater_accessno;

/* Access to sanitation*/
drop view if exists v_sanitation_access
create view v_sanitation_access
as
select country, region, [sanitation_access], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when toiletq_new = 1 then 'yes'
			when toiletq_new = 0 then 'no'
		else 'unknown'
		end as [sanitation_access]

		from four_countries
		) as t
		group by country, region, [sanitation_access]

		--order by country desc
select * from v_sanitation_access;

/*
Access to adequate fuel for cooking
*/
drop view if exists v_adequate_cooking_fuel
create view v_adequate_cooking_fuel	
as
select country, region, [cookingfuel_access], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when cookingq_new = 1 then 'yes'
			when cookingq_new = 0 then 'no'
		else 'unknown'
		end as [cookingfuel_access]

		from four_countries
		) as t
		group by country, region, [cookingfuel_access]

		--order by country desc
select * from v_adequate_cooking_fuel;


/*House hold food situation */
drop view if exists v_food_situation
create view v_food_situation
as
select country,region, [foodsecurity], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when foodsec = 1 then 'enough_to_eat'
			when foodsec = 2 then 'enough_but_not_what_we_like'
			when foodsec = 3 then 'sometimes_enough'
			when foodsec = 4 then 'not_enough'
		else 'No answer'
		end as [foodsecurity]

		from four_countries
		) as t
		group by country,region, [foodsecurity]

		--order by country desc
select * from v_food_situation;

Select distinct toiletq_new from four_countries;

/*Access to credit */
drop view if exists v_credit_access
create view v_credit_access
as

select country, region, [credit_access], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when credit = 1 then 'yes'
			when credit = 0 then 'no'
		else 'unknown'
		end as [credit_access]

		from four_countries
		) as t
		group by country, region, [credit_access]

		--order by country desc
select * from  v_credit_access;

/*
Child Underweight
*/
drop view if exists v_underweight_ch
create view v_underweight_ch
as
select country, region, [Underweight], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when underweight  = 0 then 'no'
			when underweight  = 1 then 'moderate'
			when underweight  = 2 then 'Severe'
			else 'unknown'
		end as [Underweight]

		from four_countries
		) as t
		group by country, region, [Underweight]
		--order by country desc
select * from v_underweight_ch

/*Short height for age*/
drop view if exists v_short_height
create view v_short_height
as
select country, region, [stunted_growth], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when stunting  = 0 then 'no'
			when stunting  = 1 then 'moderate'
			when stunting  = 2 then 'Severe'
			else 'unknown'
		end as [stunted_growth]

		from four_countries
		) as t
		group by country, region, [stunted_growth]
		--order by country desc
select * from v_short_height;

select * from [four_countries];

/*Thinness for age*/
drop view if exists v_thin4age
create view v_thin4age
as
select country, region, [thinness], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when thinness  = 0 then 'no'
			when thinness  = 1 then 'moderate'
			when thinness  = 2 then 'Severe'
			else 'unknown'
		end as [thinness]

		from four_countries
		) as t
		group by country,region, [thinness]
		--order by country desc
select * from v_thin4age;

/*
Child has long term health problem?
*/
drop view if exists v_health_problem
create view v_health_problem
as
select country, region, [longterm_healthprob], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when chhprob = 1 then 'yes'
			when chhprob = 0 then 'no'
		else 'unknown'
		end as [longterm_healthprob]

		from four_countries
		) as t
		group by country, region, [longterm_healthprob]
		--order by country desc
select * from v_health_problem;

/*
Child has serious illness since last round?
*/
drop view if exists v_last_round_illness
create view v_last_round_illness
as
select country, region, [child_illness], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when chillness = 1 then 'yes'
			when chillness = 0 then 'no'
		else 'unknown'
		end as [child_illness]

		from four_countries
		) as t
		group by country, region, [child_illness]
		--order by country desc
select * from v_health_problem;


/*
Child disability
*/
drop view if exists v_child_disability
create view v_child_disability
as
select country, region, [child_disability], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when chdisability = 1 then 'yes'
			when chdisability = 0 then 'no'
		else 'unknown'
		end as [child_disability]

		from four_countries
		) as t
		group by country, region, [child_disability]
		--order by country desc
select * from v_child_disability;

/*
Access to electricity
*/
drop view if exists v_elect_access
create view v_elect_access
as
select country, region, [electricity_new], count(childid) as [count]
from(
select  childid,
		[country],
		[region],
		case
			when elecq_new = 1 then 'yes'
			when elecq_new = 0 then 'no'
		else 'unknown'
		end as [electricity_new]

		from four_countries
		) as t
		group by country, region, [electricity_new]
		--order by country desc
select * from v_elect_access




--create table showing BMI of Children
drop table if exists round5_bmi_table;

select * into round5_bmi_table from 
(Select childid,
country,
round ,
chheight,
chweight,
cast(bmi as float) as bmi
From 
Smith_database..four_countries
where round = 5 and deceased != 1)
as round5_bmi_table;

/*
Define a weight range. This will give an indicator into how much children are either obese, overweight or healthy
*/

Alter Table round5_bmi_table 
	add bmi_range as 
		case 
			when (bmi > 30) then 'OBESE'
			when (bmi > 25) then 'OVERWEIGHT'
			when (bmi > 18.5) then 'HEALTHY'
			else 'UNDERWEIGHT'
		end;

select * from round5_bmi_table
order by country, bmi;

/*
Get number of obese children weight class
*/

select country, bmi_range, count(*) as [weight_class]
		from round5_bmi_table 
		group by country, bmi_range
