USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) as movie_count from movie;
select count(*) as genre_count from genre;
select count(*)as names_count from names ;
select count(*) as ratings_count from ratings;
select count(*) as role_mapping_count from role_mapping;



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
with cte as
(

		select sum(case when id is null then 1 else 0 end) as id_nulls,
		sum(case when title is null then 1 else 0 end) as title_nulls,
        sum(case when year is null then 1 else 0 end) as year_nulls,
        sum(case when date_published is null then 1 else 0 end) as date_published_nulls,
        sum(case when duration is null then 1 else 0 end) as duration_nulls,
        sum(case when country is null then 1 else 0 end) as country_nulls,
        sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income_nulls,
        sum(case when languages is null then 1 else 0 end) as languages_nulls,
        sum(case when production_company is null then 1 else 0 end) as production_company_nulls
from movie
)
select * from cte;




-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year,count(*) as number_of_movies
from movie group by year;


select month(date_published) as month_num,count(*) from movie
group by month_num
order by month_num
;







/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select country,count(*) as movies_count
from movie
where ((country="USA" or country="India") and (year=2019))
group by country
;








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct * from genre;






/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select genre,count(*) as Highest_genre_count
from genre as g
inner join movie as m
on m.id=g.movie_id
group by genre
order by Highest_genre_count desc limit 1
;









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
with genrecount as
(
   select movie_id from genre
   group by movie_id
   having count(distinct genre)=1
)
select count(*) as single_genre_count from genrecount
;





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select genre,avg(duration) from movie as m
inner join genre as g
on m.id=g.movie_id
group by genre
;






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with cte as
(
	select genre,count(*) as movie_count
from genre as g
inner join movie as m
on g.movie_id=m.id
group by genre
)
select *,
		Rank() over(order by movie_count desc) as genre_Rank
from cte;





/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
with cte as
(
    select 
    min(avg_rating) as min_avg_rating,
    max(avg_rating) as max_avg_rating,
    min(total_votes) as min_total_votes,
    max(total_votes) as max_total_votes,
    min(median_rating) as min_median_rating,
    max(median_rating) as max_median_rating
from ratings
)
select * from cte;

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

 with ranked_movies as
 (
 select title,avg_rating,
	DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
from ratings as r
inner join movie as m
on m.id=r.movie_id
 )
SELECT *
FROM ranked_movies
WHERE movie_rank <= 10;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select median_rating,count(movie_id) as movie_count from ratings
group by median_rating
order by movie_count desc;

-- Order by is good to have










/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
with cte1 as (
    select movie_id
    from ratings
    where avg_rating >= 8
),
cte2 as (
    select m.production_company
    from movie as m
    inner join cte1 as cte1r
    on m.id = cte1r.movie_id
),
cte3 as (
    select  production_company, count(*) as movie_count,
           dense_rank() over(order by count(*) desc) as production_company_rank
    from cte2
    group by production_company
)
select * from cte3;



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH filtered_movies AS (
    SELECT g.genre, m.id AS movie_id
    FROM genre AS g
    INNER JOIN movie AS m ON m.id = g.movie_id
    WHERE MONTH(m.date_published) = 3 AND YEAR(m.date_published) = 2017
    AND m.country = 'USA'
),
rated_movies AS (
    SELECT fm.genre, COUNT(*) AS movie_count
    FROM filtered_movies AS fm
    INNER JOIN ratings AS r ON fm.movie_id = r.movie_id
    WHERE r.total_votes > 1000
    GROUP BY fm.genre
)
SELECT genre, movie_count
FROM rated_movies
ORDER BY movie_count DESC;





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with cte as
(
select title,genre,id from movie as m
inner join genre as g
on m.id=g.movie_id
where title like "The%"
),
cte1 as
(
select title,avg_rating,genre
from cte as c
inner join ratings as r
on c.id=r.movie_id
where avg_rating>8
)
select * from cte1;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT m.title, m.date_published, r.median_rating
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id 
WHERE ((m.date_published BETWEEN '2018-04-01' AND '2019-04-01') AND (r.median_rating=8));










-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select country,sum(total_votes) as total_no_votes
from ratings as r
inner join movie as m
on r.movie_id=m.id
where (m.country="Germany" and m.languages="German")
UNION ALL 
select country,sum(total_votes) as total_no_votes
from ratings as r
inner join movie as m
on r.movie_id=m.id
where ( m.country="Italy" and m.languages="Italian");








-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
		sum(case when name is null then 1 else 0 end) as name_nulls,
        sum(case when height is null then 1 else 0 end) as height_nulls,
        sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
        sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;







/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select n.name as director_name,count(m.id) as movie_count from
genre as g join movie as m
on g.movie_id=m.id
join ratings as r
on m.id=r.movie_id
join director_mapping as dm on m.id=dm.movie_id
join names as n on n.id =dm.movie_id
where r.avg_rating>8
group by director_name
order by movie_count desc;
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
with cte as
(
    select id,title,median_rating
	from movie as m
    inner join ratings as r
    on m.id=r.movie_id
    where r.median_rating>8
),
cte2 as
(
   select * from cte as c
   inner join role_mapping as ro
   on c.id=ro.movie_id
   ),
cte3 as
(
   select name as actor_name,count(name_id) as movie_count from cte2 as c
   inner join names as n
   on c.name_id=n.id
   group by actor_name
   order by movie_count desc limit 2
)
select * from cte3;







/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH vote_counts AS (
    SELECT 
        m.production_company,
        SUM(r.total_votes) AS total_votes
    FROM 
        movie AS m
    INNER JOIN 
        ratings AS r ON m.id = r.movie_id
    GROUP BY 
        m.production_company
)
SELECT 
    production_company, 
    total_votes AS vote_count,
    RANK() OVER (ORDER BY total_votes DESC) AS prod_comp_rank
FROM 
    vote_counts
ORDER BY 
    total_votes DESC
LIMIT 3;









/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH indian_movies AS (
    SELECT 
        m.id AS movies_id,
        m.title,
        r.avg_rating,
        r.total_votes,
        rm.name_id
    FROM 
        movie AS m
    INNER JOIN 
        ratings AS r ON m.id = r.movie_id
    INNER JOIN 
        role_mapping AS rm ON m.id = rm.movie_id
    WHERE 
        m.country = 'India'
),
actor_ratings AS (
    SELECT 
        n.name AS actor_name,
        SUM(r.avg_rating * r.total_votes) / NULLIF(SUM(r.total_votes), 0) AS weighted_avg_rating,
        COUNT(*) AS movie_count,
        SUM(r.total_votes) AS total_votes
    FROM 
        indian_movies AS r
    INNER JOIN 
        names AS n ON r.name_id = n.id
    GROUP BY 
        n.name
    HAVING 
        COUNT(*) >= 5
)
SELECT 
    actor_name, 
    total_votes,
    weighted_avg_rating,
	movie_count, 
    RANK() OVER (ORDER BY weighted_avg_rating DESC, total_votes DESC) AS actor_rank
FROM actor_ratings
ORDER BY actor_rank
LIMIT 1;









-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH hindi_movies AS (
    SELECT 
        m.id AS movie_id,
        m.title,
        r.avg_rating,
        r.total_votes,
        rm.name_id
    FROM 
        movie AS m
    INNER JOIN 
        ratings AS r ON m.id = r.movie_id
    INNER JOIN 
        role_mapping AS rm ON m.id = rm.movie_id
    WHERE 
        m.country = 'India' AND
        m.languages LIKE '%Hindi%'
),
actress_ratings AS (
    SELECT 
        n.name AS actress_name,
        SUM(r.avg_rating * r.total_votes) / NULLIF(SUM(r.total_votes), 0) AS actress_avg_rating,
        COUNT(*) AS movie_count,
        SUM(r.total_votes) AS total_votes
    FROM 
        hindi_movies AS r
    INNER JOIN 
        names AS n ON r.name_id = n.id
    GROUP BY 
        n.name
    HAVING 
        COUNT(*) >= 3
)
SELECT 
    actress_name, 
    total_votes, 
    movie_count, 
    actress_avg_rating, 
    RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM 
    actress_ratings
ORDER BY 
    actress_rank
LIMIT 5;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    m.title,
    r.avg_rating,
    CASE 
        WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN r.avg_rating < 5 THEN 'Flop movies'
        ELSE 'Unknown'
    END AS category
FROM 
    movie AS m
INNER JOIN 
    ratings AS r ON m.id = r.movie_id
INNER JOIN 
    genre AS g ON m.id = g.movie_id
WHERE 
    g.genre = 'Thriller'
ORDER BY 
    r.avg_rating DESC;








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH genre_duration AS (
    SELECT 
        g.genre,
        AVG(m.duration) AS avg_duration
    FROM 
        movie AS m
    INNER JOIN 
        genre AS g ON m.id = g.movie_id
    GROUP BY 
        g.genre
),
running_totals AS (
    SELECT 
        genre,
        avg_duration,
        SUM(avg_duration) OVER (ORDER BY genre) AS running_total_duration,
        ROW_NUMBER() OVER (ORDER BY genre) AS row_num
    FROM 
        genre_duration
),
moving_avg AS (
    SELECT 
        genre,
        avg_duration,
        running_total_duration,
        AVG(avg_duration) OVER (ORDER BY row_num ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_duration
    FROM 
        running_totals
)
SELECT 
    genre,
    avg_duration,
    running_total_duration,
    moving_avg_duration
FROM 
    moving_avg
ORDER BY 
    genre;









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH genre_counts AS (
    SELECT 
        g.genre,
        COUNT(m.id) AS movie_count
    FROM 
        genre AS g
    INNER JOIN 
        movie AS m ON g.movie_id = m.id
    GROUP BY 
        g.genre
    ORDER BY 
        movie_count DESC
    LIMIT 3
),
top_movies AS (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        m.worlwide_gross_income,
        RANK() OVER (PARTITION BY g.genre, m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
    FROM 
        genre AS g
    INNER JOIN 
        movie AS m ON g.movie_id = m.id
    WHERE 
        g.genre IN (SELECT genre FROM genre_counts)
)
SELECT 
    genre,
    year,
    movie_name,
    worlwide_gross_income,
    movie_rank
FROM 
    top_movies
WHERE 
    movie_rank <= 5
ORDER BY 
    genre, year, movie_rank;

-- Top 3 Genres based on most number of movies










-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH multilingual_movies AS (
    SELECT 
        m.id AS movie_id,
        m.title,
        r.median_rating,
        m.production_company
    FROM 
        movie AS m
    INNER JOIN 
        ratings AS r ON m.id = r.movie_id
    WHERE 
        POSITION(',' IN m.languages) > 0  -- Checks if there is a comma in languages
),
hits AS (
    SELECT 
        production_company,
        COUNT(*) AS movie_count
    FROM 
        multilingual_movies
    WHERE 
        median_rating >= 8
    GROUP BY 
        production_company
),
ranked_hits AS (
    SELECT 
        production_company, 
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM 
        hits
)
SELECT 
    production_company, 
    movie_count,
    prod_comp_rank
FROM 
    ranked_hits
WHERE 
    prod_comp_rank <= 2
ORDER BY 
    prod_comp_rank;



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH drama_movies AS (
    SELECT 
        m.id AS movie_id,
        m.title,
        r.avg_rating,
        r.total_votes,
        g.genre
    FROM 
        movie AS m
    INNER JOIN 
        ratings AS r ON m.id = r.movie_id
    INNER JOIN 
        genre AS g ON m.id = g.movie_id
    WHERE 
        g.genre = 'Drama' 
        AND r.avg_rating > 8
),
actress_hits AS (
    SELECT 
        n.name AS actress_name,
        SUM(dm.total_votes) AS total_votes,
        COUNT(dm.movie_id) AS movie_count,
        AVG(dm.avg_rating) AS actress_avg_rating
    FROM 
        drama_movies AS dm
    INNER JOIN 
        role_mapping AS rm ON dm.movie_id = rm.movie_id
    INNER JOIN 
        names AS n ON rm.name_id = n.id
    WHERE 
        rm.category = 'Actress'  -- Filtering for actresses
    GROUP BY 
        actress_name
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    RANK() OVER (ORDER BY movie_count DESC) AS actress_rank
FROM 
    actress_hits
ORDER BY 
    actress_rank
LIMIT 3;  -- Get top 3 actresses







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_movies AS (
    SELECT 
        dm.name_id AS director_id,
        n.name AS director_name,
        COUNT(m.id) AS number_of_movies,
        SUM(m.duration) AS total_duration,
        AVG(r.avg_rating) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        MIN(m.date_published) AS first_movie_date,
        MAX(m.date_published) AS last_movie_date
    FROM 
        director_mapping AS dm
    INNER JOIN 
        movie AS m ON dm.movie_id = m.id
    INNER JOIN 
        ratings AS r ON m.id = r.movie_id
    INNER JOIN 
        names AS n ON dm.name_id = n.id
    GROUP BY 
        dm.name_id, n.name
),
inter_movie_dates AS (
    SELECT 
        director_id,
        director_name,
        first_movie_date,
        last_movie_date,
        LEAD(first_movie_date) OVER (PARTITION BY director_id ORDER BY first_movie_date) AS next_movie_date
    FROM 
        director_movies
)
SELECT 
    idm.director_id,
    idm.director_name,
    dm.number_of_movies,
    AVG(DATEDIFF(idm.next_movie_date, idm.first_movie_date)) AS avg_inter_movie_days,
    dm.avg_rating,
    dm.total_votes,
    dm.min_rating,
    dm.max_rating,
    dm.total_duration
FROM 
    inter_movie_dates AS idm
INNER JOIN 
    director_movies AS dm ON idm.director_id = dm.director_id
WHERE 
    dm.number_of_movies > 1
GROUP BY 
    idm.director_id, idm.director_name, dm.number_of_movies, dm.total_duration, dm.avg_rating, dm.total_votes, dm.min_rating, dm.max_rating
ORDER BY 
    dm.number_of_movies DESC
LIMIT 9;
