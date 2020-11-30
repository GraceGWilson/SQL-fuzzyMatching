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
-- SET @word = 'Recieve';


-- Here is a very basic approach (removing double m's) that returns
-- 2 of the 6 variants in the sample database when searching for 
-- 'immediately'.
-- SELECT * FROM word WHERE SUBSTR(misspelled_word,1,2) LIKE 'un%'; -- un or in 
 
 

 WITH cte AS
 (
 SELECT *, 
		CASE WHEN misspelled_word = @word THEN 0
             -- WHEN c_se = s_se THEN 0
			WHEN LEFT(dm(c_short),2) != LEFT(dm(s_short),2) THEN 200
            WHEN RIGHT(dm(c_short),1) != RIGHT(dm(s_short),1) THEN 200
            WHEN RIGHT(c_short,3) = RIGHT(s_short,3) THEN LEVENSHTEIN(misspelled_word,@word)
            WHEN RIGHT(c_short,2) = RIGHT(s_short,2) THEN LEVENSHTEIN(misspelled_word,@word)
            WHEN LEFT(c_short,4) = LEFT(s_short,4) THEN LEVENSHTEIN(misspelled_word,@word)
            WHEN LEFT(c_short,3) = LEFT(s_short,3) THEN LEVENSHTEIN(misspelled_word,@word)
            WHEN LEFT(c_short,2) = LEFT(s_short,2) THEN LEVENSHTEIN(misspelled_word,@word)
			-- WHEN new_c_se = new_s_se AND dm(c_short) = dm(s_short) THEN 0
			-- WHEN LEFT(misspelled_word,3) = LEFT(@word,3) THEN LEVENSHTEIN(misspelled_word,@word)
			 -- WHEN RIGHT(c_short,2) != RIGHT(s_short,2) THEN LEVENSHTEIN(misspelled_word,@word)
             -- WHEN dm(misspelled_word) = dm(@word) THEN LEVENSHTEIN(misspelled_word,@word)
			 ELSE 400
		 END AS dist
         -- dm(c_short),
		 -- dm(s_short)
 FROM(
  SELECT id, misspelled_word, 
  -- SOUNDEX(misspelled_word) AS c_se, 
  -- SOUNDEX(@word) AS s_se, 
  REGEXP_REPLACE(misspelled_word, '(ed|ing|s)$', '') AS c_short,
  REGEXP_REPLACE(@word, '(ed|ing|s)$', '') AS s_short
   FROM word
   WHERE SUBSTR(SOUNDEX(misspelled_word),2,3) LIKE SUBSTR(SOUNDEX(@word),2,3)
      OR LEFT(@word,3) LIKE LEFT(misspelled_word,3)
      OR RIGHT(REGEXP_REPLACE(@word, '(ed|ing|s)$', ''),3) LIKE RIGHT(REGEXP_REPLACE(misspelled_word, '(ed|ing|s)$', ''),3)
      ) AS T
)
SELECT * FROM cte
WHERE dist <= 3;

