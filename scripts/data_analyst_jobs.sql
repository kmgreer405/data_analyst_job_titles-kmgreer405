-- 1.	How many rows are in the data_analyst_jobs table?
SELECT COUNT(*)
FROM data_analyst_jobs;

-- 1793 rows

-- 2.	Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?
SELECT *
FROM data_analyst_jobs
LIMIT 10;

-- Exxon Mobil

-- 3.	How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location = 'TN'; 

-- There are 21 postings in Tennessee
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location = 'TN'
OR location = 'KY';

-- There are 27 postings in Tennessee or Kentucky

SELECT COUNT(*) AS ky_tn,
	(SELECT COUNT(*)
	FROM data_analyst_jobs
	WHERE location = 'TN') AS tn
FROM data_analyst_jobs
WHERE location in ('TN', 'KY');

-- Both at the same time.

-- 4.	How many postings in Tennessee have a star rating above 4?
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE location = 'TN'
AND star_rating > 4;

-- There are 3 postings

-- 5.	How many postings in the dataset have a review count between 500 and 1000?
SELECT COUNT(*)
FROM data_analyst_jobs
WHERE review_count
	BETWEEN 500 AND 1000;
	
-- 151 Postings

-- 6.	Show the average star rating for companies in each state. The output should show the state as `state` and the average rating for the state as `avg_rating`. Which state shows the highest average rating?
SELECT location AS state, AVG(star_rating) AS avg_rating
FROM data_analyst_jobs
GROUP BY location
ORDER BY AVG(star_rating) DESC;

--Nebraska has the highest average

-- 7.	Select unique job titles from the data_analyst_jobs table. How many are there?
SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs;

--881 Titles

-- 8.	How many unique job titles are there for California companies?
SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs
WHERE location = 'CA';

--230 Titles

-- 9.	Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?
SELECT company, AVG(star_rating)
FROM data_analyst_jobs
WHERE review_count > 5000
AND company IS NOT NULL
GROUP BY company;

--40 Companies

-- 10.	Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?
SELECT company, AVG(star_rating)
FROM data_analyst_jobs
WHERE review_count > 5000
AND company IS NOT NULL
GROUP BY company
ORDER BY AVG(star_rating) DESC;

--General Motors has the highest average rating at 4.19

-- 11.	Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? 
SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs
WHERE LOWER(title) LIKE '%analyst%';

--774 job titles

-- 12.	How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?
SELECT title
FROM data_analyst_jobs
WHERE LOWER(title) NOT LIKE '%analyst%'
AND LOWER(title) NOT LIKE '%analytics%';

--4 titles do not contain these two words. The most common word among these titles is "tableau"

-- **BONUS:**
-- You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks. 
--  - Disregard any postings where the domain is NULL. 
--  - Order your results so that the domain with the greatest number of `hard to fill` jobs is at the top. 
--   - Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?
SELECT domain, COUNT(domain)
FROM data_analyst_jobs
WHERE skill LIKE '%SQL%'
AND days_since_posting > 21
AND domain IS NOT NULL
GROUP BY domain
ORDER BY COUNT(domain) DESC;

-- Top 4 Industries
-- 1) Internet and Software 62 postings
-- 2) Banks and Financial Services 61 postings
-- 3) Consulting and Business Services 57 postings
-- 4) Health Care 52 postings

-- 1. For each company, give the company name and the difference between its star rating and the national average star rating.
SELECT DISTINCT(company), (star_rating - avg_star ) AS star_avg
FROM data_analyst_jobs,
	(SELECT AVG(star_rating) AS avg_star
	FROM data_analyst_jobs) AS daj2
ORDER BY company;
	
-- 2. Using a correlated subquery: For each company, give the company name, its domain, its star rating, and its domain average star rating
SELECT DISTINCT(company), d1.domain, star_rating, avg_domain
FROM data_analyst_jobs AS d1,
	(SELECT DISTINCT(domain), AVG(star_rating) AS avg_domain
	FROM data_analyst_jobs
	GROUP BY domain) AS d2
GROUP BY company, d1.domain, d1.star_rating, avg_domain;


-- 3. Repeat question 2 using a CTE instead of a correlated subquery
WITH my_cte AS (
	SELECT DISTINCT(domain), AVG(star_rating) AS avg_domain
	FROM data_analyst_jobs
	GROUP BY domain
)
SELECT DISTINCT(company), d2.domain, star_rating, avg_domain
FROM data_analyst_jobs AS d2
JOIN my_cte ON d2.domain = my_cte.domain
GROUP BY company, d2.domain, star_rating, avg_domain;