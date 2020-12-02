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
 -- SET @word = 'calculate';

-- calculate (8)
-- commission
-- alcoholical
-- 'accomodation'
-- 'immediately'.
-- 'pumpkin'

SELECT id, misspelled_word , ld_ratio(@word, misspelled_word)
FROM ( SELECT *
		FROM word
		WHERE  SUBSTR(@word,1,3) IN (SUBSTR(misspelled_word,1,3), SUBSTR(misspelled_word,2,3),
									 SUBSTR(misspelled_word,3,3),SUBSTR(misspelled_word,4,3)) OR
			   SUBSTR(@word,2,3) IN (SUBSTR(misspelled_word,1,3), SUBSTR(misspelled_word,2,3),
									 SUBSTR(misspelled_word,3,3),SUBSTR(misspelled_word,4,3)) OR
				SUBSTR(@word,3,3) IN (SUBSTR(misspelled_word,1,3), SUBSTR(misspelled_word,2,3),
									 SUBSTR(misspelled_word,3,3),SUBSTR(misspelled_word,4,3)) OR
				SUBSTR(@word,4,3) IN (SUBSTR(misspelled_word,1,3), SUBSTR(misspelled_word,2,3),
									 SUBSTR(misspelled_word,3,3),SUBSTR(misspelled_word,4,3)) OR
               SUBSTR(REVERSE(@word),1,3) IN (SUBSTR(REVERSE(misspelled_word),1,3),SUBSTR(REVERSE(misspelled_word),2,3), 
                                              SUBSTR(REVERSE(misspelled_word),3,3),SUBSTR(REVERSE(misspelled_word),4,3)) OR
			   SUBSTR(REVERSE(@word),2,3) IN (SUBSTR(REVERSE(misspelled_word),1,3),SUBSTR(REVERSE(misspelled_word),2,3), 
                                              SUBSTR(REVERSE(misspelled_word),3,3),SUBSTR(REVERSE(misspelled_word),4,3)) OR 	
			   SUBSTR(REVERSE(@word),3,3) IN (SUBSTR(REVERSE(misspelled_word),1,3),SUBSTR(REVERSE(misspelled_word),2,3), 
                                              SUBSTR(REVERSE(misspelled_word),3,3),SUBSTR(REVERSE(misspelled_word),4,3)) OR
			   SUBSTR(REVERSE(@word),4,3) IN (SUBSTR(REVERSE(misspelled_word),1,3),SUBSTR(REVERSE(misspelled_word),2,3), 
                                              SUBSTR(REVERSE(misspelled_word),3,3),SUBSTR(REVERSE(misspelled_word),4,3))
	 ) AS t 
WHERE EXISTS (SELECT id FROM word as w where w.id = t.id AND ld_ratio(@word, misspelled_word) > 60); 

-- ORDER BY ld_ratio(@word, misspelled_word) DESC;

/*
SELECT id, misspelled_word
  FROM word 
 WHERE misspelled_word SOUNDS LIKE @word;
 */
