CREATE Database LittleX_2;

USE LittleX_2;

CREATE TABLE Profile (
    id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    tweets JSON
);

CREATE TABLE Tweet (
    id INT PRIMARY KEY,
    content TEXT NOT NULL
);

CREATE TABLE Follow (
    follower_id INT,
    followee_id INT
);

CREATE TABLE TweetLike (
    profile_id INT,
    tweet_id INT
);

CREATE INDEX idx_tweet_id ON TweetLike(tweet_id);
CREATE INDEX idx_follower_id ON Follow(follower_id);

SHOW tables;

SELECT COUNT(*) FROM Profile;
SELECT COUNT(*) FROM Tweet;
SELECT COUNT(*) FROM Follow;
SELECT COUNT(*) FROM TweetLike;

EXPLAIN ANALYZE
SELECT 
    t.id AS tweet_id,
    t.content,
    GROUP_CONCAT(DISTINCT tl.profile_id) AS likes
FROM (
    SELECT followee_id AS pid FROM Follow WHERE follower_id = 10
    UNION ALL SELECT 10
) AS all_profiles
JOIN Profile pf ON pf.id = all_profiles.pid
JOIN JSON_TABLE(pf.tweets, '$[*]' COLUMNS(tweet_id INT PATH '$')) AS jt
JOIN Tweet t ON t.id = jt.tweet_id
LEFT JOIN TweetLike tl ON tl.tweet_id = t.id
GROUP BY t.id, t.content;

SELECT COUNT(followee_id) FROM Follow WHERE follower_id=20; -- Should be 11


EXPLAIN ANALYZE SELECT p.id
FROM Profile p
JOIN JSON_TABLE(p.tweets, '$[*]' COLUMNS(tweet_id INT PATH '$')) AS jt
WHERE jt.tweet_id = 800;

SELECT table_schema AS "Database",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = 'LittleX_2'
GROUP BY table_schema;