--1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT film_title, release_year,r.worldwide_gross
FROM specs as s
INNER JOIN revenue as r
ON s.movie_id=r.movie_id
ORDER BY r.worldwide_gross 
--Answer 1: Semi-Tough, 1977. Grossing= 37187139

--2. What year has the highest average imdb rating?
SELECT  s.release_year, avg(r.imdb_rating)
FROM specs as s
INNER JOIN rating as r
ON s.movie_id=r.movie_id
GROUP BY (s.release_year)
ORDER BY avg(r.imdb_rating) DESC
--Answer 2: 1991

--3. What is the highest grossing G-rated movie? Which company distributed it?
SELECT s.film_title, d.company_name, s.mpaa_rating, r.worldwide_gross
FROM specs as s
INNER JOIN distributors as d
ON s.domestic_distributor_id=d.distributor_id
INNER JOIN revenue as r
ON s.movie_id=r.movie_id
WHERE mpaa_rating='G'
ORDER BY (r.worldwide_gross)DESC
--Answer 3: Toy Story 4 by Walt Disney

--4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT company_name, d_id.titles_num
FROM distributors,
  (SELECT domestic_distributor_id, COUNT(*) AS titles_num
  FROM specs
  GROUP BY domestic_distributor_id) AS d_id
WHERE distributors.distributor_id=d_id.domestic_distributor_id 
ORDER BY titles_num DESC;

SELECT d.company_name, count (specs.film_title) as count
FROM distributors as d
LEFT JOIN specs on d.distributor_id=specs.domestic_distributor_id
GROUP BY d.company_name 
ORDER BY count (specs.film_title)

--5. Write a query that returns the five distributors with the highest average movie budget.
SELECT d.company_name, round(AVG(r.film_budget))as bud
FROM specs as s
INNER JOIN distributors as d
ON s.domestic_distributor_id=d.distributor_id
INNER JOIN revenue as r
USING(movie_id)
GROUP BY d.company_name
ORDER BY bud DESC
LIMIT 5;

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
SELECT s.film_title
, d.company_name
,r.imdb_rating,d.headquarters
FROM specs as s
INNER JOIN distributors as d
ON s.domestic_distributor_id=d.distributor_id
INNER JOIN rating as r
USING (movie_id)
WHERE d.headquarters NOT ILIKE '%, CA%'
GROUP BY s.film_title,d.company_name,r.imdb_rating,d.headquarters
ORDER BY r.imdb_rating DESC;
--ANSWER 6. 2 movies with Dirty Dancing as the highest imdb rating(7.0)

--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
SELECT
	CASE
		WHEN length_in_min<120 THEN 'under_2_hours'
		WHEN length_in_min>120 THEN 'over_2_hours'
		WHEN length_in_min=120 THEN 'exactly_2_hours'
	END AS under_over_exactly_2_hours,
	ROUND(AVG(imdb_rating),2)
FROM specs
INNER JOIN rating
ON specs.movie_id=rating.movie_id
GROUP BY under_over_exactly_2_hours


	