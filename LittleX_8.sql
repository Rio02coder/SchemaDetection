CREATE Database LittleX_8;

USE LittleX_8;

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

CREATE TABLE Collaborators (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tweet_id INT,
    profiles JSON
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

CREATE INDEX idx_follower_id ON Follow(follower_id);

CREATE INDEX idx_tweet_id ON TweetLike(tweet_id);

CREATE INDEX idx_collaborator_id ON Collaborators(tweet_id);

CREATE INDEX idx_post_id ON Post(profile_id);

EXPLAIN ANALYZE
SELECT 
    t.id, 
    t.content, 
    GROUP_CONCAT(DISTINCT tl.profile_id) AS likes
FROM Tweet t
JOIN Post ps ON ps.tweet_id = t.id
JOIN Follow f ON ps.profile_id = f.followee_id
    AND f.follower_id = 10
LEFT JOIN TweetLike tl ON tl.tweet_id = t.id
GROUP BY t.id, t.content

UNION

SELECT 
    t.id, 
    t.content, 
    GROUP_CONCAT(DISTINCT tl.profile_id) AS likes
FROM Tweet t
JOIN Post ps ON ps.tweet_id = t.id
LEFT JOIN TweetLike tl ON tl.tweet_id = t.id
WHERE ps.profile_id = 10
GROUP BY t.id, t.content;


EXPLAIN ANALYZE SELECT jt.profile_id
FROM Collaborators c
JOIN JSON_TABLE(c.profiles, '$[*]' COLUMNS(profile_id INT PATH '$')) AS jt
WHERE c.tweet_id = 800;

SELECT table_schema AS "Database",
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
WHERE table_schema = 'LittleX_8'
GROUP BY table_schema;
