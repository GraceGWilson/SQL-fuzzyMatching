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
WITH CTE AS
(
SELECT id, misspelled_word 
FROM ( SELECT *, SUBSTR(misspelled_word,1,2) AS mf1, SUBSTR(misspelled_word,2,2) AS mf2, 
      		SUBSTR(misspelled_word,3,2) AS mf3, SUBSTR(misspelled_word,4,2) AS mf4, 
      		SUBSTR(misspelled_word,4,2) AS mf5, SUBSTR(misspelled_word,6,2) AS mf6,
                SUBSTR(misspelled_word,7,2) AS mf7, SUBSTR(misspelled_word,8,2) AS mf8, 
      		SUBSTR(misspelled_word,9,2) AS mf9, SUBSTR(misspelled_word,10,2) AS mf10,
      		SUBSTR(misspelled_word,11,2) AS mf11, SUBSTR(misspelled_word,12,2) AS mf12,
      		SUBSTR(REVERSE(misspelled_word),1,2) AS mr1, SUBSTR(REVERSE(misspelled_word),2,2) AS mr2,
                SUBSTR(REVERSE(misspelled_word),3,2) AS mr3, SUBSTR(REVERSE(misspelled_word),4,2) AS mr4,
                SUBSTR(REVERSE(misspelled_word),5,2) AS mr5, SUBSTR(REVERSE(misspelled_word),6,2) AS mr6, 
      		SUBSTR(REVERSE(misspelled_word),7,2) AS mr7, SUBSTR(REVERSE(misspelled_word),8,2) AS mr8,
      		SUBSTR(REVERSE(misspelled_word),9,2) AS mr9, SUBSTR(REVERSE(misspelled_word),10,2) AS mr10
      		-- SUBSTR(REVERSE(misspelled_word),11,2) AS mr11,SUBSTR(REVERSE(misspelled_word),12,2) AS mr12
	FROM word
	HAVING -- dm(@word) LIKE dm(misspelled_word) -- OR
		 SUBSTR(@word,1,2) IN (mf1, mf2, mf3) OR
		 SUBSTR(@word,2,2) IN (mf1, mf2, mf3, mf4) OR
		 SUBSTR(@word,3,2) IN (mf1, mf2, mf3, mf4, mf5) OR
		 SUBSTR(@word,4,2) IN (mf2, mf3, mf4, mf5, mf6) OR
     		 SUBSTR(@word,5,2) IN (mf3, mf4, mf5, mf6, mf7) OR
		 SUBSTR(@word,6,2) IN (mf4, mf5, mf6, mf7, mf8) OR
		 SUBSTR(@word,7,2) IN (mf5, mf6, mf7, mf8, mf9) OR
      		 SUBSTR(@word,8,2) IN (mf6, mf7,mf8,mf9,mf10)  OR
      		 SUBSTR(REVERSE(@word),1,2) IN (mr1, mr2, mr3) OR
      		 SUBSTR(REVERSE(@word),2,2) IN (mr1, mr2, mr3, mr4) OR 	
		 SUBSTR(REVERSE(@word),3,2) IN (mr1, mr2, mr3, mr4, mr5) OR
		 SUBSTR(REVERSE(@word),4,2) IN (mr2, mr3, mr4, mr5, mr6) OR
		 SUBSTR(REVERSE(@word),5,2) IN (mr3, mr4, mr5, mr6, mr7) OR
		 SUBSTR(REVERSE(@word),6,2) IN (mr4, mr5, mr6, mr7, mr8) OR
		 SUBSTR(REVERSE(@word),7,2) IN (mr5, mr6, mr7, mr8, mr9) OR
      		 SUBSTR(REVERSE(@word),8,2) IN (mr6, mr7, mr8, mr9, mr10) 
      		-- SUBSTR(REVERSE(@word),9,2) IN (mr6, mr8, mr9, mr10, mr11) 
      		-- SUBSTR(REVERSE(@word),10,2) IN (mr8, mr9, mr10, mr11, mr12)
	 ) AS t 
WHERE EXISTS (SELECT id FROM word as w where w.id = t.id AND ld_ratio(SOUNDEX(@word), SOUNDEX(misspelled_word)) >= 65)
)
SELECT * 
FROM CTE
WHERE EXISTS (SELECT id FROM word as w where w.id = CTE.id AND ld_ratio(@word, misspelled_word) >= 50); 
									      
