/*PERFORMING DATA CLEANING ON A DATASET OF MOVIES */

use projects;

select * from Movies;


-- MODIFYING THE POPULARIRTY COLUMN DATATYPE */

alter table Movies 
alter column popularity decimal(6,2);


/* MODIFYING THE AVERAGE VOTE COLUMN DATATYPE */

alter table Movies 
alter column vote_average decimal(5,2);


/* RENAMING THE AVERAGE VOTE COLUMN */

exec sp_rename 'movies.vote_average', 'average_rating', 'column';


/* DETERMINING THE TOTAL COUNT OF ROWS */
select count(*) from Movies;


/* SEARCHING FOR NULL VALUES IN EACH COLUMN */

select * from movies 
where release_date is null
or overview is null
or title is null
or genres is null
or popularity is null
or average_rating is null
or vote_count is null;



/* POPULATING THE OVERVIEW COLUMN */

select title, 
release_date, 
overview, isnull(overview, 'Yet to be relased') as populated_column 
from movies 
where overview is null;


Update Movies 
set overview = isnull(overview, 'Yet to be relased') 
where year(release_date) > 2023


select title, 
release_date, 
overview, 
isnull(overview, 'Yet to be reviewed') as populated_column 
from movies 
where overview is null


update movies 
set overview = isnull(overview, 'Yet to be reviewed')
where year(release_date) <= 2023

select overview, 
title, 
release_date 
from movies
where overview is null




/* POPULATING THE GENRE COULUMN */

select title, 
release_date, 
genres, isnull(genres, 'Yet to be relased') as populated_column 
from movies 
where  genres is null


update movies 
set genres = isnull(genres, 'Yet to be reviewed')




/* Creating a bakup for the table with the null date values */

select * 
into movies_backup
from Movies
where 1 = 0;

insert into movies_backup
select * 
from Movies





/* DELETING ROWS WITH NULL VALUES IN THE DATE COLUMN */

select title, release_date
from Movies
where release_date is null


delete from Movies 
where release_date is null





/* EDITING THE GENRE COLUMN */

select title, 
genres,
case 
    when CHARINDEX(',', genres) > 0
    then SUBSTRING(genres, 1, CHARINDEX(',', genres) -1)
	else  genres
end as first_part,
case
    when CHARINDEX(',', genres) > 0
	then substring(genres, CHARINDEX(',', genres) +1, len(genres))
	else null
end as second_part
from Movies


update movies 
set genres = case 
    when CHARINDEX(',', genres) > 0
    then SUBSTRING(genres, 1, CHARINDEX(',', genres) -1)
	else  genres
end 





/* SELECTING THE FIRST 2O FIELDS WITH THE YEAR = 2023 */

select top 20 * from movies 
where YEAR(release_date) = 2023
and average_rating != 0
and vote_count != 0
order by popularity desc

