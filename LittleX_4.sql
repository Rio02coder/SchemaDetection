CREATE Database LittleX_4;

USE LittleX_4;

CREATE TABLE Profile (
    id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    tweets JSON, -- list of Tweet IDs
    followees JSON -- list of Profile IDs
);

CREATE TABLE Tweet (
    id INT PRIMARY KEY,
    content TEXT NOT NULL,
    likes JSON -- list of Profile IDs
);

SELECT followees FROM Profile WHERE id=10;

EXPLAIN ANALYZE 
SELECT t.id, t.content, t.likes
FROM Profile p
JOIN JSON_TABLE(
    CONCAT('[', JSON_QUOTE(CAST(p.id AS CHAR)), ',', p.followees, ']'), 
    '$[*]' COLUMNS(pid INT PATH '$')
) AS all_profiles
JOIN Profile pf ON pf.id = all_profiles.pid
JOIN JSON_TABLE(
    pf.tweets, '$[*]' COLUMNS(tweet_id INT PATH '$')
) AS jt
JOIN Tweet t ON t.id = jt.tweet_id
WHERE p.id = 10;


EXPLAIN ANALYZE SELECT p.id
FROM Profile p
JOIN JSON_TABLE(p.tweets, '$[*]' COLUMNS(tweet_id INT PATH '$')) AS jt
WHERE jt.tweet_id =800;

SELECT table_schema AS "Database",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = 'LittleX_4'
GROUP BY table_schema;