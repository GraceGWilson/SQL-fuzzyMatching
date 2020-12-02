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
-- SET @word = 'pumpkin';

-- calculate
-- comision
-- alcoholical
-- 'accomodation'
-- 'immediately'.
-- 'pumpkin'

SELECT id, misspelled_word ,ld_ratio(@word, misspelled_word)
FROM ( SELECT *
		FROM word
		WHERE  strcmp(SOUNDEX(misspelled_word), SOUNDEX(@word)) <= 1 AND
               RIGHT(SOUNDEX(misspelled_word),1) LIKE RIGHT(SOUNDEX(@word),1) AND
			  (SUBSTR(misspelled_word,2,2) SOUNDS LIKE SUBSTR(@word,2,2) OR
			   SUBSTR(REVERSE(misspelled_word),2,2) SOUNDS LIKE SUBSTR(REVERSE(@word),2,2))  
	 ) AS t 
WHERE EXISTS (SELECT id FROM word as w where w.id = t.id AND ld_ratio(@word, misspelled_word) >= 68);
-- ORDER BY ld_ratio(@word, misspelled_word) DESC;

