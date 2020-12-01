-- You will find a dump of a sample database (misspellings.sql) in our
-- shared data folder. This is essentially the same list of misspellings
-- we used in our Python lab, so you can use that source data file to 
-- check your accuracy.

-- We will use a more extensive database on our server
-- for official scoring. You can assume the table and column names
-- remain the same.


-- You can uncomment this for testing, but leave it commented out
-- when you submit your script.
USE misspellings;


-- You can uncomment this for testing, but leave it commented out
-- when you submit your script. The system will set this variable to 
-- various target words when scoring your query.
-- SET @word = 'pumpkin';

-- calculate
-- comision
-- alcoholical
-- 'accomodate'
-- 'immediately'.
-- 'pumpkin'

SELECT *
FROM ( SELECT *
		FROM word 
		WHERE ABS(CHAR_LENGTH(SOUNDEX(misspelled_word))  - CHAR_LENGTH(SOUNDEX(@word))) <= 2 AND
			  SUBSTR(SOUNDEX(misspelled_word),1,2) = SUBSTR(SOUNDEX(@word),1,2) OR
			  SUBSTR(SOUNDEX(misspelled_word),2,2) = SUBSTR(SOUNDEX(@word),2,2) OR
			  SUBSTR(SOUNDEX(misspelled_word),3,2) = SUBSTR(SOUNDEX(@word),3,2)
	 ) AS T
WHERE EXISTS (SELECT id FROM word as w where w.id = t.id AND ld_ratio(@word, misspelled_word) > 75 AND ld(SOUNDEX(@word),SOUNDEX(misspelled_word)) < 2);
 
 -- AND ld(SOUNDEX(@word),SOUNDEX(misspelled_word)) < 2;  
-- ld_ratio(@word, misspelled_word) > 70; -- ld(@word, misspelled_word) < 3 -- AND ld_ratio(SOUNDEX(@word),SOUNDEX(misspelled_word)) >75)

         -- id, 
		-- misspelled_word
		-- @word,
        -- ld(@word, misspelled_word) AS dist,
		-- ld_ratio(@word,misspelled_word) AS ratio,
        -- ld_ratio(SOUNDEX(@word),SOUNDEX(misspelled_word)) AS se_ratio

	-- WHERE -- LEFT(SOUNDEX(misspelled_word),1) = LEFT(SOUNDEX(@word),1)
    -- SUBSTR(SOUNDEX(misspelled_word),1,3) = SUBSTR(SOUNDEX(@word),1,3) OR
    -- SUBSTR(SOUNDEX(misspelled_word),2,3) = SUBSTR(SOUNDEX(@word),2,3) OR
    -- SUBSTR(SOUNDEX(misspelled_word),3,3) = SUBSTR(SOUNDEX(@word),3,3) OR
    -- SUBSTR(REVERSE(SOUNDEX(misspelled_word)),1,3) = SUBSTR(REVERSE(SOUNDEX(@word)),1,3) OR
    -- SUBSTR(REVERSE(SOUNDEX(misspelled_word)),2,3) = SUBSTR(REVERSE(SOUNDEX(@word)),2,3) OR
    -- SUBSTR(REVERSE(SOUNDEX(misspelled_word)),3,3) = SUBSTR(REVERSE(SOUNDEX(@word)),3,3) 

/*
SELECT *,-- , @word,
		ld(REGEXP_SUBSTR(dm(@word),'^[^;]+'),REGEXP_SUBSTR(dm(misspelled_word),'^[^;]+')), 
        ld_ratio(REGEXP_SUBSTR(dm(@word),'^[^;]+'),REGEXP_SUBSTR(dm(misspelled_word),'^[^;]+')) AS dm_ratio,
        ld_ratio(@word,misspelled_word) AS ratio
FROM word AS w
WHERE id IN (
WITH cte_sel AS
( SELECT * , REGEXP_SUBSTR(dm(misspelled_word),'^[^;]+') AS dm_ms,
			REGEXP_SUBSTR(dm(@word),'^[^;]+') AS dm_w
    FROM (SELECT * 
			FROM word 
			WHERE ABS(CHAR_LENGTH(SOUNDEX(misspelled_word))  - CHAR_LENGTH(SOUNDEX(@word))) <= 4
                -- AND RIGHT(SOUNDEX(misspelled_word),1) = RIGHT(SOUNDEX(@word),1)
				-- OR SUBSTR(SOUNDEX(misspelled_word),2,1) LIKE SUBSTR(SOUNDEX(@word),2,2)
            ) AS T
	WHERE LEFT(REGEXP_SUBSTR(dm(misspelled_word),'^[^;]+'),1) LIKE LEFT(REGEXP_SUBSTR(dm(@word),'^[^;]+'),1)
    OR SUBSTR(REGEXP_SUBSTR(dm(misspelled_word),'^[^;]+'),1,3) LIKE SUBSTR(REGEXP_SUBSTR(dm(@word),'^[^;]+'),1,2)
	OR SUBSTR(REGEXP_SUBSTR(dm(misspelled_word),'^[^;]+'),2,3) LIKE SUBSTR(REGEXP_SUBSTR(dm(@word),'^[^;]+'),2,2)
	OR SUBSTR(REGEXP_SUBSTR(dm(misspelled_word),'^[^;]+'),3,3) LIKE SUBSTR(REGEXP_SUBSTR(dm(@word),'^[^;]+'),3,2)
	)
SELECT (SELECT id 
		 FROM cte_sel 
		 WHERE cte_sel.id = L.id 
         -- AND ld_ratio(@word, cte_sel.misspelled_word) > 69) AS id
          AND ld_ratio(cte_sel.dm_w, cte_sel.dm_ms) > 79
          AND ld_ratio(@word, cte_sel.misspelled_word) > 74) AS id
FROM cte_sel AS L);
*/

/*
SELECT * FROM word;

SELECT *,ld_ratio(@word, misspelled_word) AS ratio,
       ld(dm(@word),dm(misspelled_word)) AS dm_dist,
	   ld(@word,misspelled_word) AS dist,
       dm(@word),dm(misspelled_word),
       SOUNDEX(misspelled_word),
       SOUNDEX(@word)
FROM word
WHERE ABS(CHAR_LENGTH(SOUNDEX(misspelled_word))  - CHAR_LENGTH(SOUNDEX(@word))) <= 3
ORDER BY ratio DESC;
-- calulate vs cauclate vs calculate -> need for dm NOT SOUNDEX
-- commitee

SELECT *, dm(@word),dm(misspelled_word), REGEXP_SUBSTR(dm(misspelled_word),'^[^;]+') AS new_s
FROM word
WHERE misspelled_word LIKE 'd%' ;
*/