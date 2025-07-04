CREATE database LittleX_5;

USE LittleX_5;

CREATE TABLE Profile (
    id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL
);

CREATE TABLE Tweet (
    id INT PRIMARY KEY,
    content TEXT NOT NULL,
    profiles JSON -- list of Profile IDs
);

CREATE TABLE Follow (
    follower_id INT,
    followee_id INT
);

CREATE TABLE TweetLike (
    profile_id INT,
    tweet_id INT
);

CREATE INDEX idx_follower_id ON Follow(follower_id);

CREATE INDEX idx_tweet_id ON TweetLike(tweet_id);

EXPLAIN ANALYZE SELECT t.id, t.content, GROUP_CONCAT(DISTINCT tl.profile_id) AS likes
FROM Tweet t
JOIN TweetLike tl ON tl.tweet_id = t.id
JOIN JSON_TABLE(t.profiles, '$[*]' COLUMNS(profile_id INT PATH '$')) AS jt
JOIN (
    SELECT followee_id FROM Follow WHERE follower_id = 10
    UNION SELECT 10 AS followee_id
) AS all_profiles ON all_profiles.followee_id = jt.profile_id
GROUP BY t.id, t.content;

EXPLAIN ANALYZE SELECT jt.profile_id
FROM Tweet t
JOIN JSON_TABLE(t.profiles, '$[*]' COLUMNS(profile_id INT PATH '$')) AS jt
WHERE t.id = 800;

SELECT table_schema AS "Database",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = 'LittleX_5'
GROUP BY table_schema;
