CREATE Database LittleX_1;

USE LittleX_1;

CREATE TABLE Profile (
    id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL
);

CREATE TABLE Tweet (
    id INT PRIMARY KEY,
    content TEXT NOT NULL
);

CREATE TABLE Post (
    id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT,
    tweet_id INT
);

CREATE TABLE TweetLike (
    id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT,
    tweet_id INT
);

CREATE TABLE Follow (
    follower_id INT,
    followee_id INT
);

EXPLAIN ANALYZE SELECT 
    Tweet.id AS tweet_id,
    Tweet.content,
    TweetLike.id AS like_count
FROM Post
JOIN Tweet ON Post.tweet_id = Tweet.id
LEFT JOIN TweetLike ON Tweet.id = TweetLike.tweet_id
WHERE Post.profile_id = 10
   OR Post.profile_id IN (
       SELECT followee_id 
       FROM Follow 
       WHERE follower_id = 10
   );


EXPLAIN ANALYZE SELECT profile_id 
FROM Post
WHERE tweet_id = 800;

SELECT table_schema AS "Database",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = 'LittleX_1'
GROUP BY table_schema;
