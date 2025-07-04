CREATE Database LittleX_3;

USE LittleX_3;

CREATE TABLE Profile (
    id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    tweets JSON -- list of Tweet IDs
);

CREATE TABLE Tweet (
    id INT PRIMARY KEY,
    content TEXT NOT NULL,
    likes JSON
);

CREATE TABLE Follow (
    follower_id INT,
    followee_id INT
);

CREATE INDEX idx_follower_id ON Follow(follower_id);

SELECT COUNT(*) FROM Profile;
SELECT COUNT(*) FROM Tweet;
SELECT COUNT(*) FROM Follow;

SELECT COUNT(followee_id) FROM Follow WHERE follower_id=10;

EXPLAIN ANALYZE SELECT t.id, t.content, t.likes
FROM Profile p
JOIN (
    SELECT followee_id AS pid FROM Follow WHERE follower_id = 10
    UNION ALL SELECT 10 AS pid
) AS all_profiles
JOIN Profile pf ON pf.id = all_profiles.pid
JOIN JSON_TABLE(pf.tweets, '$[*]' COLUMNS(tweet_id INT PATH '$')) AS jt
JOIN Tweet t ON t.id = jt.tweet_id;

EXPLAIN ANALYZE SELECT p.id
FROM Profile p
JOIN JSON_TABLE(p.tweets, '$[*]' COLUMNS(tweet_id INT PATH '$')) AS jt
WHERE jt.tweet_id = 800;

SELECT table_schema AS "Database",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = 'LittleX_3'
GROUP BY table_schema;