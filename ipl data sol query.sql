create table matches(
    id int,
	city varchar(255),
	date date,
	player_of_match varchar(255),
	venue varchar(255),
	neutral_vanue int,
	team1 varchar(255),
	team2 varchar(255),
	toss_winner varchar(255),
	toss_decision varchar(255),
	winner varchar(255),
	result varchar(255),
	result_margin float,
	eliminator varchar(255),
	method varchar(255),
	umpire1 varchar(255),
	umpire2 varchar(255)
);

select * from matches;



create table delieveries(
    id int ,
	inning int,
	over int,
	ball int,
	batsman varchar(255),
	non_sticker varchar(255),
	bowler varchar(255),
	batsman_run  int,
	extra_run int,
	total_run int,
	is_wicket int,
	dismissal_kind varchar(255),
	player_dismissed varchar(255),
	fielder varchar(255),
	extras_type varchar(255),
	batting_team varchar(255),
	bowling_team varchar(255)
	
);

select * from delieveries;

--que 5
--Select the top 20 rows of the deliveries table after ordering them by id,
--inning, over, ball in ascending order.
--ans 5
select * from delieveries limit 20;



--que6  Select the top 20 rows of the matches table.
--ans 6k

select * from matches limit (20);

--que7 Fetch data of all the matches played on 2nd May 2013 from the matches table..

--ans 7

select * from matches where date = '02-05-2013';


--que8 Fetch data of all the matches where the result mode 
--is ‘runs’ and margin of victory is more than 100 runs.
-- ans8 

select * from matches where result_mode = 'runs' and result_margin > 100;


--que9 Fetch data of all the matches where the final scores of both teams
--tied and order it in descending order of the date.
-- ans9

select * from matches where result='tie' order by date desc;

--que 10 Get the count of cities that have hosted an IPL match.
--10 ans

select count(distinct (city)) from matches;

--que11 Create table deliveries_v02 with all the columns of the table ‘deliveries’
--and an additional column ball_result containing values boundary, dot or other depending on 
--the total_run (boundary for >= 4, dot for 0 and other for any other number)
--(Hint 1 : CASE WHEN statement is used to get condition based results)
--(Hint 2: To convert the output data of select statement into a table, you can use a subquery. 
--Create table table_name as [entire select statement].
--11 ans

create table deliveries_v02 as select *,
 CASE WHEN total_run >= 4 then 'boundary'
 WHEN total_run = 0 THEN 'dot'
else 'other'
 END as ball_result
 FROM delieveries;
 
 select * from deliveries_v02;
 
 --que12  Write a query to fetch the total number of boundaries and 
 --dot balls from the deliveries_v02 table.
 
 --ans12
 select ball_result, count (*) from deliveries_v02 group by ball_result;
 
 --que13   Write a query to fetch the total number of boundaries scored by each team
 --from the deliveries_v02 table and order it in descending order of the number of boundaries scored.

--ans
select batting_team, count(*) from deliveries_v02 where ball_result = 'boundary' group by
batting_team order by count desc;

--que14 Write a query to fetch the total number of dot balls bowled by each team and order it in 
--descending order of the total number of dot balls bowled.

--ans
select bowling_team, count(*) from deliveries_v02 where ball_result = 'dot' group by bowling_team
order by count desc;

--que 15 Write a query to fetch the total number of dismissals
--by dismissal kinds where dismissal kind is not NA

--ans

select dismissal_kind, count (*) from delieveries where dismissal_kind <> 'NA' group by dismissal_kind
order by count desc;

--que16 Write a query to get the top 5 bowlers who conceded 
--maximum extra runs from the deliveries table

--ans
select bowler, sum(extra_run) as total_extra_runs from delieveries group by bowler order by
total_extra_runs desc limit 5;

--que 17 Write a query to create a table named deliveries_v03 with all the columns of deliveries_v02 table
--and two additional column (named venue and match_date) of venue and date from table matches

--ans17

create table deliveries_v03 AS SELECT a.*, b.venue, b.match_date from
deliveries_v02 as a
left join (select max(venue) as venue, max(date) as match_date, id from matches group by
id) as b
on a.id = b.id;

--Task 18  Write a query to fetch the total runs scored for each venue and order 
--it in the descending order of total runs scored 


select venue, sum(total_run) as runs from deliveries_v03 group by venue order by runs desc;

--Task 19  Write a query to fetch the year-wise total runs scored at Eden Gardens 
--and order it in the descending order of total runs scored.
 

select extract(year from match_date) as IPL_year, sum(total_run) as runs from deliveries_v03
where venue = 'Eden Gardens' group by IPL_year order by runs desc;

--Task 20 Get unique team1 names from the matches table, you will notice that there are two entries
--for Rising Pune Supergiant one with Rising Pune Supergiant and another one with Rising Pune 
--Supergiants.  Your task is to create a matches_corrected table with two additional columns 
--team1_corr and team2_corr containing team names with replacing Rising Pune Supergiants with 
--Rising Pune Supergiant. Now analyse these newly created columns


select distinct team1 from matches;
create table matches_corrected as select *, replace(team1, 'Rising Pune Supergiants', 'Rising Pune
Supergiant') as team1_corr
, replace(team2, 'Rising Pune Supergiants', 'Rising Pune Supergiant') as team2_corr from matches;
select distinct team1_corr from matches_corrected;

--Task 21 Create a new table deliveries_v04 with the first column as ball_id containing information of
--match_id, inning, over and ball separated by ‘-’ (For ex. 335982-1-0-1 match_id-inning-over-ball)
--and rest of the columns same as deliveries_v03)

create table deliveries_v04 as select concat(id,'-',inning,'-',over,'-',ball) as ball_id, * from
deliveries_v03;

--Task 22  Compare the total count of rows and total count of distinct ball_id in deliveries_v04;


select * from deliveries_v04 limit 20;
select count(distinct ball_id) from deliveries_v04;
select count(*) from deliveries_v04;

--Task 23 SQL Row_Number() function is used to sort and assign row numbers to data rows in the 
--presence of multiple groups. For example, to identify the top 10 rows which have the highest order
--amount in each region, we can use row_number to assign row numbers in each group (region) with
--any particular order (decreasing order of order amount) and then we can use this new column to 
--apply filters. Using this knowledge, solve the following exercise. You can use hints to create 
--an additional column of row number.




drop table deliveries_v05;
create table deliveries_v05 as select *, row_number() over (partition by ball_id) as r_num from
deliveries_v04;


--Task 24  Use the r_num created in deliveries_v05 to identify instances where ball_id is repeating. 
--(HINT : select * from deliveries_v05 WHERE r_num=2;)

select count(*) from deliveries_v05;
select sum(r_num) from deliveries_v05;
select * from deliveries_v05 order by r_num limit 20;
select * from deliveries_v05 WHERE r_num=2;

--Task 25  Use subqueries to fetch data of all the ball_id which are repeating. 
--(HINT: SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2);

SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE
r_num=2);