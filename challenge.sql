-- You will find a dump of a sample database (misspellings.sql) in our
-- shared data folder. This is essentially the same list of misspellings
-- we used in our Python lab, so you can use that source data file to 
-- check your accuracy.

-- We will use a more extensive database on our server
-- for official scoring. You can assume the table and column names
-- remain the same.


-- You can uncomment this for testing, but leave it commented out
-- when you submit your script.
-- USE misspellings;


-- You can uncomment this for testing, but leave it commented out
-- when you submit your script. The system will set this variable to 
-- various target words when scoring your query.
SET @word = 'immediately';

-- 'immediately'.
-- 'pumpkin'
-
-- SELECT *
-- ld_ratio(@word, misspelled_word) AS ratio,
-- ld(@word,misspelled_word) AS dist,
-- dm(@word),dm(misspelled_word),
-- SOUNDEX(misspelled_word)


SELECT * -- , ld(dm(@word),dm(misspelled_word)), ld_ratio(@word,misspelled_word) AS ratio
FROM word AS w
WHERE id IN (
WITH cte_sel AS
( SELECT *, ld(dm(@word),dm(misspelled_word)) AS dm_dist
    FROM (SELECT * FROM word WHERE ABS(CHAR_LENGTH(SOUNDEX(misspelled_word))  - CHAR_LENGTH(SOUNDEX(@word))) <= 2) AS T
	WHERE SUBSTR(SOUNDEX(misspelled_word),2,2) LIKE SUBSTR(SOUNDEX(@word),2,2)
    OR LEFT(SOUNDEX(misspelled_word),2) LIKE LEFT(SOUNDEX(@word),2)
	OR LEFT(@word,2) LIKE LEFT(misspelled_word,2)
    )
SELECT (SELECT id FROM cte_sel WHERE cte_sel.id = L.id AND cte_sel.dm_dist <2) AS id 
FROM cte_sel AS L)
AND ld_ratio(@word,misspelled_word) > 80;
